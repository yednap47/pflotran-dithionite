import sachFun
import PyPlot
plt = PyPlot
# function plot_2d(basedir,myvar,mytimestep,thisrun)
# 
#     test = reshape(results[:,3]*MW_Cr*10^6,ny,nx)
#     xgrid = 1:nx/dxyz
#     ygrid = 1:ny/dxyz
# 
#     fig,ax = plt.subplots(figsize=(15,10))
#     plt.pcolor(xgrid,ygrid,convert(Array,test))
#     plt.colorbar(format="%.2f")
#     ax[:set_ylabel]("y, meters")
#     ax[:set_xlabel]("x, meters")
#     ax[:set_xlim](1,nx/dxyz)
#     ax[:set_ylim](1,ny/dxyz)
#     fig[:canvas][:draw]() # Update the figure
#     ax[:set_title]("$(mytimestep*2) days")
#     plt.tight_layout()
#     plt.savefig(joinpath(basedir,rundir,"results_$(Int(mytimestep*2))","run$thisrun.png"))
#     plt.close()
# end

thisrun = 8

rundir =  "corr1_sig1"
permfieldbasename = "rand_100x75_corr10_sig1_20mpd_n"
basedir = "/lclscratch/sach/Programs/pflotran-dithionite/chrome-dithionite-tests/2d/rxn_realization/permeability"

nx = 100
ny = 75
dxyz = 1
MW_Cr = 52.0
mytimesteps = 1:1:200/2

obsresults = Array{Float64}(0)

for mytimestep in mytimesteps

    myvar = ["Total_CrO4-- [M]"]
    results = sachFun.readh5_2D(joinpath(basedir,rundir,"run$thisrun","src.h5"),myvar,Int(mytimestep))
    test = reshape(results[:,3]*MW_Cr*10^6,ny,nx)
    append!(obsresults,test[39,75])
end

plt.plot(mytimesteps,obsresults)
