"""
    bank_accounting!(bank::AbstractBank, model::AbstractModel)

Update the accounting records of a bank based on the current state of the economy.

# Arguments
- `bank::AbstractBank`: The bank object whose accounting records need to be updated.
- `model::AbstractModel`: The model object representing the current state of the economy.

# Description
This function updates the profits, dividends, and equity of a bank based on the current state of the economy. 
    It calculates the profits from government loans, pays dividends to shareholders, and distributes the dividends 
    to the income and assets of the firms owners.

"""
function bank_accounting!(bank::AbstractBank, model::AbstractModel)

    cons_firms = model.consumption_firms
    cap_firms = model.capital_firms

    # update profits from government loans
    # bank.profitsB += model.gov.bond_interest_rate * model.gov.bonds

    #pay dividends
    div_B = 0.3
    if bank.profitsB > 0 && bank.E > 0
        bank.dividendsB = div_B * bank.profitsB
        bank.profitsB = (1 - div_B) * bank.profitsB

        #add bank's dividends to income and PA of capitalists
        div_paid = bank.dividendsB / (model.params[:F] + model.params[:N])

        for firm in cons_firms
            firm.PA += div_paid
            firm.income += div_paid
        end

        for firm in cap_firms
            firm.PA += div_paid
            firm.income += div_paid
        end
    else
        bank.dividendsB = 0
    end

    bank.E = bank.E - bank.dividendsB
end
