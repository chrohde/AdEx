#using Unitful: upreferred, ustrip, ms

function spike_count(solution)
	# convert solution of state variables to matrix
	solution_matrix = reduce(hcat, solution.u)'
	
	# convert and remove units
	spikes = solution_matrix[:,4]
    
    return sum(spikes)
end
