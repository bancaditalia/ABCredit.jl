"""
    firm_goes_bankrupt!(firm::AbstractConsumptionFirm, model::AbstractModel)

This function represents the process of a consumption firm going bankrupt in the model. Residual debts are accounted as 
    losses for the bank, and the firm's assets are reset to zero, then a new firm is initialized.

# Arguments
- `firm::AbstractConsumptionFirm`: The firm that is going bankrupt.
- `model::AbstractModel`: The model in which the firm operates.

"""
function firm_goes_bankrupt!(firm::AbstractConsumptionFirm, model::AbstractModel)

    cons_firms = model.consumption_firms
    workers = model.workers

    model.agg.defaults += 1

    #take residual debts
    model.bank.profitsB = model.bank.profitsB + (firm.liquidity - firm.deb) #account for bad debts
    model.bank.loans = model.bank.loans - firm.deb
    model.bank.E += (firm.liquidity - firm.deb)


    # compute average price of consumption goods for non-bankrupt firms
    mean_P = mean([firm.P for firm in cons_firms])

    to_trim = [firm.Y_prev for firm in cons_firms if (firm.liquidity - firm.deb) > 0]
    if isempty(to_trim)
        println("WARNING: all consumption firms are very indebted")
        tmean_Y_prevp = Inf
    else
        tmean_Y_prevp = mean(trim(to_trim, prop = 0.1))
    end

    firm.A = firm.PA + firm.K * model.agg.price_k   #initialize new firm

    firm.capital_value = firm.K * model.agg.price_k
    firm.PA = 0
    firm.liquidity = firm.A - firm.K * model.agg.price_k

    firm.deb = 0
    firm.P = mean_P

    targetLev = 0.2
    mxY = ((firm.A + targetLev * firm.A / (1 - targetLev)) * 1 / model.agg.wb) * model.params[:alpha]

    firm.Y_prev = min(tmean_Y_prevp, mxY)
    firm.Yd = firm.Y_prev
    firm.x = firm.Y_prev / model.params[:k] / firm.K
    firm.barK = firm.K
    firm.barYK = firm.Y_prev / model.params[:k]
    firm.Y = 0
    firm.stock = 0
    firm.interest_r = model.params[:r_f]

    ##fire workers
    _firm_fires_all_workers!(firm, workers)
end



"""
    firm_goes_bankrupt!(firm::AbstractCapitalFirm, model::AbstractModel)

This function represents the process of a capital firm going bankrupt in the model. Residual debts are accounted as 
    losses for the bank, and the firm's assets are reset to zero, then a new firm is initialized.

# Arguments
- `firm::AbstractCapitalFirm`: The firm that is going bankrupt.
- `model::AbstractModel`: The model in which the firm operates.

"""
function firm_goes_bankrupt!(firm::AbstractCapitalFirm, model::AbstractModel)

    cap_firms = model.capital_firms
    workers = model.workers

    model.agg.defaults_k += 1
    #take residual debts
    model.bank.profitsB = model.bank.profitsB + (firm.liquidity_k - firm.deb_k)   #account for bad debts
    model.bank.loans = model.bank.loans - firm.deb_k
    model.bank.E += (firm.liquidity_k - firm.deb_k)


    #update bankrupted firms!
    mean_P_k = mean([firm.P_k for firm in cap_firms])

    # compute average price of capital goods for non-bankrupt firms
    to_trim = [firm.Y_prev_k for firm in cap_firms if firm.A_k > 0]
    if isempty(to_trim)
        println("WARNING: all capital firms are bankrupted")
        tmean_Y_prevp_k = Inf
    else
        tmean_Y_prevp_k = mean(trim(to_trim, prop = 0.1))
    end

    firm.A_k = firm.PA        #initialize new firm
    firm.PA = 0
    firm.liquidity_k = firm.A_k
    firm.deb_k = 0
    firm.P_k = mean_P_k

    #maximum initial productin is given by the leverage
    targetLev = 0.2
    mxY = ((firm.A_k + targetLev * firm.A_k / (1 - targetLev)) * 1 / model.agg.wb) * model.params[:alpha]

    firm.Y_prev_k = min(tmean_Y_prevp_k, mxY)
    firm.Y_kd = firm.Y_prev_k
    firm.Y_k = 0
    firm.stock_k = 0
    firm.interest_r_k = model.params[:r_f]

    ##fire workers
    _firm_fires_all_workers!(firm, workers)
end


"""
    _firm_fires_all_workers!(firm::AbstractCapitalFirm, model::AbstractModel, workers::Vector{<:AbstractWorker})

Fire all workers associated with a given capital firm.

# Arguments
- `firm::AbstractCapitalFirm`: The firm object.
- `workers::Vector{<:AbstractWorker}`: A vector of all workers.

"""
function _firm_fires_all_workers!(firm::AbstractCapitalFirm, workers::Vector{<:AbstractWorker})
    for worker in workers
        if worker.Oc == firm.firm_id
            worker.Oc = 0
            worker.w = 0
        end
    end
    firm.Leff_k = 0
end



"""
    _firm_fires_all_workers!(firm::AbstractConsumptionFirm, model::AbstractModel, workers::Vector{<:AbstractWorker})

Fire all workers associated with a given consumption firm.

# Arguments
- `firm::AbstractConsumptionFirm`: The firm object.
- `workers::Vector{<:AbstractWorker}`: A vector of all workers.

"""
function _firm_fires_all_workers!(firm::AbstractConsumptionFirm, workers::Vector{<:AbstractWorker})
    for worker in workers
        if worker.Oc == firm.firm_id
            worker.Oc = 0
            worker.w = 0
        end
    end
    firm.Leff = 0
end



"""
    firms_go_bankrupt!(cons_firms, cap_firms, model)

Iterates over the list of consumption firms and capital firms, and checks if any of them have negative assets.
If a firm has negative assets, it is considered bankrupt and the `firm_goes_bankrupt!` function is called to handle the bankruptcy.

# Arguments
- `cons_firms`: A vector of consumption firms.
- `cap_firms`: A vector of capital firms.
- `model`: An abstract model representing the economic model.

"""
function firms_go_bankrupt!(
    cons_firms::Vector{<:AbstractConsumptionFirm},
    cap_firms::Vector{<:AbstractCapitalFirm},
    model::AbstractModel,
)
    for firm in cons_firms
        #pick sequentially failed firms
        if firm.A < 0
            firm_goes_bankrupt!(firm, model)
        end
    end

    for firm in cap_firms
        #pick sequentially failed firms
        if firm.A_k < 0
            firm_goes_bankrupt!(firm, model)
        end
    end
end
