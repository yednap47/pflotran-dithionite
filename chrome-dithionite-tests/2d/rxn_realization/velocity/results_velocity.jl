import sachFun
import JLD
import PyPlot
plt = PyPlot

iruns = 1:1:5
v_porewaters = [0.1,0.5,1.0,1.5,10] # m/day
mytime = 200
simbasename = "src"
myvar = ["east CrO4-- [mol]"]
sensresults_cr6 = Array{Float64}(0) # moles of cr6 that reach the outflow
for irun in iruns
	filename = joinpath("s$irun","$(simbasename)-mas.dat")
	obsresults = sachFun.readObsDataset(filename,myvar,dataframe=true)
	sensresults_cr6 = append!(sensresults_cr6,-(obsresults[Symbol("east CrO4-- [mol]")][mytime]))
end


plt.plot(v_porewaters,sensresults_cr6)
