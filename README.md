PowerModels.jl with line costs
==============================

This project is a fork of [PowerModels.jl](https://github.com/lanl-ansi/PowerModels.jl)
implementing line costs in the objective function.
It is being used in the [PowerData](https://github.com/GeeeHesso/PowerData/) repository for generating data
for machine learning appplications in power systems.

For each line ("branch" key of the network data dictionary),
if a "cost" property is present,
then the objective function is enhanced with a term proportional to the square of the power flowing through that line,
multiplied by the cost and divided by the thermal rating for the line ("rate_a" property of the branch).

The default behavior uses this modified OPF through the `build_opf` function
instead of the regular OPF.

In addition, it is possible to use a version of the
["Lazy Line Flow Limits"](https://lanl-ansi.github.io/PowerModels.jl/stable/utilities/#Lazy-Line-Flow-Limits) algorithm
in which the line costs are only turned on if the power flow through the line reach a certain threshold
given as a fraction of the line's thermal limit.
To use it, set a "cost_threshold" property for each line and call `solve_opf_branch_power_cuts`.
