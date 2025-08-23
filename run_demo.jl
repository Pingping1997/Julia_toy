
# run_demo.jl
# Usage:
#   julia run_demo.jl baseline
#   julia run_demo.jl optimistic

import Pkg
Pkg.activate(@__DIR__)

# Try to load deps; if missing, add them once.
try
    using JuMP, HiGHS, CSV, DataFrames, YAML
catch
    Pkg.add(["JuMP", "HiGHS", "CSV", "DataFrames", "YAML"])
    using JuMP, HiGHS, CSV, DataFrames, YAML
end

include(joinpath(@__DIR__, "src", "CCSModel.jl"))
using .CCSModel

scenario = length(ARGS) >= 1 ? ARGS[1] : "baseline"
println("Running scenario: ", scenario)
CCSModel.run(scenario; cfg_path = joinpath(@__DIR__, "config", "model.yml"))
println("Done. Results written to ./results")
