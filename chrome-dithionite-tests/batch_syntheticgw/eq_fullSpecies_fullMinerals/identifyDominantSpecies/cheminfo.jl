using sachFun
using DataFrames
df = DataFrames

function dostuff(fname,obsname)
    headers = sachFun.readObsHeaders(fname)
    chemnames = sachFun.getChemNames(fname, obsname)
    charges = sachFun.getObsCharges(fname,obsname)
    conc = sachFun.readObsDataset(fname,chemnames)[end,2:end]
    chemnames = map(x -> x[4:end],chemnames)
    chemnames = map(x -> split(x, " obs ")[1],chemnames)
    return chemnames,conc
end

obsname = "obs"
fname = "initial_ph7-obs-0.tec"
chemnames,conc_ph7 = dostuff(fname,obsname)

fname = "initial_ph9-obs-0.tec"
chemnames,conc_ph9 = dostuff(fname,obsname)

fname = "initial_ph11-obs-0.tec"
chemnames,conc_ph11 = dostuff(fname,obsname)

results = df.DataFrame(name = chemnames, ph7 = conc_ph7, ph9 = conc_ph9, ph11 = conc_ph11)
df.writetable("concentrations.csv",results)
