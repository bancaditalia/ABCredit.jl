
"""
    worker_gets_paid!(worker::AbstractWorker, model::AbstractModel)

This function calculates the income of a worker based on their employment status and the model parameters. 
    If the worker is employed, their income is determined by their wage after taxes. 
    If the worker is unemployed, they receive a subsidy. The function also updates the net worth of the worker.

# Arguments
- `worker::AbstractWorker`: The worker for whom the income is being calculated.
- `model::AbstractModel`: The model containing the parameters and government data.

"""
function worker_gets_paid!(worker::AbstractWorker, model::AbstractModel)

    #if worker has a salary he/she gets pais
    if worker.Oc > 0
        worker.w = model.agg.wb
        #net salary after taxes on wages
        worker.income = worker.w * (1 - model.params[:tax_rate])

        # taxes on income are collected
        taxes = worker.w * model.params[:tax_rate]
        model.gov.TA += taxes
        model.gov.GB += taxes
        model.gov.stock_bonds -= taxes

        _decrease_firm_liquidity([model.capital_firms; model.consumption_firms][worker.Oc], worker.w)

        #otherwise he/she gets paid unemployment_subsidy
    elseif worker.Oc == 0
        subsidy = model.gov.subsidy * model.agg.wb
        worker.income = subsidy
        model.gov.G += subsidy
        model.gov.GB -= subsidy
        model.gov.stock_bonds += subsidy
    else
        error("Workers should can only be emlpoyed at companies defined by
        positive indices or be unemployed.")
    end

    # update net worth of worker
    worker.PA += worker.income

end


function _decrease_firm_liquidity(firm::AbstractCapitalFirm, amount::Float64)
    firm.liquidity_k -= amount
end

function _decrease_firm_liquidity(firm::AbstractConsumptionFirm, amount::Float64)
    firm.liquidity -= amount
end



"""
    workers_get_paid!(workers::Vector{<:AbstractWorker}, model::AbstractModel)

Pay the workers in the given vector by calling `worker_gets_paid!` for each worker.

# Arguments
- `workers::Vector{<:AbstractWorker}`: A vector of workers to be paid.
- `model::AbstractModel`: The model used to calculate the payment.

"""
function workers_get_paid!(workers::Vector{<:AbstractWorker}, model::AbstractModel)
    for worker in workers
        worker_gets_paid!(worker, model)
    end
end
