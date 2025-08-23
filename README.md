
# JuMP Demo (GAMS -> Julia style)

This is a minimal end-to-end demo showing a "smart" data pipeline for a cost-minimization model in Julia using JuMP.

## What it shows
- CSV inputs for **cost**, **cap**, **demand**, **arcs**
- YAML config for **scenarios** (baseline, optimistic)
- Clean module layout: `src/` with `build_model.jl`, `solve_report.jl`
- One command to run and auto-install dependencies

## How to run
1) Install Julia (>= 1.10).
2) In a terminal:
```bash
cd jump-demo
julia run_demo.jl baseline
# or
julia run_demo.jl optimistic
```

This script will:
- create/activate a local environment,
- install JuMP/HiGHS/CSV/DataFrames/YAML if needed,
- build & solve the model,
- write results to `./results/`:
  - `flows.csv`
  - `open_plants.csv`
  - `objective.csv`

## Files
- `data/` — CSV tables (tidy)
- `config/model.yml` — scenario file paths and solver time limit
- `src/` — model code
- `run_demo.jl` — entry point

## Extend it
- Add time periods `t` columns to CSVs, then index Dicts by `(i,j,t)`.
- Add more constraints in `build_model.jl` following the same pattern.
- Swap solver: change `HiGHS.Optimizer` to `Gurobi.Optimizer` (and add Gurobi package).

