import sachFun
import JLD
import PyPlot
plt = PyPlot

iruns = 1:1:15
mytime = 200
simbasename = "src"
myvar = ["east CrO4-- [mol]"]
sensresults_cr6 = Array{Float64}(0) # moles of cr6 that reach the outflow
for irun in iruns
	filename = joinpath("s$irun","$(simbasename)-mas.dat")
	obsresults = sachFun.readObsDataset(filename,myvar,dataframe=true)
	sensresults_cr6 = append!(sensresults_cr6,-(obsresults[Symbol("east CrO4-- [mol]")][mytime]))
end


plt.plot(iruns,sensresults_cr6)

results = Dict()
results["value"] = iruns
results["cr6"] = sensresults_cr6

JLD.save("sens_2d_wellspacing.jld","dictionary",results)
