import Mads

tic()
md = Mads.loadmadsfile("1d-allReactions-10m-uniformVelocity.mads")
o = Mads.forward(md)
Mads.plotmatches(md, o, r"Cr6_Obs", filename="plot-init-Cr6.png")
toc()
