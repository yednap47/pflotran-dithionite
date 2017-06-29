import(Mads)

Mads.setprocs(8+1)
reload("Mads")

tic()
# Load mads file, set weights
@everywhere md = Mads.loadmadsfile("1d-allReactions-10m-uniformVelocity-tightened.mads")

# Mads.invobsweights!(md, 0.01)
# 
# # Manually set weights so that they are equal (or zero)
# obsnames = Mads.getobskeys(md)
# weights = Mads.getobsweight(md)
# myweight = maximum(weights)
# @show myweight
# for w = find(weights .!= 0.0)
#   md["Observations"][obsnames[w]]["weight"] = myweight
# end

n = 100
info("Calibration using $n random initial guesses for model parameters")

# r is an array:
#   - first entry = objective function value
#   - second entry = calibration succeeds?
#   - third entry = dictionary of parameter values
r = Mads.calibraterandom(md, n, all=true, seed=2016, save_results=false)
println("Worst objective function estimate $(max(r[:,1]...))")
println("Best objective function estimate $(min(r[:,1]...))")
println("$(collect(size(find(r[:,2] .== false)))) calibrations failed")
pnames = collect(keys(r[1,3]))
p = hcat(map(i->collect(values(r[i,3])), 1:n)...)'
np = length(pnames)

# Remove erroneous calibrations
obj_fun_threshold = 2000
r_goodfit = r[find(r[:,1].<obj_fun_threshold),:]
p_goodfit = hcat(map(i->collect(values(r_goodfit[i,3])), 1:length(r_goodfit[:,1]))...)'

info("Histograms of the estimated model parameters")
for i = 1:np
  f = Gadfly.plot(x=p[:,i], Gadfly.Guide.xlabel(pnames[i]), Gadfly.Geom.histogram())
  Gadfly.draw(Gadfly.PNG("estimated_parameter_histogram_raw_$(pnames[i]).png", 6Gadfly.inch, 4Gadfly.inch), f)
  f2 = Gadfly.plot(x=p_goodfit[:,i], Gadfly.Guide.xlabel(pnames[i]), Gadfly.Geom.histogram())
  Gadfly.draw(Gadfly.PNG("estimated_parameter_histogram_goodfit_$(pnames[i]).png", 6Gadfly.inch, 4Gadfly.inch), f2)
end

results = Dict()
results["pmin"] = map(i->min(p[:,i]...), 1:np)
results["pmax"] = map(i->max(p[:,i]...), 1:np)
results["pmean"] = map(i->mean(p[:,i]), 1:np)
results["pstd"] = map(i->std(p[:,i]), 1:np)

results_goodfit = Dict()
results_goodfit["pmin"] = map(i->min(p_goodfit[:,i]...), 1:np)
results_goodfit["pmax"] = map(i->max(p_goodfit[:,i]...), 1:np)
results_goodfit["pmean"] = map(i->mean(p_goodfit[:,i]), 1:np)
results_goodfit["pstd"] = map(i->std(p_goodfit[:,i]), 1:np)

# info("Scatter plot of parameter estimates")
# f = Gadfly.plot(x=p_goodfit[:,1], y=p_goodfit[:,2],
#       Gadfly.Geom.point, 
#       Gadfly.Guide.xlabel("$(pnames[1])"),
#       Gadfly.Guide.ylabel("$(pnames[2])"),
#       Gadfly.Guide.title("Scatter plot of parameter estimates `$(pnames[1])` and `$(pnames[2])`"))
# Gadfly.draw(Gadfly.PNG("scatter_plot_$(pnames[1])vs_$(pnames[2]).png", 6Gadfly.inch, 4Gadfly.inch), f)

toc()
# 42.93381083217778
