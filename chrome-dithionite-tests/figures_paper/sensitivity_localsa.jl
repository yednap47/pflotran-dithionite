import PyPlot
plt = PyPlot
import JLD
import DataStructures
using LaTeXStrings

# Manually plot local sa results for paper
mysize = 9
coolnames  = JLD.load("./datafiles/coolnames.jld","dictionary")
eigenmat_raw = readdlm("./datafiles/sensitivity_local-eigenmatrix.dat")

eigenmat_names = eigenmat_raw[:,1]
for i in 1:length(eigenmat_names)
    eigenmat_names[i] = coolnames[eigenmat_names[i]]
end

f, ax = plt.subplots(figsize=(4,3))

eigenmat_clean = eigenmat_raw[:,2:end]
eigenmat_clean = map(x->Float64(x),eigenmat_clean)
plt.pcolor(eigenmat_clean[end:-1:1,1:1:end],cmap="RdBu_r",vmin=-1, vmax=1)
cbar = plt.colorbar()
plt.xlim(0,length(eigenmat_names))
plt.ylim(0,length(eigenmat_names))
plt.xlabel(L"\mathrm{Eigenvectors}",fontsize=mysize)
plt.ylabel(L"\mathrm{Parameters}",fontsize=mysize)
plt.xticks(0.5:1:10.5,(L"1",L"2",L"3",L"4",L"5",L"6",L"7",L"8",L"9",L"10",L"11"))
plt.yticks(0.5:1:10.5,eigenmat_names[end:-1:1])

plt.tick_params(axis="x", which="both", bottom="off", top="off")
plt.tick_params(axis="y", which="both", left="off", right="off")
ax[:tick_params](labelsize=mysize)
cbarvalues = -1.0:.2:1.0
cbarvalues = [LaTeXStrings.LaTeXString("\$$cbarvalue\$") for cbarvalue in cbarvalues]

cbar[:ax][:set_yticklabels](cbarvalues)
cbar[:ax][:tick_params](labelsize=mysize-2)

plt.tight_layout()
plt.draw()
plt.savefig("./res_low/paper_localsa.png",dpi=100)
plt.savefig("./res_high/paper_localsa.png",dpi=600)
plt.close()
