
"""
    household_finds_cons_budget!(household::AbstractAgent, model::AbstractModel)

Compute the consumption budget for a household based on its income and certain model parameters.

# Arguments
- `household::AbstractAgent`: The household for which to compute the consumption budget.
- `model::AbstractModel`: The model object containing the parameters.

# Details
- The household's consumption budget is computed as the target consumption level multiplied by the aggregate price.
- The target consumption level is determined based on the household's real permanent income.

"""
function household_finds_cons_budget!(household::AbstractAgent, model::AbstractModel)
    #households compute their consumption budgets
    rel_income = household.income / model.agg.price

    #what about taking the rolling mean of incomes?
    #standard deviation of consumption = standard deviation of wealth
    household.permanent_income = household.permanent_income * model.params[:xi] + (1 - model.params[:xi]) * rel_income

    #http://books.google.it/books?id=DWnhhYdmAucC&pg=PA93&lpg=PA93&dq=permanent+income+rules+in+agent+based+modeling&source=bl&ots=psxGRexvx2&sig=Qo2QXcsxtd2K0sQlT2rOC7iSWk8&hl=en&sa=X&ei=DLLfUpDNBcXWtAbmk4DACA&ved=0CFAQ6AEwBDgK#v=onepage&q&f=false
    target = household.permanent_income + model.params[:chi] * household.PA / model.agg.price #0.05

    household.cons_budget = target * model.agg.price
    household.cons_budget = min(household.PA, household.cons_budget)
end


"""
A household (either a worker or sfirm owner) buys a consumption good
at the cheapest nearest price
"""


"""
    consumption_goods_market!(
        household::AbstractAgent,
        random_cons_firms::Vector{<:AbstractConsumptionFirm},
        model::AbstractModel,
    )

This function represents the market for consumption goods. A household purchases goods from a list of randomly selected 
    consumption firms sorted by price. The household iterates through the firms and buys goods until either the budget is
    exhausted or there are no more firms available.

# Arguments
- `household::AbstractAgent`: An abstract agent representing the household.
- `random_cons_firms::Vector{<:AbstractConsumptionFirm}`: A vector of randomly selected consumption firms, where each firm is a subtype of `AbstractConsumptionFirm`.
- `model::AbstractModel`: An abstract model representing the economic model.

"""
function consumption_goods_market!(
    household::AbstractAgent,
    random_cons_firms::Vector{<:AbstractConsumptionFirm},
    model::AbstractModel,
)
    # remove consumption from net worth
    household.PA -= household.cons_budget

    # sort companies by ascending price
    order = sortperm([firm.P for firm in random_cons_firms])
    random_cons_firms = random_cons_firms[order]

    flag = 1

    #continue buying till budget is positive and there are firms available

    while (household.cons_budget > 0.0 && flag <= length(random_cons_firms))
        #pick first best firm; with flag increasing, pick the second best, the third...
        firm = random_cons_firms[flag]
        firm.Yd += household.cons_budget / firm.P

        if firm.Y > 0  #buy if best firm has still positive stocks

            p = firm.P
            if firm.Y > household.cons_budget / p
                firm.Y -= household.cons_budget / p    # reduce stocks
                firm.Q += household.cons_budget / p
                model.agg.con += household.cons_budget / p # update sales
                firm.liquidity += household.cons_budget
                household.cons_budget = 0              # j spends all its budget

            elseif firm.Y <= household.cons_budget / p
                household.cons_budget -= firm.Y * p
                firm.liquidity += firm.Y * p
                firm.Q += firm.Y
                model.agg.con += firm.Y
                firm.Y = 0
            end
        end
        flag += 1  # increase counter i.e go to the next firm if applicable
    end

    # search and matching ends
    # unvoluntary savings are added to the voluntary ones
    household.PA += household.cons_budget #unspent of household budget

end


"""
    households_find_cons_budget!(households::Vector{<:AbstractAgent}, model::AbstractModel)

Iterates over a vector of households and compute the consumption budget for each household.

# Arguments
- `households::Vector{<:AbstractAgent}`: A vector of households.
- `model::AbstractModel`: An abstract model.

"""
function households_find_cons_budget!(households::Vector{<:AbstractAgent}, model::AbstractModel)

    for household in households
        household_finds_cons_budget!(household, model)
    end

end



"""
    consumption_goods_market!(
        households::Vector{<:AbstractAgent},
        cons_firms::Vector{<:AbstractConsumptionFirm},
        model::AbstractModel,
    )

This function represents the market for consumption goods. It iterates over each household, checks if the household has
     a positive budget. If so, it randomly selects consumption firms and buys goods from those firms.

# Arguments
- `households`: A vector of objects representing households.
- `cons_firms`: A vector of objects representing consumption firms.
- `model`: An object representing the economic model.

"""
function consumption_goods_market!(
    households::Vector{<:AbstractAgent},
    cons_firms::Vector{<:AbstractConsumptionFirm},
    model::AbstractModel,
)
    reset_variables_consumption_market(model, cons_firms)

    ids_households = collect(1:length(households))
    ids_cons_firms = collect(1:length(cons_firms))


    for id in shuffle(ids_households)
        household = households[id]
        # consume if you have a positive budget
        if household.cons_budget > 0
            # take z_c random companies and consume there
            ids_cons_firms_neigh = sample(ids_cons_firms, model.params[:z_c]; replace = false)
            random_cons_firms = cons_firms[ids_cons_firms_neigh]
            consumption_goods_market!(household, random_cons_firms, model)
        end
    end
    model.agg.consumption = model.agg.con * model.agg.init_price #evaluated at constant prices

end
