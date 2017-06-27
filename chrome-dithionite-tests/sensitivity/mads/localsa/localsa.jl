import(Mads)

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

# know optimal parameters
# md["Parameters"]["log10_k_ds2o4_dt"]["init"]=-4.0
# md["Parameters"]["log10_k_dhcro4_dt"]["init"]=1.0

info("Local sensitivity analysis for known parameters")
Mads.localsa(md, filename="sensitivity_local.png", datafiles=false)

# Check to make sure that the parameters are correct
o = Mads.forward(md)
Mads.plotmatches(md, o, r"Cr6_Obs", filename="plot-init-Cr6.png")

toc()
