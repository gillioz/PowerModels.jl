""
function solve_dc_topf(file, optimizer; kwargs...)
    return solve_topf(file, DCPPowerModel, optimizer; kwargs...)
end

""
function solve_topf(file, model_type::Type, optimizer; kwargs...)
    return solve_model(file, model_type, optimizer, build_topf; kwargs...)
end

""
function build_topf(pm::AbstractPowerModel)
    variable_bus_voltage(pm)
    variable_gen_power(pm)
    variable_branch_power(pm)
    variable_dcline_power(pm)

    objective_min_fuel_and_branch_cost(pm)

    constraint_model_voltage(pm)

    for i in ids(pm, :ref_buses)
        constraint_theta_ref(pm, i)
    end

    for i in ids(pm, :bus)
        constraint_power_balance(pm, i)
    end

    for i in ids(pm, :branch)
        constraint_ohms_yt_from(pm, i)
        constraint_ohms_yt_to(pm, i)

        constraint_voltage_angle_difference(pm, i)

        constraint_thermal_limit_from(pm, i)
        constraint_thermal_limit_to(pm, i)
    end

    for i in ids(pm, :dcline)
        constraint_dcline_power_losses(pm, i)
    end

    for i in ids(pm, :gen)
        gen = ref(pm, nw_id_default, :gen, i)
        if haskey(gen, "ramp_max") & haskey(gen, "pg")
            pg = var(pm, nw_id_default, :pg, i)

            pmin = gen["pg"] - gen["ramp_max"]
            if JuMP.lower_bound(pg) < pmin
                JuMP.set_lower_bound(pg, pmin)
            end

            pmax = gen["pg"] + gen["ramp_max"]
            if JuMP.upper_bound(pg) > pmax
                JuMP.set_upper_bound(pg, pmax)
            end
        end
    end
end




