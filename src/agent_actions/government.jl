
"""
The interest rate on government bonds is set
"""
function set_bond_interest_rate!(gov::AbstractGovernment, model::AbstractModel)
    gov.bond_interest_rate = model.params[:interest_rate]
end


"""
    gov_accounting!(gov::AbstractGovernment, model::AbstractModel)

Update the government's accounting by adjusting the government balance, stock of bonds, and deficit to GDP ratio.

# Arguments
- `gov::AbstractGovernment`: The government object.
- `model::AbstractModel`: The model object.

"""
function gov_accounting!(gov::AbstractGovernment, model::AbstractModel)

    gov.GB -= gov.bond_interest_rate * gov.bonds # - model.EXP # public expenditure to corporate sector is zero now
    gov.stock_bonds = model.gov.stock_bonds - gov.GB
    model.bank.loans += min(0, gov.GB) # add new loans
    gov.bonds = max(0, model.gov.stock_bonds)


    gov.deficitGDP = -gov.GB / model.agg.Y_nominal_tot

end


"""
    gov_adjusts_subsidy!(gov::AbstractGovernment, model::AbstractModel)

Adjusts the subsidy amount based on the predicted deficit and the target deficit.

# Arguments
- `gov::AbstractGovernment`: The government object.
- `model::AbstractModel`: The model object.

"""
function gov_adjusts_subsidy!(gov::AbstractGovernment, model::AbstractModel)
    if model.params[:maastricht] == true
        workers = model.workers
        num_unemployed = sum([worker.Oc == 0 for worker in workers])
        predicted_deficit =
            -(gov.TA - gov.subsidy * model.agg.wb * num_unemployed - gov.bond_interest_rate * gov.bonds) /
            model.agg.Y_nominal_tot  # - EXP(t)
        if predicted_deficit > model.params[:target_deficit]

            gov.subsidy =
                (
                    gov.TA + model.params[:target_deficit] * model.agg.Y_nominal_tot -
                    gov.bond_interest_rate * gov.bonds
                ) / (num_unemployed * model.agg.wb) # -EXP(t)
            gov.subsidy = max(0, gov.subsidy)
        else
            gov.subsidy = model.params[:subsidy]
        end
    end
end
