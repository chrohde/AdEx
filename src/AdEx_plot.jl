using CairoMakie: lines
using Unitful: upreferred, ustrip, ms

function plot_pattern(solution)
	# convert solution of state variables to matrix
	solution_matrix = reduce(hcat, solution.u)'
	solution_matrix = solution_matrix |> x -> map(upreferred, x) |> x -> map(ustrip, x)
	
	# convert and remove units
	vs = solution_matrix[:,1]
	#ws = solution_matrix[:,2]
		
	# maximize V with 20 mV (spikes)
    vs[vs .> 0.0] .= 0.020

    # plot
    if typeof(solution.t[1]) == typeof(1.0ms)
	    return lines(solution.t / ms, vs, color = :blue, linewidth = 2)
    else
        return lines(solution.t, vs, color = :blue, linewidth = 2)
    end
end
