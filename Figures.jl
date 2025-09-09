using Plots
using ColorSchemes
# Figure 1, CO2 emissions projections for the three scenarios

years = [2020, 2030, 2040, 2050]

data = Dict(
    "Time" => ["2020", "2030", "2040", "2050"],
    "Optimistic" => Dict(
        "CO2_total" => [0, 2759248, 2678471, 2584959],
        "CO2_Process" => [0, 1822609, 1822609, 1822609],
        "CO2_Fossil" => [0, 136869, 84557.5, 0],
        "CO2_RDF_fossil" => [0, 410608, 295951, 301732],
        "CO2_Bio" => [0, 364985, 465066, 452597],
        "CO2_Ele" => [0, 24178.03898, 10287.29062, 8020.599468]
    ),
    "Baseline" => Dict(
        "CO2_total" => [3224900, 2862283, 2749793, 2654102],
        "CO2_Process" => [1822609, 1822609, 1822609, 1822609],
        "CO2_Fossil" => [355638, 199172.6, 136869.2, 81915.08],
        "CO2_RDF_fossil" => [535571, 497931, 410608, 344043],
        "CO2_Bio" => [233348, 298759, 364985, 393192],
        "CO2_Ele" => [277734, 43811.07159, 14722.44965, 12341.84273]
    ),
    "Conservative" => Dict(
        "CO2_total" => [0, 3027219, 2862297, 2747431],
        "CO2_Process" => [0, 1822609, 1822609, 1822609],
        "CO2_Fossil" => [0, 284601, 242050, 206827],
        "CO2_RDF_fossil" => [0, 527039, 474418, 422647],
        "CO2_Bio" => [0, 242438, 251732, 269775],
        "CO2_Ele" => [0, 150531.5407, 71487.95178, 25572.92584]
    )
)

components = ["CO2_Process", "CO2_Fossil", "CO2_RDF_fossil", "CO2_Bio", "CO2_Ele"]
labels_map = Dict(
    "CO2_Process" => "Process",
    "CO2_Fossil" => "Fossil",
    "CO2_RDF_fossil" => "RDF",
    "CO2_Bio" => "Biogenic",
    "CO2_Ele" => "Elec+others"
)

# Use CamelCase scheme names available in ColorSchemes.jl
schemes = Dict(
    "CO2_Process"     => ColorSchemes.Blues_9,
    "CO2_Fossil"      => ColorSchemes.Greys_9,
    "CO2_RDF_fossil"  => ColorSchemes.Oranges_9,
    "CO2_Bio"         => ColorSchemes.Greens_9,
    "CO2_Ele"         => ColorSchemes.Purples_9
)

scenario_intensity = Dict(
    "Optimistic" => 0.50,
    "Baseline" => 0.75,
    "Conservative" => 1.00
)

bar_width = 0.25
index = collect(1:length(years))
scenarios = ["Optimistic", "Baseline", "Conservative"]

# helper to pick a color from a scheme at intensity t ∈ [0,1]
pickcolor(cs, t) = get(cs, clamp(t, 0.0, 1.0))

default(fontfamily = "Times New Roman")

plt = plot(
    size=(900, 900),
    legend=:topright,
    framestyle=:box,
    grid=:y,            # enable y-grid via attributes (no grid! function)
    gridstyle=:dash,
    gridalpha=0.6,
    gridlinewidth=0.5
)
ylims!(plt, 1.5, 3.5)
xlabel!(plt, "Year")
ylabel!(plt, "CO₂ (Mt/y)")
xticks!(plt, (index, string.(years)))

# show each component once in legend
shown = Dict(k => false for k in components)

for (i, scen) in enumerate(scenarios)
    x = index .+ (i - 2) * bar_width
    Y = hcat([ (data[scen][comp] ./ 1_000_000) for comp in components ]...)  # 4×5 (Mt/y)

    # stack components by repeated bar! calls at same x
    for (j, comp) in enumerate(components)
        vals = Y[:, j]
        col = pickcolor(schemes[comp], scenario_intensity[scen])
        thelabel = shown[comp] ? "" : labels_map[comp]
        bar!(plt, x, vals;
             bar_position=:stack,
             linewidth=0.5,
             linecolor=:black,
             color=col,
             label=thelabel)
        shown[comp] = true
    end

    # add totals above stacks
    totals = data[scen]["CO2_total"] ./ 1_000_000
    stacktops = sum(Y; dims=2)[:]
    for k in eachindex(x)
        annotate!(plt, x[k], stacktops[k] + 0.05, text(@sprintf("%.2f", totals[k]), :center, 10))
    end
end

display(plt)