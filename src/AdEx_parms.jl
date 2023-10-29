using Unitful: ms, nA, pA, nS, mV, pF, uconvert


# Brette and Gerstner 2005
brette_2005 = (
    tauw = 144.0ms,    # adaptation time constant
    a = 4.0nS,         # subthreshold adaptation 
    b = 80.5pA,        # spike-triggered adaptation 
    Vr = -70.6mV,      # reset value 
    C = 281pF,         # membrane capacitance
    gL = 30.0nS,       # leak conductance
    EL = -70.6mV,      # leak reversal / resting potential
    VT = -50.4mV,      # spike threshold
    dT = 2.0mV,        # slope factor
    cutoff = 0mV,     # spike cutoff value
    Ie = 1.0nA         # external injected current_stop
)


# firing pattern a (tonic firing pattern)
fp_a = (
    tauw = 30.0ms,
	a = 2.0nS,
	b = 0.0nA,
	Vr = -58.0mV,
	C = 200pF,
	gL = 10.0nS,
	EL = -70.6mV,
	VT = -50.4mV,
	dT = 2.0mV,
	cutoff = 0mV,
	Ie = 0.5nA
)


# firing pattern b (adapting firing pattern)
fp_b = (
    tauw = 300.0ms,
	a = 2.0nS,
	b = 0.06nA,
	Vr = -58.0mV,
	C = 200pF,
	gL = 12.0nS,
	EL = -70.6mV,
	VT = -50.4mV,
	dT = 2.0mV,
	cutoff = 0mV,
	Ie = 0.5nA
)
	

# firing pattern c (brusting, initial + single)
fp_c = (
    tauw = 150.0ms,
	a = 4.0nS,
	b = 0.12nA,
	Vr = -50.0mV,
	C = 130pF,
	gL = 18.0nS,
	EL = -58.0mV,
	VT = -50.0mV,
	dT = 2.0mV,
	cutoff = 0mV,
	Ie = 0.4nA
)


# firing pattern d (brusting, initial + bursts)
fp_d = (
    tauw = 120.0ms,
	a = 2.0nS,
	b = 0.1nA,
	Vr = -46.0mV,
	C = 200pF,
	gL = 10.0nS,
	EL = -58.0mV,
	VT = -50.0mV,
	dT = 2.0mV,
	cutoff = 0mV,
	Ie = 0.4nA
)


# firing pattern e (transient spiking pattern)
fp_e = (
    tauw = 90.0ms,
	a = 10.0nS,
	b = 0.1nA,
	Vr = -47.0mV,
	C = 100pF,
	gL = 10.0nS,
	EL = -70.6mV,
	VT = -50.0mV,
	dT = 2.0mV,
	cutoff = 0mV,
	Ie = 0.25nA
)


# firing pattern f (irregular spiking pattern)
fp_f = (
    tauw = 130.0ms,
	a = -11.0nS,
	b = 0.03nA,
	Vr = -48.0mV,
	C = 100pF,
	gL = 12.0nS,
	EL = -65.0mV,
	VT = -50.0mV,
	dT = 2.0mV,
	cutoff = 0mV,
	Ie = 0.16nA
)
