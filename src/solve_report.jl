
using JuMP, DataFrames, CSV

"""
    summarize_and_write(m, I, J, Arcs; outdir="results", scenario=nothing)

Write flows, open decisions, and objective value to CSVs in `outdir`.
If `scenario` is given, include it as a column.
"""
function summarize_and_write(m::Model, I, J, Arcs; outdir::AbstractString="results", scenario=nothing)
    isdir(outdir) || mkpath(outdir)

    x = m[:x]
    y = m[:y]

    flows = DataFrame(
        i    = [i for (i,_) in Arcs],
        j    = [j for (_,j) in Arcs],
        flow = [value(x[(i,j)]) for (i,j) in Arcs]
    )
    if scenario !== nothing
        flows.scenario = fill(String(scenario), nrow(flows))
    end
    CSV.write(joinpath(outdir, "flows.csv"), flows)

    opens = DataFrame(
        i    = I,
        open = [value(y[i]) for i in I]
    )
    if scenario !== nothing
        opens.scenario = fill(String(scenario), nrow(opens))
    end
    CSV.write(joinpath(outdir, "open_plants.csv"), opens)

    objdf = DataFrame(obj = [objective_value(m)])
    if scenario !== nothing
        objdf.scenario = [String(scenario)]
    end
    CSV.write(joinpath(outdir, "objective.csv"), objdf)
end
