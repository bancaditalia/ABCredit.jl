"""
A production firm produces consumption goods
"""


"""
    firm_produces!(firm::AbstractConsumptionFirm, model::AbstractModel)

This function updates the production of a consumption firm based on available resources and model parameters.

# Arguments
- `firm::AbstractConsumptionFirm`: The consumption firm for which production is being updated.
- `model::AbstractModel`: The model containing the parameters and aggregate variables.

"""
function firm_produces!(firm::AbstractConsumptionFirm, model::AbstractModel)
    #production frontier given available resources (Leontieff)
    Yp = min(firm.Leff * model.params[:alpha], firm.K * model.params[:k])
    firm.Y = min(firm.De, Yp)       #actual production

    firm.Y_prev = firm.Y

    #compute interests to be paid at the end of the period
    firm.interests = firm.interest_r * firm.deb

    #total wages paid by firms
    firm.wages = model.agg.wb * firm.Leff

    #minimum prices capital
    if firm.Y_prev == 0
        Pl = 0
    else
        #TODO: why 1.01 here?
        Pl =
            1.01 * (firm.wages + firm.interests + firm.Y / model.params[:k] * model.params[:eta] * model.agg.price_k) /
            firm.Y_prev
    end

    #set minum price if needed
    if firm.P < Pl
        firm.P = Pl
    end
end


"""
    firm_produces!(firm::AbstractCapitalFirm, model::AbstractModel)

This function updates the production of a capital firm based on available resources and model parameters.

# Arguments
- `firm::AbstractCapitalFirm`: The consumption firm for which production is being updated.
- `model::AbstractModel`: The model containing the parameters and aggregate variables.

"""
function firm_produces!(firm::AbstractCapitalFirm, model::AbstractModel)
    # output is minimum between expected future demand
    # and the actual production possibility of the firm
    firm.Y_k = min(firm.De_k, firm.Leff_k * model.params[:alpha])
    firm.Y_prev_k = firm.Y_k

    #Y_k is increased by the inventories (capital good is durable)
    firm.Y_k = firm.Y_k + firm.inventory_k

    #compute interests to be paid at the end of the period
    firm.interests_k = firm.interest_r_k * firm.deb_k

    #total wages paid by firms
    firm.wages_k = model.agg.wb * firm.Leff_k

    #minimum prices capital
    if firm.Y_prev_k == 0
        Pl_k = 0
    else
        #TODO: why 1.01 here?
        Pl_k = 1.01 * (firm.wages_k + firm.interests_k) / firm.Y_prev_k
    end

    #set minum price if needed
    if firm.P_k < Pl_k
        firm.P_k = Pl_k
    end
end



"""
    firms_produce!(firms, model)

Iterates over a collection of firms and calls the `firm_produces!` function for each firm.

# Arguments
- `firms`: A vector of consumption or capital firms.
- `model`: An abstract model representing the economic environment.

"""
function firms_produce!(
    firms::Union{Vector{<:AbstractConsumptionFirm}, Vector{<:AbstractCapitalFirm}},
    model::AbstractModel,
)
    for firm in firms
        firm_produces!(firm, model)
    end
end
