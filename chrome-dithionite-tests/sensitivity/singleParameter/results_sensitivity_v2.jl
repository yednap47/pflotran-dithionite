# Id: getTotalCr3.jl, Mon 05 Jun 2017 09:54:45 AM MDT pandeys #
# Created by Sachin Pandey, LANL
# Description: For an individual run, read the h5 file and calculate total 
#   number of moles of Cr(III) produced at a certain timestep
#------------------------------------------------------------------------------
using sachFun

#------------------------------------------------------------------------------
# User info
#------------------------------------------------------------------------------
myvar = ["Global fast_Fe++", "Global slow_Fe++", "east A(aq) [mol]","east CrO4-- [mol]","east S2O4-- [mol]","east O2(aq) [mol]"]
sensparam = "k_s2o4_fe3"
istop = 3 # parameter we care about

# pflotran information
basedir = "/lclscratch/sach/Programs/pflotran-dithionite-git/chrome-dithionite-tests/sensitivity/singleParameter"
rundir = "attempt4"
myname = "1d-allReactions-10m-uniformVelocity"
coord_name = "X"

# Get grid information for calculating volumes
dx= vcat(0.01*ones(200),0.1*ones(40),0.2*ones(20))
dy = 0.1
dz = 0.1

#------------------------------------------------------------------------------
# Initialize
#------------------------------------------------------------------------------
volumes = dx*dy*dz
summary = Dict()


# get the results for this run
filename = joinpath(basedir,rundir,sensparam,"run$istop","$(myname)-mas.dat")
results = sachFun.readObsDataset(filename,myvar,dataframe=true)

# get the results for this run
filename = "./basecase_norxn/$(myname)-mas.dat"
results_base = sachFun.readObsDataset(filename,myvar,dataframe=true)

#------------------------------------------------------------------------------
# Calculate the total number of moles of Cr that was immobilized
#------------------------------------------------------------------------------
warn("need more norxn base cases for this to work (q)")
summary["tot mol cr reduced"] = abs(results_base[Symbol("east CrO4-- [mol]")][end])-abs(results[Symbol("east CrO4-- [mol]")][end])

#------------------------------------------------------------------------------
# Calculate the maximum amount of Fe reduced
#------------------------------------------------------------------------------
total_sboundfe2 = results[Symbol("Global fast_Fe++")] + results[Symbol("Global slow_Fe++")]
summary["max tot mol fe2 produced"] = maximum(total_sboundfe2)

#------------------------------------------------------------------------------
# Calculate the maximum fraction of iron reduced
#------------------------------------------------------------------------------
MV_feoh3 = 34.36/(100)^3 # m^3/mol
if sensparam !== "ifeoh3"
    ivf_feoh3 = 3.86e-3
else
    warn("need to add code here")
end

# calculate moles using m^3/m^3_bulk, dxyz and molar volume
max_tot_mol_fe3 = sum(ivf_feoh3*volumes/MV_feoh3)
summary["max percent reducedfe"] = summary["max tot mol fe2 produced"]/max_tot_mol_fe3 * 100

#------------------------------------------------------------------------------
# Calculate the amount of o2 consumed
#------------------------------------------------------------------------------
warn("need more norxn base cases for this to work (q)")
summary["tot mol o2 consumed"] = abs(results_base[Symbol("east O2(aq) [mol]")][end])-abs(results[Symbol("east O2(aq) [mol]")][end])

#------------------------------------------------------------------------------
# Calculate the amount of s2o4 consumed
#------------------------------------------------------------------------------
warn("need more norxn base cases for this to work (q AND is2o4)")
summary["tot mol s2o4 consumed"] = abs(results_base[Symbol("east S2O4-- [mol]")][end])-abs(results[Symbol("east S2O4-- [mol]")][end])
