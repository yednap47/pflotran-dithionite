names = ["Fe(OH)3(s)","Cr(OH)3(s)","Halite","Calcite","Siderite","Dolomite","Anhydrite","K-Feldspar"]

# UNITS = cm^3/mol
mv = Dict()
mv["Fe(OH)3(s)"] = 33.1
mv["Cr(OH)3(s)"] = 34.36
mv["Halite"] = 27.0150
mv["Calcite"] = 36.9340
mv["Siderite"] = 29.3780
mv["Dolomite"] = 64.3650
mv["Anhydrite"] = 45.9400
mv["K-Feldspar"] = 108.8700

# UNITS = g/mole
mw = Dict()
mw["Fe(OH)3(s)"] = 103.0181
mw["Cr(OH)3(s)"] = 106.87
mw["Halite"] = 58.4425
mw["Calcite"] = 100.0872
mw["Siderite"] = 115.8562
mw["Dolomite"] = 184.4014
mw["Anhydrite"] = 136.1416
mw["K-Feldspar"] = 278.3315

rho_bulk = 1200 # kg/m^3
wt_percent = 1 # %
ssa = 1000

vf = Dict()
for name in names
    if name == "Cr(OH)3(s)"
        vf[name] = 1.0e-20
        print("    $name ")
        @printf "%.2e " vf[name]
        @printf "%.1e" ssa
        println()
    else
        vf[name] = wt_percent/100*rho_bulk*(mv[name]/100.0^3)/(mw[name]/1000)
        print("    $name ")
        @printf "%.2e " vf[name]
        @printf "%.1e" ssa
        println()
    end
end
