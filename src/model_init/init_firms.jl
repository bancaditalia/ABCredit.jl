
export initialise_model


"""
    initialise_firms(params)

Initializes the capital firms and consumption firms based on the given parameters.

# Arguments
- `params`: A dictionary containing the initialization parameters.

# Returns
- `capital_firms`: An array of `FirmCapital` objects representing the initialized capital firms.
- `consumption_firms`: An array of `FirmProduction` objects representing the initialized consumption firms.
"""
function initialise_firms(params)
    P = params[:init_price]

    ### INITIALISE CAPITAL FIRMS ###
    Leff_k = 0
    Y_k = 0.0
    Y_prev_k = 3.0
    Y_kd = Y_prev_k
    P_k = params[:init_price_k]
    A_k = 10.0
    liquidity_k = A_k
    De_k = 1
    deb_k = 0
    Q_k = 0.0
    Ftot_k = 0.0
    interest_r_k = 0.0
    interests_k = 0.0
    Ld_k = 0
    B_k = 0.0
    lev_k = 0.0
    vacancies_k = 0
    inventory_k = 0
    wages_k = 0.0
    stock_k = 0.0
    ############
    income = 0.0
    PA = 2.0
    cons_budget = 0.0
    permanent_income = 1.0 / P

    capital_firms = Vector{FirmCapital}()
    firm_id = 1
    for n in 1:params[:N]
        agent = FirmCapital(
            firm_id,
            Leff_k,
            Y_k,
            Y_prev_k,
            Y_kd,
            P_k,
            A_k,
            liquidity_k,
            De_k,
            deb_k,
            Q_k,
            Ftot_k,
            interest_r_k,
            interests_k,
            Ld_k,
            B_k,
            lev_k,
            vacancies_k,
            inventory_k,
            wages_k,
            stock_k,
            ########
            income,
            PA,
            cons_budget,
            permanent_income,
        )

        push!(capital_firms, agent)
        firm_id += 1
    end

    price_k = P_k

    ### INITIALISE consumption firms ###
    value_investments = 0.0
    investment = 0.0
    K = params[:init_K]
    A = 10.0 + K * price_k
    liquidity = A - K * price_k
    capital_value = K * price_k
    P = P
    Y_prev = 5.0
    Yd = Y_prev
    Q = 0.0
    Leff = 0
    De = 1
    deb = 0
    barK = K          # time average of K
    barYK = Y_prev / params[:k]
    x = barYK / barK
    interest_r = 0.0
    interests = 0.0
    Ftot = 0.0
    K_dem = 0.0
    K_des = 0.0
    Ld = 0
    B = 0.0
    lev = 0.0
    vacancies = 0
    Y = 0.0
    wages = 0.0
    stock = 0.0
    ############
    income = 0.0
    PA = 2.0
    cons_budget = 0.0
    permanent_income = 1.0 / P

    consumption_firms = Vector{FirmProduction}()

    for n in 1:params[:F]
        agent = FirmProduction(
            firm_id,
            value_investments,
            investment,
            K,
            A,
            liquidity,
            capital_value,
            P,
            Y_prev,
            Yd,
            Q,
            Leff,
            De,
            deb,
            barK,
            barYK,
            x,
            interest_r,
            interests,
            Ftot,
            K_dem,
            K_des,
            Ld,
            B,
            lev,
            vacancies,
            Y,
            wages,
            stock,
            ########
            income,
            PA,
            cons_budget,
            permanent_income,
        )

        push!(consumption_firms, agent)
        firm_id += 1

    end

    return capital_firms, consumption_firms

end
