"""
    capital_goods_market!(
        firm::AbstractConsumptionFirm,
        random_cap_firms::Vector{<:AbstractCapitalFirm},
        model::AbstractModel,
    )

This function represents the capital goods market, where consumption firms purchase capital goods from capital firms. 
The function iterates through the available capital firms, sorted by ascending price, and allows the purchasing firm 
to buy capital goods if it has sufficient liquidity and demand. The function updates the relevant variables 
and quantities based on the purchase.

# Arguments
    - `firm`:  An instance of `AbstractConsumptionFirm` representing the purchasing firm.
    - `random_cap_firms`: A vector of instances of `AbstractCapitalFirm` representing the capital firms.
    - `model`: An instance of `AbstractModel` representing the economic model.

"""
function capital_goods_market!(
    firm::AbstractConsumptionFirm,
    random_cap_firms::Vector{<:AbstractCapitalFirm},
    model::AbstractModel,
)

    # amount of liquidity available to buy capital goods
    capital_budget = firm.Ftot + firm.liquidity - firm.Leff * model.agg.wb

    # the capital market works exactly as the consumption market (via search and matching)

    # sort companies by ascending price
    order = sortperm([firm.P_k for firm in random_cap_firms])
    random_cap_firms = random_cap_firms[order]

    flag = 1

    while capital_budget > 0 && firm.K_dem > 0 && flag <= length(random_cap_firms)

        kfirm = random_cap_firms[flag]
        kfirm.Y_kd = kfirm.Y_kd + min(capital_budget / kfirm.P_k, firm.K_dem)

        #buy if best firm has still positive stocks
        if kfirm.Y_k > 0
            pk = kfirm.P_k
            budget = min(capital_budget, firm.K_dem * pk)

            # if the price is within budget
            if kfirm.Y_k > budget / pk
                kfirm.Y_k -= budget / pk  #reduce stocks
                kfirm.Q_k += budget / pk   #update sales
                firm.K_dem -= budget / pk
                capital_budget -= budget
                firm.liquidity -= budget
                kfirm.liquidity_k += budget
                firm.investment += budget / pk
                firm.value_investments += budget #j spends all its budget

            # if the price is above budget
            elseif kfirm.Y_k <= budget / pk
                firm.K_dem -= kfirm.Y_k
                capital_budget -= kfirm.Y_k * pk
                firm.liquidity -= kfirm.Y_k * pk
                kfirm.liquidity_k += kfirm.Y_k * pk
                kfirm.Q_k += kfirm.Y_k
                firm.investment += kfirm.Y_k
                firm.value_investments += kfirm.Y_k * pk
                kfirm.Y_k = 0
            end
        end

        flag += 1     #increase counter
    end
end



"""
    capital_goods_market!(
        cons_firms::Vector{<:AbstractConsumptionFirm}, 
        cap_firms::Vector{<:AbstractCapitalFirm}, 
        model::AbstractModel
    )

This function represents the market for capital goods. It iterates over each production firm and, 
    if there is a demand for capital goods, selects a random set of capital firms to transact with. 

# Arguments
- `cons_firms`: A vector of consumption firms.
- `cap_firms`: A vector of capital firms.
- `model`: An abstract model representing the economic environment.

"""
function capital_goods_market!(
    cons_firms::Vector{<:AbstractConsumptionFirm},
    cap_firms::Vector{<:AbstractCapitalFirm},
    model::AbstractModel,
)

    # vector of integers of the same length as the number of consumption firms

    reset_variables_capital_market(model, cons_firms, cap_firms)

    ids_cons_firms = collect(1:length(cons_firms))
    ids_cap_firms = collect(1:length(cap_firms))

    for id in shuffle!(ids_cons_firms)

        # investment in capital goods does not happen every epoch
        if cons_firms[id].K_dem > 0
            # take z_k random companies
            ids_cap_firms_neigh = sample(ids_cap_firms, model.params[:z_k]; replace = false)
            random_cap_firms = cap_firms[ids_cap_firms_neigh]
            capital_goods_market!(cons_firms[id], random_cap_firms, model)
        end
    end

end
