
"""
    firm_gets_credit!(firm::AbstractConsumptionFirm, model::AbstractModel)

A consumption firms asks credit from a bank based on its financial gap and other parameters. 
The bank evaluates the firm's bankruptcy probability and expected survival, and gives a maximum loan based on the maximum expected loss. 
The firm's debt stock, the bank's credit stock, and the firm's liquidity are updated. 

# Arguments
- `firm::AbstractConsumptionFirm`: The firm for which credit is being calculated.
- `model::AbstractModel`: The model containing the parameters and information needed for the credit calculation.

"""
function firm_gets_credit!(firm::AbstractConsumptionFirm, model::AbstractModel)
    firm.Ftot = 0
    # compute financial gap
    firm.B = firm.wages + firm.K_dem * model.agg.price_k - firm.liquidity

    if firm.B < 0
        firm.B = 0
    end

    #for each firm the bank computes the maximum loan and gives loans up to the maximum amount
    if firm.B > 0
        firm.lev = (firm.deb + firm.B) / (firm.A + firm.B + firm.deb) #leverage

        #evaluate bankruptcy probability and expected survival
        pr = _compute_bankruptcy_probability(firm.lev, model.params[:b1], model.params[:b2])

        #proposed rate depends on the estimated bankruptcy probability
        proposed_rate = _compute_proposed_rate(pr, model.params[:mu], model.params[:theta], model.params[:interest_rate])

        #the bank gives a maximum credit depending on  maximum expected loss
        maxL = _compute_max_loan(firm.deb, model.params[:phi], model.bank.E, model.bank.E_threshold, pr)

        credit = min(firm.B, maxL) #credit given to firm i
        deb_0 = firm.deb
        firm.deb += credit       #update firm's debt stock

        model.bank.loans += credit    #update bank's credit stock
        firm.Ftot = credit       #record flow of new credit for firm i
        firm.liquidity += credit

        #compute new average interest rate
        if firm.deb > 0
            firm.interest_r = (deb_0 * firm.interest_r + proposed_rate * credit) / firm.deb
        end
    end
end


"""
    firm_gets_credit!(firm::AbstractCapitalFirm, model::AbstractModel)

A capital firms asks credit from a bank based on its financial gap and other parameters. 
The bank evaluates the firm's bankruptcy probability and expected survival, and gives a maximum loan based on the maximum expected loss. 
The firm's debt stock, the bank's credit stock, and the firm's liquidity are updated. 

# Arguments
- `firm::AbstractCapitalFirm`: The firm for which credit is being calculated.
- `model::AbstractModel`: The model containing the parameters and information needed for the credit calculation.

"""
function firm_gets_credit!(firm::AbstractCapitalFirm, model::AbstractModel)
    firm.Ftot_k = 0
    firm.B_k = firm.wages_k - firm.liquidity_k

    if firm.B_k < 0
        firm.B_k = 0
    end

    #for each firm the bank computes the maximum loan and gives loans up to the maximum amount
    if firm.B_k > 0

        firm.lev_k = (firm.deb_k + firm.B_k) / (firm.A_k + firm.B_k + firm.deb_k)   #leverage

        pr_k = _compute_bankruptcy_probability(firm.lev_k, model.params[:b_k1], model.params[:b_k2])

        proposed_rate_k =
            _compute_proposed_rate(pr_k, model.params[:mu], model.params[:theta], model.params[:interest_rate])

        maxL = _compute_max_loan(firm.deb_k, model.params[:phi], model.bank.E, model.bank.E_threshold, pr_k)

        credit = min(firm.B_k, maxL)

        deb_0 = firm.deb_k
        firm.deb_k += credit         #update firm's debt stock
        model.bank.loans += credit  #update bank's credit stock
        firm.Ftot_k = credit              #record flow of new credit for firm i
        firm.liquidity_k += credit

        if firm.deb_k > 0
            firm.interest_r_k = (deb_0 * firm.interest_r_k + proposed_rate_k * credit) / firm.deb_k
        end
    end
end



"""
    firms_get_credit!(firms, model)

Iterates over a collection of firms, and each firm gets credit from the bank based.

# Arguments
- `firms`: A vector of consumption firms or capital firms.
- `model`: An abstract model.

"""
function firms_get_credit!(
    firms::Union{Vector{<:AbstractConsumptionFirm}, Vector{<:AbstractCapitalFirm}},
    model::AbstractModel,
)
    for firm in firms
        firm_gets_credit!(firm, model)
    end
end


function _compute_max_loan(deb, phi, E, E_threshold, pr)
    E_effective = max(E_threshold, E) # use an effective E never less than E_threshold
    maxL = (phi * E_effective - pr * deb) / pr
    maxL = max(0, maxL) #maxL never negative
    if isnan(maxL)
        return Inf
    else
        return maxL
    end
end


function _compute_bankruptcy_probability(leverage, b1, b2)
    # banks evaluate bankruptcy probability of each firm
    pr = exp(b1 + b2 * leverage) / (1.0 + exp(b1 + b2 * leverage))
    return pr
end

function _compute_proposed_rate(pr, mu, theta, interest_rate)
    Xi = (1.0 - (1.0 - theta)^(1.0 + 1.0 / pr)) / (1.0 - (1.0 - theta))
    proposed_rate = mu * ((1 + interest_rate / theta) / Xi - theta)
    return proposed_rate
end
