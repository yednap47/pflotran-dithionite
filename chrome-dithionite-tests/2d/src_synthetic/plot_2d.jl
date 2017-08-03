import sachFun
import PyPlot
plt = PyPlot


filename = "src.h5"
mytimesteps = 1:1:100
myvar = ["Total_CrO4-- [M]"]
nx = 100
ny = 75
dxyz = 1
MW_Cr = 52.0

if !isdir("movie")
    mkdir("movie")
end

for mytimestep in mytimesteps
    results = sachFun.readh5_2D(filename,myvar,mytimestep)
    test = reshape(results[:,3]*MW_Cr*10^6,ny,nx)
    xgrid = 1:nx/dxyz
    ygrid = 1:ny/dxyz

    fig,ax = plt.subplots(figsize=(15,10))
    plt.pcolor(xgrid,ygrid,convert(Array,test))
    plt.colorbar(format="%.2f")
    ax[:set_ylabel]("y, meters")
    ax[:set_xlabel]("x, meters")
    ax[:set_xlim](1,nx/dxyz)
    ax[:set_ylim](1,ny/dxyz)
    fig[:canvas][:draw]() # Update the figure
    ax[:set_title]("$(mytimestep*2) days")
    plt.tight_layout()
    plt.savefig("movie/image$mytimestep.png")
    plt.close()
end
