import sachConvert
sc = sachConvert

# constants
rho_H2O = 997.16 # kg/m^3


Q_gpms = floor(linspace(1,150,10))

results =  Array{Float64}(0)
for Q_gpm in Q_gpms
	# PUMPING rate
	# Convert gpm to kg/s
	Q_lpm = Q_gpm * 3.78541
	Q_m3ps = Q_lpm/1000/60
	Q_kgps = Q_m3ps*rho_H2O
	Q_m3pd = Q_m3ps*86400 
	@printf("H2O Injection rate = %0.6f kg/s\n",Q_kgps)

	# ~1000 kg of dithioinite
	inj_conc = 0.05 # M
	inj_dt = 2 # days
	MW_Na2S2O4 = 174.11 # g/mole
	dithionite_mass = Q_lpm * (inj_dt*24*60) * (inj_conc*MW_Na2S2O4/1000)
	@printf("Total mass = %0.6f kg\n",dithionite_mass)
	append!(results,Q_kgps)
end
