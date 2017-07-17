import(Mads)

tic()

md = Mads.loadmadsfile("1d-allReactions-10m-uniformVelocity.mads")
o = Mads.forward(md)
Mads.plotmatches(md, o, r"Cr6_Obs", filename="plot-init-Cr6.png")

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

c = Mads.calibrate(md)
cparams = c[1]
@show cparams
d = Dict()
for k in keys(cparams) d[k] = cparams[k]; end
cal = Mads.forward(md, d)
Mads.plotmatches(md, cal, r"Cr6_Obs", filename="plot-cal-Cr6.png")

toc()
# elapased time: 1766.381471413 seconds
