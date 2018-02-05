import sachConvert
sc = sachConvert

# constants
rho_H2O = 997.16 # kg/m^3

# Calculate pressure boundary conditions:
# HYDRAULIC CONDUCTIVITY: "use 20 m/d"
# HYDRAULIC GRADIENT: "0.0014 m/m"

k=sc.K2perm(20)

# 101325 Pa = 1 atm = 10.35091 m H2O
# 1000 m h20 = 9806806 Pa
# 1001 m h20 = 9816613 Pa

# # METHOD 1, specify hgrad
# hgrad = 0.1 # m/m

# # METHOD 2, specify porewater velocity, phi, and K
phi = 0.15
v_porewaters = [0.1,0.5,1.0,1.5,10] # m/day

for v_porewater in v_porewaters
	v_darcy = phi*v_porewater
	hgrad = v_darcy/sc.perm2K(k)

	deltax = 100.0 # m
	head_drop = deltax*hgrad
	rho_H2O = 997.16 # kg/m^3
	z = 0
	head_west_m = 1000.0 # m
	head_east_m = head_west_m - head_drop
	head_west_pa = sc.h2p(head_west_m,rho_H2O,z)
	head_east_pa = sc.h2p(head_east_m,rho_H2O,z)
	@printf("pressure east = %0.8e Pa\n",head_east_pa)
end
