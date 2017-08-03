# constants
rho_H2O = 997.16 # kg/m^3

# PUMPING rate
# Convert gpm to kg/s
Q_gpm = 15 # gallons/min
Q_lpm = Q_gpm * 3.78541
Q_m3ps = Q_lpm/1000/60
Q_kgps = Q_m3ps*rho_H2O
Q_m3pd = Q_m3ps*86400 
@printf("H2O Injection rate = %0.6f kg/s\n",Q_kgps)
#@printf("Volumetric rate = %0.2f m^3/d\n",Q_m3pd)

# ~1000 kg of dithioinite
inj_conc = 0.05 # M
inj_dt = 2 # days
MW_Na2S2O4 = 174.11 # g/mole
dithionite_mass = Q_lpm * (inj_dt*24*60) * (inj_conc*MW_Na2S2O4/1000)


# Fruchter GWMR 
fruchter = Dict()
fruchter["V_solution"] = 77000 # L
fruchter["Conc_solution"] = 0.1 # M
fruchter["dithioinite_mass"] = fruchter["V_solution"] * fruchter["Conc_solution"] * MW_Na2S2O4 / 1000


# How many processes per node?
ncomp = 13
ncells = 125*75
ppernode = 10000
nprocs = (ncomp+1)*ncells/ppernode
println("$nprocs processors required")
