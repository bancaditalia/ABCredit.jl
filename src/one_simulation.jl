"""
    run_one_sim!(model::AbstractModel, T::Int64; seed = nothing)

Simulates the model for a given number of time steps. In essence it performs a for loop over the complete step function
    for T times and saves results into an object called 'd'.

# Arguments
- `model::AbstractModel`: The model to be simulated.
- `T::Int64`: The number of time steps to simulate.
- `seed = nothing`: Optional seed for the random number generator.
- `burn_in = 0`: Number of time steps to run before starting to collect data.

# Returns
- `d::ABCreditData`: The data collector object containing the simulation results.

"""
function run_one_sim!(model::AbstractModel, T::Int64; seed = nothing, burn_in = 0)

    Random.seed!(seed)

    for _ in 1:burn_in
        one_model_step!(model)
    end

    model.agg.timestep = 1 # reset time counter

    # initialise data collector 
    d = ABCreditData(T)

    # store variables at initialisation
    update_data!(d, model)

    for _ in 1:T
        one_model_step!(model)
        # update relevant variables
        update_data!(d, model)
    end

    return d
end



"""
    run_n_sims(model, T, n_sims)

Run multiple independent simulations of a given model in parallel.

# Arguments
- `model`: The model to be simulated.
- `T`: The duration of each simulation.
- `n_sims`: The number of simulations to run.

# Returns
An array of `ABCreditData` objects, each representing the data generated from a single simulation.

"""
function run_n_sims(model, T, n_sims; burn_in = 0)

    data_vector = Vector{ABCredit.ABCreditData}(undef, n_sims)

    Threads.@threads for i in 1:n_sims
        model_i = deepcopy(model)
        data = run_one_sim!(model_i, T; burn_in = burn_in)
        data_vector[i] = data
    end
    return data_vector
end
