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

function h2p(head,rho_H2O,z)
  g = 9.80665; # m/s
  pressure = (head-z)*rho_H2O*g
  return pressure
end

# HYDRAULIC CONDUCTIVITY: "use 20 m/d"
# HYDRAULIC GRADIENT: "0.0014 m/m"

k=K2perm(20)
@printf("permeability = %0.5e m^2\n",k)

# 101325 Pa = 1 atm = 10.35091 m H2O
# 1000 m h20 = 9806806 Pa
# 1001 m h20 = 9816613 Pa

# # METHOD 1, specify hgrad
# hgrad = 0.1 # m/m

# # METHOD 2, specify porewater velocity, phi, and K
phi = 0.15
v_porewater = 1.0 # m/day
v_darcy = phi*v_porewater 
hgrad = v_darcy/perm2K(k)

deltax = 125.0 # m
head_drop = deltax*hgrad
rho_H2O = 997.16 # kg/m^3
z = 0
head_west_m = 1000.0 # m
head_east_m = head_west_m - head_drop
head_west_pa = h2p(head_west_m,rho_H2O,z)
head_east_pa = h2p(head_east_m,rho_H2O,z)

@printf("pressure west = %0.8e Pa\n",head_west_pa)
@printf("pressure east = %0.8e Pa\n",head_east_pa)

# PUMPING rate

# FLOW_CONDITION well
#   TYPE
#     RATE mass_rate 
# #    RATE volumetric_rate 
#   /
#   RATE list
#     TIME_UNITS d
#     DATA_UNITS kg/s
# #    DATA_UNITS m^3/day
#     0.d0    0.d0
#     10.d0   0.629110
# #    10.d0   100.0
#     30.d0   0.d0
#   /
# END

# Convert gpm to kg/s
Q_gpm = 10 # gpm
injectiontime = 4.5 # d
resttime = 1 # d 
pumpingtime = 10 # d
starttime = 10.0 # d
timeunits = "d"

# calculations
Q_lpm = Q_gpm * 3.78541
Q_m3ps = Q_lpm/1000/60
Q_kgps = Q_m3ps*rho_H2O
Q_m3pd = Q_m3ps*86400 

outfile = open("pumping_condition.txt", "w")
write(outfile, "FLOW_CONDITION well\n")
write(outfile, "  TYPE\n")
write(outfile, "    RATE mass_rate\n")
write(outfile, "  /\n")
write(outfile, "  RATE list\n")
write(outfile, "    TIME_UNITS $timeunits\n")
write(outfile, "    0.0 0.0\n")
write(outfile, "    $starttime $(round(Q_kgps,4))\n")
write(outfile, "    $(starttime+injectiontime) 0.0\n")
write(outfile, "    $(starttime+injectiontime+resttime) $(-round(Q_kgps,4))\n")
write(outfile, "    $(starttime+injectiontime+resttime+pumpingtime) 0.0\n")
write(outfile, "  /\n")
write(outfile, "END")
close(outfile)
