

"""
    firm_decides_price_quantity!(firm::AbstractConsumptionFirm, model::AbstractModel)

This function is used by a consumption firm to decide its price and quantity based on its current stock level and the 
    aggregate price in the model. The function modifies the firm's expected demand (`firm.De`) 
    and price (`firm.P`) accordingly.

# Arguments
- `firm::AbstractConsumptionFirm`: The consumption firm that takes the price and quantity decisions.
- `model::AbstractModel`: The model containing the aggregate price and other parameters.

"""
function firm_decides_price_quantity!(firm::AbstractConsumptionFirm, model::AbstractModel)

    firm.stock = firm.Y_prev - firm.Yd

    if firm.stock <= 0 && firm.P >= model.agg.price
        firm.De = firm.Y_prev + (-firm.stock) * model.params[:q_adj]     # De is firm's expected demand

    # stocks are negative and prices are low -> increase price
    elseif firm.stock <= 0 && firm.P < model.agg.price
        firm.De = firm.Y_prev
        firm.P = firm.P * (1 + rand() * model.params[:p_adj])

        # stocks are positive and prices are high -> decrease price
    elseif firm.stock > 0 && firm.P > model.agg.price
        firm.De = firm.Y_prev
        firm.P = firm.P * (1 - rand() * model.params[:p_adj])

        # stocks are positive and prices are low -> decrease supply
    elseif firm.stock > 0 && firm.P <= model.agg.price
        firm.De = firm.Y_prev - firm.stock * model.params[:q_adj]

    end

    if firm.De < model.params[:alpha]        # in order to hire at least one worker
        firm.De = model.params[:alpha]
    end

end



"""
    firm_decides_price_quantity!(firm::AbstractCapitalFirm, model::AbstractModel)

This function is used by a capital firm to decide its price and quantity based on its current stock level and the 
    aggregate price in the model. The function modifies the firm's expected demand (`firm.De_k`) 
    and price (`firm.P_k`) accordingly.

# Arguments
- `firm::AbstractCapitalFirm`: The capital firm that takes the price and quantity decisions.
- `model::AbstractModel`: The model containing the aggregate price and other parameters.

"""
function firm_decides_price_quantity!(firm::AbstractCapitalFirm, model::AbstractModel)

    #capital good is durable, and inventories depreciates
    firm.inventory_k = (1 - model.params[:inventory_depreciation]) * firm.Y_k

    firm.stock_k = firm.Y_prev_k - firm.Y_kd # virtual variation of inventories

    if firm.stock_k <= 0 && firm.P_k >= model.agg.price_k

        # De is firm's expected demand
        firm.De_k = (firm.Y_prev_k + (-firm.stock_k) * model.params[:q_adj]) - firm.inventory_k

    elseif firm.stock_k <= 0 && firm.P_k < model.agg.price_k
        firm.De_k = firm.Y_prev_k
        firm.P_k = firm.P_k * (1 + rand() * model.params[:p_adj])

    elseif firm.stock_k > 0 && firm.P_k > model.agg.price_k
        firm.De_k = firm.Y_prev_k
        firm.P_k = firm.P_k * (1 - rand() * model.params[:p_adj])

    elseif firm.stock_k > 0 && firm.P_k <= model.agg.price_k
        firm.De_k = (firm.Y_prev_k - firm.stock_k * model.params[:q_adj]) - firm.inventory_k

    end

    if firm.De_k < model.params[:alpha]        # in order to hire at least one worker
        firm.De_k = model.params[:alpha]
    end

end



"""
    firms_decide_price_quantity!(firms, model)

Iterates over a collection of firms and calls the `firm_decides_price_quantity!` function for each firm.

# Arguments
- `firms`: A vector of consumption or capital firms.
- `model`: An abstract model object.

"""
function firms_decide_price_quantity!(
    firms::Union{Vector{<:AbstractConsumptionFirm}, Vector{<:AbstractCapitalFirm}},
    model::AbstractModel,
)
    for firm in firms
        firm_decides_price_quantity!(firm, model)
    end
end
