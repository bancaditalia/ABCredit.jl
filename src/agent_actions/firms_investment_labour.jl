
"""
    firm_decide_investment!(firm::AbstractConsumptionFirm, model::AbstractModel)

This function is used by a consumption firm to decide its investment level based on certain parameters and conditions.

# Arguments
- `firm::AbstractConsumptionFirm`: The consumption firm for which the investment decision is being made.
- `model::AbstractModel`: The model containing the parameters and settings for the simulation.

# Description
- The function resets the investment expectations of the firm to zero.
- It then checks if the firm should invest based on a probability threshold.
- If the firm decides to invest, it calculates the desired investment level.
"""
function firm_decide_investment!(firm::AbstractConsumptionFirm, model::AbstractModel)

    # reset investment expectations to zero
    firm.K_dem = 0.0
    firm.K_des = 0.0

    # only invest a fraction of the times
    if rand() < model.params[:Iprob]

        firm.K_des = firm.barYK / model.params[:barX] # equation 5.7 in Assenza et al.

        depreciation = model.params[:barX] * firm.K_des * model.params[:eta] * 1.0 / model.params[:Iprob]

        firm.K_dem = firm.K_des - firm.K + depreciation

        if firm.K_dem < 0
            firm.K_dem = 0.0
        end
    end
end


"""
    firm_decide_labour!(firm::AbstractConsumptionFirm, model::AbstractModel)

This function calculates the firm's desired level of labor and sets the wages accordingly.

# Arguments
- `firm::AbstractConsumptionFirm`: The consumption firm for which labor is being decided.
- `model::AbstractModel`: The model containing the parameters and aggregate variables.

# Description
The function calculates the desired level of labor (`Ld`) for the firm based on the production needs (`De`) and 
    the capital stock (`K`) using the parameters `alpha` and `k`. The labor demand is approximated by taking the 
    minimum between the actual production needs and the employable workers given the capital.

"""
function firm_decide_labour!(firm::AbstractConsumptionFirm, model::AbstractModel)
    firm.Ld = min(ceil(firm.De / model.params[:alpha]), ceil(firm.K * model.params[:k] / model.params[:alpha]))
    firm.wages = model.agg.wb * firm.Ld
end


"""
    firm_decide_labour!(firm::AbstractCapitalFirm, model::AbstractModel)

This function calculates the firm's desired level of labor and sets the wages accordingly.

# Arguments
- `firm::AbstractCapitalFirm`: The consumption firm for which labor is being decided.
- `model::AbstractModel`: The model containing the parameters and aggregate variables.

# Description
The function calculates the desired level of labor (`Ld_k`) for the firm based on the production needs (`De`) using 
    the parameters `alpha`.
"""
function firm_decide_labour!(firm::AbstractCapitalFirm, model::AbstractModel)
    firm.Ld_k = ceil(firm.De_k / model.params[:alpha])
    firm.wages_k = model.agg.wb * firm.Ld_k
end



"""
    firms_decide_investment!(firms::Vector{<:AbstractConsumptionFirm}, model::AbstractModel)

Iterates over a vector of consumption firms and calls `firm_decide_investment!` function for each firm.

# Arguments
- `firms`: A vector of consumption firms.
- `model`: An abstract model.
"""
function firms_decide_investment!(firms::Vector{<:AbstractConsumptionFirm}, model::AbstractModel)
    for firm in firms
        firm_decide_investment!(firm, model)
    end
end



"""
    firms_decide_labour!(firms, model)

Iterates over a collection of firms and calls the `firm_decide_labour!` function for each firm.

# Arguments
- `firms`: A vector of `AbstractConsumptionFirm` or `AbstractCapitalFirm` objects.
- `model`: An `AbstractModel` object.
"""
function firms_decide_labour!(
    firms::Union{Vector{<:AbstractConsumptionFirm}, Vector{<:AbstractCapitalFirm}},
    model::AbstractModel,
)
    for firm in firms
        firm_decide_labour!(firm, model)
    end
end
