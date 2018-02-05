import sachFun
import JLD
import PyPlot
plt = PyPlot

iruns = 1:1:10
q = [0.062911,1.06949,2.13897,3.14555,4.21504,5.22161,6.2911,7.29767,8.36716,9.43665]
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

plt.plot(q,sensresults_cr6)

results = Dict()
results["value"] = q
results["cr6"] = sensresults_cr6

JLD.save("sens_2d_injectionrate.jld","dictionary",results)
