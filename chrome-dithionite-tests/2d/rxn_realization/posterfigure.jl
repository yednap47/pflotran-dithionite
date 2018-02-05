import JLD
import PyPlot; plt = PyPlot;

baseoffset = 0.75
offset = 0.05

results_wellspacing = JLD.load("./wellspacing/sens_2d_wellspacing.jld","dictionary")
results_injectionrate = JLD.load("./injectionrate/sens_2d_injectionrate.jld","dictionary")
results_concentration = JLD.load("./concentration/sens_2d_concentration.jld","dictionary")

fig, ax = plt.subplots()
ax[:plot](results_wellspacing["value"],results_wellspacing["cr6"],color="blue")
ax[:tick_params](color="blue")

new_position = [0.06;0.06;0.9;baseoffset] # Position Method 2
ax[:set_position](new_position) # Position Method 2: Change the size and position of the axis

ax2 = ax[:twiny]() # Create another axis on top of the current axis
ax2[:plot](results_injectionrate["value"],results_injectionrate["cr6"],color="green")
ax2[:set_xlabel]("Injection rate",color = "green")
ax2[:tick_params](color="green")
plt.setp(ax2[:get_xticklabels](),color="green") # Y Axis font formatting
ax2[:spines]["bottom"][:set_color]("green")
ax2[:set_position](new_position) # Position Method 2: Change the size and position of the axis

ax3 = ax[:twiny]() # Create another axis on top of the current axis
ax3[:plot](results_concentration["value"],results_concentration["cr6"],color="red")
ax3[:set_xlabel]("Injection rate",color = "red")
ax3[:tick_params](color="red")
plt.setp(ax3[:get_xticklabels](),color="red") # Y Axis font formatting
ax3[:spines]["bottom"][:set_color]("red")
ax3[:set_position](new_position) # Position Method 2: Change the size and position of the axis
ax3[:spines]["top"][:set_position](("axes",1.11))

fig[:canvas][:draw]() # Update the figure
