using HDF5
using PyPlot;
plt = PyPlot;
using PyCall

@pyimport numpy as np

function K2perm(K)
  #  K [m/d]
  #  perm [m^2]  
  rhow = 998.2; # density H20, [kg/m^3]
  mu = 1.002e-3; # dynamic viscocity H2O, [kg/m/s] (i.e. [Pa s])
  g = 9.80665; # m/s^2
  k = K/86400/rhow/g*mu; # m^2 from m/d
  return k
end

function perm2K(k)
  #  perm [m^2]  
  #  K [m/d]
  rhow = 998.2; # density H20, [kg/m^3]
  mu = 1.002e-3; # dynamic viscocity H2O, [kg/m/s] (i.e. [Pa s])
  g = 9.80665; # m/s^2
  K = k*86400*rhow*g/mu; # m/d from m^2
  return K
end

## User Data
fbasename = "./rand_125x75_corr10_sig1"

# domain info
nx = 125;
ny = 75;
nz = 1
dx = 1;
dz = 1;
nhead = 3; # numer of headers in reading file

mu_K = 20; # [m/d] desired mean hydraulic conductivity of K field
sigma_lnK = 1.0; # desired standard deviation of lnK field

# convert Kbar (log-normal) to mu_lnk (normal) HARI METHOD
mu_lnK = log(mu_K)-sigma_lnK^2/2;

# open file
fname=("$(fbasename).dat")
myfile = open(fname)
temp = readlines(myfile)
close(myfile)
raw = map((x) -> parse(Float64,x),temp[4:end])
ndata = length(raw)

X = zeros(ndata,1) # hydraulic conductivity vector following normal dis
K = zeros(ndata,1) # hydraulic conductivity vector following normal dis
for i in 1:ndata
	# transform from normal to lognormal
	X[i] = raw[i]+mu_lnK
	K[i] = exp(X[i])
end

perm = K2perm(K);

# myMat = reshape(k(:,i),nx,nz);

## ========================================================================== ##
## Plot results
## ========================================================================== ##
myMat = reshape(perm,nx,ny)
subplot(111,aspect="equal")
pcolor(transpose(log10(myMat)))
colorbar()
xlim(0,nx)
ylim(0,ny)

## ========================================================================== ##
## Coordinates of cell centers
## ========================================================================== ##
ivec = range(1,1,nx)
jvec = range(1,1,ny)
kvec = range(1,1,nz)
cellIndex = Array(Int,nx*ny*nz,4)
for i in ivec
	for j in jvec
		for k in kvec
			index = i + (j-1)*nx + (k-1)*nx*ny
			cellIndex[index,1]=index
			cellIndex[index,2]=i
			cellIndex[index,3]=j
			cellIndex[index,4]=k
		end
	end
end

## ========================================================================== ##
## Write to h5 file
## ========================================================================== ##
htag = "$(fbasename)_20mpd.h5"
fid = h5open(htag,"w")
write(fid, "Cell Ids", cellIndex[:,1])
write(fid, "Permeability", perm[:])  # alternatively, say "@write file A"
close(fid)

savefig("$(fbasename)_20mpd.png")
close()

check = Dict()
check["mu_k"] = mean(perm[:])
check["mu_K"] = mean(K[:])
check["sigma_lnK"] = sqrt(var(log(K[:])))
@show check
