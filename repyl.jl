using Pkg
Pkg.add("Gurobi")

using JuMP, Gurobi

m = Model(Gurobi.Optimizer)
@variable(m, x >= 0, Int)
@variable(m, y >= 0)
@constraint(m, 2x + y <= 10)
@objective(m, Max, x + y)
optimize!(m)

println("x = ", value(x), ", y = ", value(y))