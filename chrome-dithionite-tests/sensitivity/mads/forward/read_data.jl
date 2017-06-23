using HDF5
import sachFun

function readdata(d)
    function parseh5!(casetag::AbstractString, results)
        # User Data
#        ncalibrationTargets = 14
        np = 4
        pfpath = "/lclscratch/sach/Programs/pflotran-dithionite-git/src/pflotran"
        htag = casetag * ".h5"
        masstag = casetag * "-mas.dat"
        otag = casetag * ".out"
        crtag = "Cr6_Obs_t"

        run(`rm -f $htag`)
        run(`rm -f $otag`)

        directive = "mpirun -np $(np) " * pfpath * "/pflotran -pflotranin " * casetag * ".in >barf.txt"
        try
            asdf = `bash -c "$directive"`
            @show asdf
            run(asdf)
        catch
        end

        # # METHOD 1: USE THE H5 FILE
        # myvar = ["Total_CrO4-- [M]"]
        # coord_name = "X"
        # distance = 9 # meters
        # mydata = sachFun.readh5_1D_obs(htag,myvar,coord_name,distance)
        # 
        # # remove t_0 and t_final
        # for i in 2:length(mydata[:,1])-1
        #     results[crtag * "$(i-1)"] = mydata[i,2]
        # end

        # METHOD 2: USE THE MASS BALANCE FILE
        myvar = ["east CrO4-- [mol/d]"]
        mydata = sachFun.readObsDataset(masstag,myvar)
        obstimes = mydata[:,1]
        targets = -mydata[:,2]
        for i in 1:length(obstimes)
            results[crtag * "$(i)"] = targets[i]
        end

        # ORIGINAL METHOD, NO OUTSIDE FUNCTIONS, ONLY WORKS FOR BATCH
        # fid = h5open(htag,"r")
        # h5dict = read(fid)
        # close(fid)
        # 
        # keyarray = collect(keys(h5dict))
        # timekeyarray = filter(key -> split(key)[1] == "Time:", keyarray)
        # timearray = [parse(Float64,split(key)[2]) for key in timekeyarray]
        # sta = sort(timearray)
        # 
        # keydict = Dict(zip(timearray,timekeyarray))
        # @show timekeyarray pwd()
        # try
        #     for i = 1:ncalibrationTargets
        #             results[crtag * "$i"] = h5dict[keydict[sta[i + 1]]]["Total_CrO4-- [M]"][1]
        #     end
        # end
        return results
    end

    results = Dict{AbstractString,Any}()
    parseh5!("1d-allReactions-10m-uniformVelocity", results)
    return results
end
