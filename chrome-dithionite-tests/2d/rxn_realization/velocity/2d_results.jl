import sachFun
using PyPlot
plt = PyPlot
using LaTeXStrings

function plotformatting(mylabel,majorFormatter,f,ax,results,sc)

    ax[:set_ylabel](L"\mathrm{y [m]}",fontsize=mysize)
    ax[:set_xlabel](L"\mathrm{x [m]}",fontsize=mysize)
    # ax[:set_ylim](0,maximum(results["ycoords"]))
    ax[:set_ylim](15,60)
    ax[:tick_params](axis="y", direction="out", right="off")
    ax[:tick_params](axis="x", direction="out", top="off")
    ax[:tick_params](labelsize=mysize)
    ax[:set_xlim](0,maximum(results["xcoords"]))
    
    ax[:set_aspect]("equal")
    box = ax[:get_position]()
    ax[:set_position]([box[:x0], box[:y0]+0.12,box[:width]*0.83, box[:height]*0.98])
    position = f[:add_axes]([0.78,box[:y0]+0.13,0.02,box[:height]*0.9]) 
    cbar = f[:colorbar](sc,cax=position,format=majorFormatter)
    # plt.tight_layout()
    cbar[:ax][:tick_params](labelsize=mysize)
    # cbar[:ax][:set_title](mylabel)
    cbar[:ax][:set_ylabel](mylabel,fontsize=mysize)
    # cbar.ax.set_ylabel('# of contacts', rotation=270)
    plt.draw()
end

# ------------ Initialize ------------#
mysize = 11
dt = 2.0
MW_Cr = 52.0

# ------------ Plot chromium distribution after treatment ------------#
myvars = ["Total_CrO4-- [M]"]
mytimestep = Int(152/dt)
runnames = ["s1","s2","s3","s4","s5"]
v_porewaters = [0.1,0.5,1.0,1.5,10] # m/day
majorFormatter = matplotlib[:ticker][:FormatStrFormatter]("%0.1f")
for i in 1:length(runnames)
    runname = runnames[i]
    v_porewater = v_porewaters[i]
    filename = "$runname/src.h5"
    results = sachFun.readh5_2D(filename,myvars,mytimestep;reshaped=true)
    f, ax = plt.subplots(figsize=(4,1.75))
    sc = plt.pcolor(results["xcoords"],results["ycoords"],convert(Array,results["Total_CrO4-- [M]"]*MW_Cr*10^6))
    plotformatting(L"\mathrm{[CrO4^{-2}]\, [ppb]}",majorFormatter,f,ax,results,sc)
    ax[:text](2,17, "v = $(v_porewater) m/day", color="white", fontsize = mysize)
    plt.savefig("./2d_velocity_Cr_$(runname)_t$(Int(mytimestep*dt)).png",dpi=600)
    plt.close()
end
