# Id: getTotalCr3.jl, Mon 05 Jun 2017 09:54:45 AM MDT pandeys #
# Created by Sachin Pandey, LANL
# Description: For an individual run, read the h5 file and calculate total 
#   number of moles of Cr(III) produced at a certain timestep
#------------------------------------------------------------------------------
using sachFun

# User info
sensparam = "ifeoh3"
# nstops = 5 # number of sensitivity runs
istop = 5 # parameter we care about
mytime = 0.99
myvar = ["Cr(OH)3(s)_VF"]
coord_name = "X"

# Get grid information for calculating volumes
dx= vcat(0.01*ones(200),0.1*ones(40),0.2*ones(20))
dy = 0.1
dz = 0.1

# pflotran information
basedir = "/lclscratch/sach/Programs/pflotran-dithionite-git/chrome-dithionite-tests/sensitivity/singleParameter"
rundir = "attempt1"
myname = "1d-allReactions-10m-uniformVelocity"

filename = joinpath(basedir,rundir,sensparam,"run$istop","$(myname).h5")
results = sachFun.readh5_1D(filename,myvar,coord_name,mytime)

# calculate moles using m^3/m^3_bulk, dxyz and molar volume
MV = 33.1/(100)^3 # m^3/mol
volumes = dx*dy*dz
moles = results[:,2].*volumes/MV
total_moles = sum(moles)
