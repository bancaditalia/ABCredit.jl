"""
    initialise_workers(params)

Initializes a vector of `Worker` objects based on the given parameters.

# Arguments
- `params`: A dictionary containing the initialization parameters.

# Returns
- A vector of `Worker` objects.
"""
function initialise_workers(params)

    P = params[:init_price]

    ### INITIALISE WORKERS ###
    w = 0.0
    PA = 2.0
    Oc = 0
    income = 0.0
    cons_budget = 0.0
    permanent_income = 1.0 / P

    workers = Vector{Worker}()
    for n in 1:params[:W]
        agent = Worker(w, PA, Oc, income, cons_budget, permanent_income)
        push!(workers, agent)
    end

    return workers
end
