import(Mads)

Mads.setprocs(10+1)
reload("Mads")

tic()
# Load mads file, set weights
md = Mads.loadmadsfile("1d-allReactions-10m-uniformVelocity.mads")

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

info("Global sensitivity analysis")
efastresult = Mads.efast(md, N=1, seed=2016)
Mads.plotobsSAresults(md, efastresult, 
                      filename="sensitivity_global.png", 
                      xtitle = "x", ytitle = "y")

toc()
