# Id: getTotalCr3.jl, Mon 05 Jun 2017 09:54:45 AM MDT pandeys #
# Created by Sachin Pandey, LANL
# Description: For an individual run, read the h5 file and calculate total 
#   number of moles of Cr(III) produced at a certain timestep
#------------------------------------------------------------------------------
using sachFun

#------------------------------------------------------------------------------
# User info
#------------------------------------------------------------------------------
sensparam = "k_s2o4_fe3"
istop = 3 # parameter we care about

# pflotran information
basedir = "/lclscratch/sach/Programs/pflotran-dithionite-git/chrome-dithionite-tests/sensitivity/singleParameter"
rundir = "attempt1"
myname = "1d-allReactions-10m-uniformVelocity"
coord_name = "X"

# Get grid information for calculating volumes
dx= vcat(0.01*ones(200),0.1*ones(40),0.2*ones(20))
dy = 0.1
dz = 0.1

#------------------------------------------------------------------------------
# Initialize
#------------------------------------------------------------------------------
filename = joinpath(basedir,rundir,sensparam,"run$istop","$(myname).h5")
volumes = dx*dy*dz
summary = Dict()

#------------------------------------------------------------------------------
# Calculate the total number of moles of Cr that was immobilized
#------------------------------------------------------------------------------
mytime = 0.99
myvar = ["Cr(OH)3(s)_VF"]
results = sachFun.readh5_1D(filename,myvar,coord_name,mytime)

# calculate moles using m^3/m^3_bulk, dxyz and molar volume
MV_croh3 = 33.1/(100)^3 # m^3/mol
mol_cr3 = results[:,2].*volumes/MV_croh3
summary["tot_mol_cr3"] = sum(mol_cr3)

#------------------------------------------------------------------------------
# Calculate the maximum amount of Fe(II) reduced
#------------------------------------------------------------------------------
myvar = ["fast_Fe++", "slow_Fe++"]
dt = 0.01
df = 0.99
mytime = 0.0:dt:df

tot_mol_fe2 = Array{Float64}(0)
for t in mytime
    results = sachFun.readh5_1D(filename,myvar,coord_name,t)
    # calculate moles using moles/m^3_bulk and dxyz
    mol_fe2 = results[:,2].*volumes + results[:,3].*volumes
    tot_mol_fe2 = append!([sum(mol_fe2)],tot_mol_fe2)
end
summary["max_tot_mol_fe2"] = maximum(tot_mol_fe2)

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
max_tot_mol_fe3 = sum(ivf_feoh3 * volumes/MV_croh3)
summary["max_frac_reducedfe"] = maximum(tot_mol_fe2)/max_tot_mol_fe3

#------------------------------------------------------------------------------
# Calculate the amount of o2 consumed using mass balance approach
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Calculate the amount of o2 consumed using mass balance approach
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Calculate the amount of s2o4 consumed using mass balance approach
#------------------------------------------------------------------------------
