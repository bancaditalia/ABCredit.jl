"""
    firm_fires_workers!(firm::AbstractConsumptionFirm, model::AbstractModel)

A consumption firm computes labour demand and fires workers if necessary

# Arguments
- `firm::AbstractConsumptionFirm`: The firm for which labor demand and worker firing is being updated.
- `model::AbstractModel`: The model in which the firm is operating.

"""
function firm_fires_workers!(firm::AbstractConsumptionFirm, model::AbstractModel)
    workers = model.workers
    ##re-define labour demand given available liquidity
    #note: we clipping firm.Ld to be higher than zero is needed to avoid
    # negative infinities
    liquidity_constraint = (firm.Ftot + firm.liquidity) / model.agg.wb
    if !isnan(liquidity_constraint)
        firm.Ld = max(0, floor(min(firm.Ld, liquidity_constraint))) #demand (stock)
    else
        firm.Ld = 0
    end

    #since there is the capital the firms can have positive equity and negative
    #liquidity, in this latter case Ld would be negative, which is impossible
    if firm.Ld < 1
        firm.Ld = 1
    end

    firm.vacancies = firm.Ld - firm.Leff       #definitive labour demand (flow)


    # define a vector of integers of the same length as the number of workers
    ids_workers_rand = collect(1:length(workers))

    #firms with excess workforce fire
    if firm.vacancies < 0
        #take randomly "-vacancies(i)" workers and fire them
        fired = 0
        for id in shuffle!(ids_workers_rand)
            if workers[id].Oc == firm.firm_id && fired < -firm.vacancies
                workers[id].Oc = 0
                workers[id].w = 0
                fired += 1
            end
            if fired >= -firm.vacancies
                break
            end
        end
        firm.Leff = firm.Ld #update no. of workers
    end

end


"""
    firm_fires_workers!(firm::AbstractCapitalFirm, model::AbstractModel)

A capital firm computes labour demand and fires workers if necessary

# Arguments
- `firm::AbstractCapitalFirm`: The firm for which labor demand and worker firing is being updated.
- `model::AbstractModel`: The model in which the firm is operating.

"""
function firm_fires_workers!(firm::AbstractCapitalFirm, model::AbstractModel)
    workers = model.workers

    #determine desired labour and vacancies given available liquidity
    liquidity_constraint = (firm.Ftot_k + firm.liquidity_k) / model.agg.wb
    if !isnan(liquidity_constraint)
        firm.Ld_k = max(0, floor(min(firm.Ld_k, liquidity_constraint)))
    else
        firm.Ld_k = 0
    end

    if firm.Ld_k < 1
        firm.Ld_k = 1
    end

    firm.vacancies_k = firm.Ld_k - firm.Leff_k

    # define a vector of integers of the same length as the number of workers
    ids_workers_rand = collect(1:length(workers))

    #firms with excess workforce fire
    if firm.vacancies_k < 0
        #take randomly "-vacancies(i)" workers and fire them
        fired = 0
        #for id in shuffle(ids_workers)
        for id in shuffle!(ids_workers_rand)
            if workers[id].Oc == firm.firm_id && fired < -firm.vacancies_k
                workers[id].Oc = 0
                workers[id].w = 0
                fired += 1
            end
            if fired >= -firm.vacancies_k
                break
            end
        end
        firm.Leff_k = firm.Ld_k #update no. of workers
    end
end


function _fill_vacancy_if_present!(worker::AbstractWorker, firm::AbstractConsumptionFirm, wb::Float64)
    if firm.vacancies > 0
        worker.Oc = firm.firm_id
        worker.w = wb
        firm.Leff += 1
        firm.vacancies -= 1
    end
end

function _fill_vacancy_if_present!(worker::AbstractWorker, firm::AbstractCapitalFirm, wb::Float64)
    if firm.vacancies_k > 0
        worker.Oc = firm.firm_id             #update employed status
        worker.w = wb             #salary
        firm.Leff_k += 1       #firm's workforce
        firm.vacancies_k -= 1  #firm's vacancies
    end
end

"""
    worker_searches_job!(worker, random_firms, model)

A worker searches for a job by iterating through a list of random firms.

# Arguments
- `worker::AbstractWorker`: The worker searching for a job.
- `random_firms::Vector{<:AbstractFirm}`: A vector of random firms to search for job vacancies.
- `model::AbstractModel`: The model containing the parameters and aggregate variables.

# Details
- The function iterates through the `random_firms` vector and tries to fill a vacancy for the worker.
- The search stops if the worker finds a job or if the worker runs out of firms to visit.

"""
function worker_searches_job!(worker::AbstractWorker, random_firms::Vector{<:AbstractFirm}, model::AbstractModel)

    flag = 1

    while worker.Oc == 0 && flag <= model.params[:z_e]
        random_firm = random_firms[flag]

        _fill_vacancy_if_present!(worker, random_firm, model.agg.wb)

        flag += 1                       #increase counter
    end
end


"""
    firms_fire_workers!(firms, model)

Fire workers for each firm in the given vector of firms.

# Arguments
- `firms`: A vector of firms, which can be either `Vector{<:AbstractConsumptionFirm}` or `Vector{<:AbstractCapitalFirm}`.
- `model`: An instance of `AbstractModel` representing the economic model.

"""
function firms_fire_workers!(
    firms::Union{Vector{<:AbstractConsumptionFirm}, Vector{<:AbstractCapitalFirm}},
    model::AbstractModel,
)
    for firm in firms
        firm_fires_workers!(firm, model)
    end
end


"""
    workers_search_job!(workers::Vector{<:AbstractWorker}, model::AbstractModel)

Loop over all workers and search for a job for each unemployed worker.

# Arguments
- `workers::Vector{<:AbstractWorker}`: A vector of workers.
- `model::AbstractModel`: The model object containing information about the firms.

"""
function workers_search_job!(workers::Vector{<:AbstractWorker}, model::AbstractModel)

    cap_firms = model.capital_firms
    cons_firms = model.consumption_firms
    firms = [cap_firms; cons_firms]

    # randomly loop over all workers, without instantiating a new array
    ids_workers_rand = collect(1:length(workers))

    # get a vector of integers of the same length as the number of workers
    ids_firms = collect(1:length(firms))

    for id in shuffle(ids_workers_rand)
        # if unemployed look for a job
        if workers[id].Oc == 0
            ids_firms_neigh = sample(ids_firms, model.params[:z_e]; replace = false)
            random_firms = firms[ids_firms_neigh]
            worker_searches_job!(workers[id], random_firms, model)
        end
    end
end
