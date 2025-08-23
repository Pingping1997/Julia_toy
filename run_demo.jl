
# run_demo.jl
# Usage:
#   julia run_demo.jl baseline
#   julia run_demo.jl optimistic

import Pkg
Pkg.activate(@__DIR__)

# Try to load deps; if missing, add them once.
try
    using JuMP, Gurobi, CSV, DataFrames, YAML
catch
    Pkg.add(["JuMP", "Gurobi", "CSV", "DataFrames", "YAML"])
    using JuMP, Gurobi, CSV, DataFrames, YAML
end

include(joinpath(@__DIR__, "src", "CCSModel.jl"))
using .CCSModel
cfg_path = joinpath(@__DIR__, "config", "model.yml")

scenario = length(ARGS) >= 1 ? ARGS[1] : "baseline"
if scenario == "all"
    using YAML
    cfg = YAML.load_file(cfg_path)
    for scen in keys(cfg["scenarios"])
        println("Running scenario: ", scen)
        CCSModel.run(String(scen); cfg_path=cfg_path, outdir_base=joinpath(@__DIR__, "results"))
    end
else
    println("Running scenario: ", scenario)
    CCSModel.run(scenario; cfg_path=cfg_path, outdir_base=joinpath(@__DIR__, "results"))
end

println("Done. Results written to ./results/<scenario>/")