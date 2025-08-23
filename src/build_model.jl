
using JuMP, HiGHS

"""
    build_model(I, J, Arcs, c, cap, dem; time_limit=600)

Construct a simple transport-style cost minimization with plant open binaries.

Minimize:  sum_{(i,j)∈Arcs} c[i,j] * x[i,j]
s.t.      ∑_j x[i,j] ≤ cap[i] * y[i]           ∀ i∈I
          ∑_i x[i,j] ≥ dem[j]                  ∀ j∈J
          x[i,j] ≥ 0, y[i] ∈ {0,1}
"""
function build_model(I, J, Arcs, c::Dict, cap::Dict, dem::Dict; time_limit::Real=600)
    m = Model(HiGHS.Optimizer)
    set_optimizer_attribute(m, "time_limit", float(time_limit))
    # optional: make solver quiet
    set_optimizer_attribute(m, "log_to_console", false)

    # Variables
    @variable(m, x[Arcs] >= 0)    # flows
    @variable(m, y[I], Bin)       # open plant i

    # Objective
    @objective(m, Min, sum(c[(i,j)] * x[(i,j)] for (i,j) in Arcs if haskey(c,(i,j))))

    # Supply (capacity if opened)
    @constraint(m, supply[i in I], sum(x[(i,j)] for j in J if (i,j) in Arcs) <= cap[i] * y[i])

    # Demand
    @constraint(m, demand[j in J], sum(x[(i,j)] for i in I if (i,j) in Arcs) >= dem[j])

    return m
end
