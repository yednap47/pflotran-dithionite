import sachFun
import PyPlot
plt = PyPlot
using LaTeXStrings

function plotformatting(mylabel)

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
    ax[:set_position]([box[:x0], box[:y0]+0.1,box[:width]*0.85, box[:height]*0.98])
    position = f[:add_axes]([0.8,box[:y0]+0.13,0.02,box[:height]*0.9]) 
    cbar = f[:colorbar](sc,cax=position)
    # plt.tight_layout()
    cbar[:ax][:tick_params](labelsize=mysize-2)
    # cbar[:ax][:set_title](mylabel)
    cbar[:ax][:set_ylabel](mylabel,fontsize=mysize)
    # cbar.ax.set_ylabel('# of contacts', rotation=270)
    plt.draw()
end

# ------------ Initialize ------------#
filename = "./datafiles/src.h5"
mysize = 9
dt = 2.0

# ------------ Plot steady state velocity profile ------------#
qsf = 2 # quiver plot skip factor
mytimestep = Int(152/dt)
myvars = ["Permeability_X [m^2]","Liquid X-Velocity [m_per_d]","Liquid Y-Velocity [m_per_d]"]
results = sachFun.readh5_2D(filename,myvars,mytimestep;reshaped=true)
f, ax = plt.subplots(figsize=(4.0,1.75))
sc = plt.pcolor(results["xcoords"],results["ycoords"],convert(Array,log10(results["Permeability_X [m^2]"])))

# perm = reshape(results["Permeability_X [m^2]"],results["ny"],results["nx"])
# plt.pcolor(results["xcoords"],results["ycoords"],convert(Array,log10(perm)))

# cbar = plt.colorbar(format="%.1f")
# cbar = plt.colorbar(fraction=0.046, pad=0.04,format="%.1f")

Q = plt.quiver(reshape(results["xgrid"],results["ny"],results["nx"])[1:qsf:end,1:qsf:end], reshape(results["ygrid"],results["ny"],results["nx"])[1:qsf:end,1:qsf:end], results["Liquid X-Velocity [m_per_d]"][1:qsf:end,1:qsf:end], results["Liquid Y-Velocity [m_per_d]"][1:qsf:end,1:qsf:end])

plotformatting(L"\mathrm{Permeability,\, [m^2]}")
plt.savefig("./res_low/2d_permField.png",dpi=100)
plt.savefig("./res_high/2d_permField.png",dpi=600)
plt.close()

# ------------ Plot original chromium distribution ------------#
myvars = ["Total_CrO4-- [M]"]
mytimestep = 1
results = sachFun.readh5_2D(filename,myvars,mytimestep;reshaped=true)
f, ax = plt.subplots(figsize=(4,1.75))
plt.pcolor(results["xcoords"],results["ycoords"],convert(Array,results["Total_CrO4-- [M]"]))
plotformatting(L"\mathrm{[CrO4^{-2}],\, [M]}")
ax[:text](2,17, "t = 0 d", color="white", fontsize = mysize)
plt.savefig("./res_low/2d_Cr_t0.png",dpi=100)
plt.savefig("./res_high/2d_Cr_t0.png",dpi=600)
plt.close()

# # ------------ Plot chromium distribution after treatment ------------#
myvars = ["Total_CrO4-- [M]"]
mytimesteps = [Int(52/dt), Int(102/dt), Int(152/dt)]

for mytimestep in mytimesteps
    results = sachFun.readh5_2D(filename,myvars,mytimestep;reshaped=true)
    f, ax = plt.subplots(figsize=(4,1.75))
    plt.pcolor(results["xcoords"],results["ycoords"],convert(Array,results["Total_CrO4-- [M]"]))
    plotformatting(L"\mathrm{[CrO4^{-2}],\, [M]}")
    ax[:text](2,17, "t = $(Int(mytimestep*dt)) d", color="white", fontsize = mysize)
    plt.savefig("./res_low/2d_Cr_t$(Int(mytimestep*dt)).png",dpi=100)
    plt.savefig("./res_high/2d_Cr_t$(Int(mytimestep*dt)).png",dpi=600)
    plt.close()
end
