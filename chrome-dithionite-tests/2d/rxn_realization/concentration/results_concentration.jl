import sachFun
import JLD
import PyPlot
plt = PyPlot

iruns = 1:1:9
concs = [0.001,0.0564444,0.111889,0.167333,0.222778,0.278222,0.333667,0.389111,0.444556]
mytime = 200
simbasename = "src"
myvar = ["east CrO4-- [mol]"]
sensresults_cr6 = Array{Float64}(0) # moles of cr6 that reach the outflow
for i in 1:length(iruns)
	irun = iruns[i]
	filename = joinpath("s$irun","$(simbasename)-mas.dat")
	obsresults = sachFun.readObsDataset(filename,myvar,dataframe=true)
	sensresults_cr6 = append!(sensresults_cr6,-(obsresults[Symbol("east CrO4-- [mol]")][mytime]))
end

plt.plot(concs,sensresults_cr6)

results = Dict()
results["value"] = concs
results["cr6"] = sensresults_cr6

JLD.save("sens_2d_concentration.jld","dictionary",results)
