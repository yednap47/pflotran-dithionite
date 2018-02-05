

concs = linspace(0.001,0.5,10)

results = Array{Float64}(0)
for conc in concs
	@printf "%0.4e " conc
	@printf "%0.4e\n" conc*2
	# println("$conc $(conc*2)")
	append!(results,conc)
end
