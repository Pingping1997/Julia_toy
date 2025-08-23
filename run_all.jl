import Pkg
Pkg.activate(@__DIR__)
try
    using JuMP, CSV, DataFrames, YAML
catch
    Pkg.add(["JuMP","CSV","DataFrames","YAML"])
end

include(joinpath(@__DIR__, "src", "CCSModel.jl"))
using .CCSModel

cfg_path = joinpath(@__DIR__, "config", "model.yml")
cfg = YAML.load_file(cfg_path)

for scen in keys(cfg["scenarios"])
    println("Running scenario: ", scen)
    CCSModel.run(String(scen); cfg_path=cfg_path, outdir_base=joinpath(@__DIR__, "results"))
end

println("Done. Results written to ./results/<scenario>/")