
module CCSModel

using JuMP, HiGHS, DataFrames, CSV, YAML

include("build_model.jl")
include("solve_report.jl")

export run

"""
    run(scen::AbstractString="baseline"; cfg_path="config/model.yml")

Load data for `scen` from YAML config, build and solve the JuMP model, and write results.
"""
function run(scen::AbstractString="baseline"; cfg_path::AbstractString="config/model.yml")

    cfg = YAML.load_file(cfg_path)
    @assert haskey(cfg, "scenarios") "Config must have a 'scenarios' key"
    @assert haskey(cfg["scenarios"], scen) "Scenario $(scen) not found in config"
    sc = cfg["scenarios"][scen]["files"]

    # --- Load dataframes ---
    df_cost = CSV.read(sc["cost"], DataFrames.DataFrame)
    df_cap  = CSV.read(sc["cap"],  DataFrames.DataFrame)
    df_dem  = CSV.read(sc["demand"], DataFrames.DataFrame)
    df_arcs = CSV.read(sc["arcs"],  DataFrames.DataFrame)

    # --- Build sets ---
    I = unique(df_cap.i)
    J = unique(df_dem.j)
    Arcs = [(row.i, row.j) for row in eachrow(df_arcs) if row.allowed == 1]

    # --- Build parameters ---
    c   = Dict( (row.i, row.j) => row.cost for row in eachrow(df_cost) )
    cap = Dict( row.i => row.cap for row in eachrow(df_cap) )
    dem = Dict( row.j => row.demand for row in eachrow(df_dem) )

    # --- Build & solve model ---
    m = build_model(I, J, Arcs, c, cap, dem; time_limit = get(cfg, "time_limit", 600))
    optimize!(m)

    # --- Summarize & write ---
    summarize_and_write(m, I, J, Arcs; outdir = joinpath(@__DIR__, "..", "results"))

    return m
end

end # module
