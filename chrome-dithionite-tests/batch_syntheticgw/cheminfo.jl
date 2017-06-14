using sachFun
using DataFrames
df = DataFrames

fname = ARGS[1]
obsname = "obs"

headers = sachFun.readObsHeaders(fname)

chemnames = sachFun.getChemNames(fname, obsname)
charges = sachFun.getObsCharges(fname,obsname)
conc = sachFun.readObsDataset(fname,chemnames)

# Calculate charge balance
conc_eq = conc[end,2:end]
cb = sum(conc_eq.*charges)

# Calculate charge balance ERROR
sum_cations = sum(conc_eq[charges.>0].*charges[charges.>0])
sum_anions = sum(conc_eq[charges.<0].*charges[charges.<0])
cbe = (sum_cations-abs(sum_anions))/(sum_cations+abs(sum_anions))*100

# Calculate ionic strength
I = 0.5*sum(conc[end,2:end].*charges.^2);

# Get info about toth
chemnames2 = ["Total H+ [M] obs (1)",
              "pH obs (1)",
              ]

conc2 = sachFun.readObsDataset(fname,chemnames2)
toth = conc2[end,2]
ph = conc2[end,3]

# Get info about species concentrations
results = df.DataFrame(name = chemnames, conc = conc[end,2:end], charge = charges)
sort!(results, cols = [order(:conc)],rev=true)
df.writetable("$(split(fname,"-obs-")[1]).csv",results)
cbe
