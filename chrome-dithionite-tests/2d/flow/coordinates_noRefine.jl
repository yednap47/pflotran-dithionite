using MySQL
using PyPlot
using DataFrames
#import PyCall
#@PyCall.pyimport aquiferdb as db
#@PyCall.pyimport chipbeta as cb

subplot(111,aspect="equal")
ax1=gca()

# wellnames = ["R-28"]
# con = MySQL.mysql_connect("madsmax", "perl", "script", "LocalWork")
# wellInfo = Dict()
# for well in wellnames
#   wellInfo[well]=Dict()
#   mydf = MySQL.mysql_execute(con, "select *  from WQDBLocation where location_name='$well';")
#   wellInfo[well]["x"] = mydf[:X_COORD][1]*.3048 # m from ft
#   wellInfo[well]["y"] = mydf[:Y_COORD][1]*.3048 # m from ft
#   scatter(wellInfo[well]["x"],wellInfo[well]["y"],c="k")
# end

nx = 125
ny = 75
nz = 1 
thk_x = 125.0 # m
thk_y = 75.0 # m
thk_z = 30.0 # m

# if isodd(thk_x)
#     origin_x = round(wellInfo["R-28"]["x"])-floor(thk_x/2)
#     extent_x = round(wellInfo["R-28"]["x"])+floor(thk_x/2)+1
# else
#     origin_x = round(wellInfo["R-28"]["x"])-thk_x/2
#     extent_x = round(wellInfo["R-28"]["x"])+thk_x/2
# end
# 
# if isodd(thk_y)
#     origin_y = round(wellInfo["R-28"]["y"])-floor(thk_y/2)
#     extent_y = round(wellInfo["R-28"]["y"])+floor(thk_y/2)+1
# else
#     origin_y = round(wellInfo["R-28"]["y"])-thk_y/2
#     extent_y = round(wellInfo["R-28"]["y"])+thk_y/2
# end

origin_x = 0.0
origin_y = 0.0
extent_x = origin_x + thk_x
extent_y = origin_y + thk_y
wellnames = ["well_injection"]
wellcoord_x = [40.5]
wellcoord_y = [37.5]

scatter(origin_x,origin_y,c="r")
scatter(extent_x,extent_y,c="r")

outfile = open("grid_coordinates.txt", "w")
write(outfile, "GRID\n")
write(outfile, "  TYPE structured\n")
write(outfile, "  NXYZ $(convert(Int,nx)) $(convert(Int,ny)) $(convert(Int,nz))\n")
write(outfile, "  BOUNDS\n")
write(outfile, "    $origin_x $origin_y 0.0\n")
write(outfile, "    $extent_x $extent_y $thk_z\n")
write(outfile, "  /\n")
write(outfile, "END\n")

write(outfile, "\n")
write(outfile,"REGION all\n")
write(outfile,"  COORDINATES\n") 
write(outfile,"     $(origin_x) $(origin_y) 0.0\n") 
write(outfile,"     $(extent_x) $(extent_y) $(thk_z)\n") 
write(outfile,"  /\n") 
write(outfile,"END\n") 

write(outfile, "\n")
write(outfile,"REGION west\n")
write(outfile,"  FACE WEST\n")
write(outfile,"  COORDINATES\n") 
write(outfile,"     $(origin_x) $(origin_y) 0.0\n") 
write(outfile,"     $(origin_x) $(extent_y) $(thk_z)\n") 
write(outfile,"  /\n") 
write(outfile,"END\n") 

write(outfile, "\n")
write(outfile,"REGION east\n")
write(outfile,"  FACE EAST\n")
write(outfile,"  COORDINATES\n") 
write(outfile,"     $(extent_x) $(origin_y) 0.0\n") 
write(outfile,"     $(extent_x) $(extent_y) $(thk_z)\n") 
write(outfile,"  /\n") 
write(outfile,"END\n") 

write(outfile, "\n")
write(outfile,"REGION south\n")
write(outfile,"  FACE SOUTH\n")
write(outfile,"  COORDINATES\n") 
write(outfile,"     $(origin_x) $(origin_y) 0.0\n") 
write(outfile,"     $(extent_x) $(origin_y) $(thk_z)\n") 
write(outfile,"  /\n") 
write(outfile,"END\n") 

write(outfile, "\n")
write(outfile,"REGION north\n")
write(outfile,"  FACE NORTH\n")
write(outfile,"  COORDINATES\n") 
write(outfile,"     $(origin_x) $(extent_y) 0.0\n") 
write(outfile,"     $(extent_x) $(extent_y) $(thk_z)\n") 
write(outfile,"  /\n") 
write(outfile,"END\n") 

# write(outfile, "\n")
# for well in wellnames
#   write(outfile,"REGION $(well)\n")
#   write(outfile,"  COORDINATES\n")
#   @printf(outfile,"  %0.2f ", wellInfo[well]["x"])
#   @printf(outfile,"%0.2f ", wellInfo[well]["y"])
#   write(outfile,"0.0\n")
#   @printf(outfile,"  %0.2f ", wellInfo[well]["x"])
#   @printf(outfile,"%0.2f ", wellInfo[well]["y"])
#   write(outfile,"100.0\n")
#   write(outfile,"  /\nEND\n\n")
# end

write(outfile, "\n")
for i in 1:length(wellnames)
  write(outfile,"REGION $(wellnames[i])\n")
  write(outfile,"  COORDINATES\n")
  @printf(outfile,"    %0.2f ", wellcoord_x[i])
  @printf(outfile,"%0.2f ", wellcoord_y[i])
  write(outfile,"0.0\n")
  @printf(outfile,"    %0.2f ", wellcoord_x[i])
  @printf(outfile,"%0.2f ", wellcoord_y[i])
  write(outfile,"$(thk_z)\n")
  write(outfile,"  /\nEND\n\n")
end

close(outfile)

# How many degrees of freedom?
nnodes = (nx)*(ny)*(nz)
nspecies = 15
dof = 10000
nprocs = nnodes*nspecies/dof
@show nnodes
@show nprocs
