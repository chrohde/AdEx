using DifferentialEquations: ODEProblem, CallbackSet, DiscreteCallback, PresetTimeCallback, solve, Euler, Tsit5
using Unitful: ms, nA, pA, nS, mV, pF, upreferred, ustrip, uconvert


function simulate(parms, interval, current_interval, use_units::Bool = true, current = nothing)
	# Simulates the AdEx model
	#	- params:
	#       parms:              model parameters with units (NamedTuple)
    #       interval:           start, end of simulation with units (Tuple)
    #       current_interval:   start, end of step current with units (Tuple)
    #       current:            manually set injected current, overwrite parms.Ie (float * A)
    #       use_units:          simulate with units (Bool)


    # set initial parameters
    initial = [parms.EL, 0.0nA, 0.0nA, 0]

    # helper function to drop units
    function drop_units(parms)
        # upreferred > converting to quantities to 10^0, i.e. removing the metric prefixes
        # ustrip > stripping units
        return parms |> x -> map(upreferred, x) |> x -> map(ustrip, x)
    end

    if current === nothing
        current = parms.Ie
    end


    # check if to drop units
    if use_units == false
        # drop units
        parms = drop_units(parms)
        initial = drop_units(initial)
        interval = drop_units(interval)
        current_interval = drop_units(current_interval)
    end


    # defines the AdEx model
    function model!(du, u, p, t)
        # to be used within ODEProblem (DifferentialEquations)
        # params:
        #	du: differential equations (ODEProblem internal variable)
        #   u:  state variables (ODEProblem internal variable)
        #   t:  time variable (ODEProblem internal variable)
        #   p:  model parameters (NamedTuple)
        
        # model parameters
        # destructure a NamedTuple (feature since Julia 1.7)
        (; gL, EL, C, VT, dT, tauw, a) = p

        # model variables
        V, w, I, _ = u

        # reset spike recorder
        u[4] = 0

        # define differential equations 
        # du[1] = dV
        du[1] = (-gL * (V - EL) + gL * dT * exp((V - VT) / dT) + I - w) / C
        # du[2] = dw
        du[2] = (a * (V - EL) - w) / tauw
    end


    # reset condition for AdEx model
    function cutoff(u, t, integrator)
        # to be used within ODEProblem as callback
        # all variables internal for callback
        
        # condition: if V (u[1] is V, see model function) reaches cutoff
        # parameter settings usually use cutoff = 0 mV
        integrator.u[1] >= integrator.p.cutoff
    end


    # reset function for AdEx model
    function reset!(integrator)
        # to be used within ODEProblem as callback
        # all variables internal for callback
        
        # reset variable V to parameter EL (u[1] is V)
        integrator.u[1] = integrator.p.Vr

        # increase variable w by parameter b (u[2] is w)
        integrator.u[2] += integrator.p.b

        # record a spike (u[4] is counts)
        integrator.u[4] = 1
    end


    # define reset condition as DiscreteCallback
    # with condition cutoff and action reset!
    reset_condition = DiscreteCallback(cutoff, reset!)

    # set injected current, onset at 50ms
    current_start = PresetTimeCallback(current_interval[1],
        integrator -> integrator.u[3] = use_units ? current : drop_units(current))

    # set injected current back to zero at 250ms
    current_stop = PresetTimeCallback(current_interval[2],
        integrator -> integrator.u[3] = use_units ? 0.0nA : 0.0)

    # gather all callback into CallbackSet for ODEProblem
    cb = CallbackSet(current_start, current_stop, reset_condition)

    # define ODEProblem
    #prob = ODEProblem(model!, initial, interval, parms, callback = cb)
    prob = ODEProblem(model!, initial, interval, parms, callback = cb)

    # solver for ODEProblem

    if use_units
        return solve(prob, Euler(), dt = 0.1ms)
    else
        #return solve(prob, Euler(), dt = drop_units(0.1*ms))
        return solve(prob, Tsit5(), reltol=1e-7, abstol=1e-7, dtmin=1e-40, force_dtmin=true)
        #return solve(prob, Rosenbrock23(), reltol=1e-7, abstol=1e-7, dtmin=1e-10, force_dtmin=true)
    end
end
