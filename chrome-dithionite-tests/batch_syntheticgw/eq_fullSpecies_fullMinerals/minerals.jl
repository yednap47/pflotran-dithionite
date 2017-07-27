import sachFun
import PyPlot
plt = PyPlot
import DataFrames
df = DataFrames

chemnames = sachFun.getChemNames(fname, obsname)
charges = sachFun.getObsCharges(fname,obsname)
conc = sachFun.readObsDataset(fname,chemnames)

results = df.DataFrame(name=chemnames,conc=conc[end,2:end])
df.sort!(results, cols = [df.order(Symbol("conc"))],rev=true)
