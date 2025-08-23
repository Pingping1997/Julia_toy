
using JuMP, DataFrames, CSV

"""
    summarize_and_write(m, I, J, Arcs; outdir="results")

Write flows, open decisions, and objective value to CSVs in `outdir`.
"""
function summarize_and_write(m::Model, I, J, Arcs; outdir::AbstractString="results")
    isdir(outdir) || mkpath(outdir)

    x = m[:x]
    y = m[:y]

    flows = DataFrame(i = [i for (i,_) in Arcs],
                      j = [j for (_,j) in Arcs],
                      flow = [value(x[(i,j)]) for (i,j) in Arcs])
    CSV.write(joinpath(outdir, "flows.csv"), flows)

    opens = DataFrame(i = I, open = [value(y[i]) for i in I])
    CSV.write(joinpath(outdir, "open_plants.csv"), opens)

    obj = objective_value(m)
    CSV.write(joinpath(outdir, "objective.csv"), DataFrame(obj = [obj]))
end
