"""
    main_st_in_out.jl

The purpuse of this module is to allow to run the model from command line.
The input parameters are passed in an ordered sequence, while the output
time series are saved to a CSV file.
"""

using ABCredit


W, F, N = [parse(Int64, ARGS[i]) for i in 1:3]   # number of different agent tipes
zs = [parse(Int64, ARGS[i]) for i in 4:6]        # networks' connectivities
floats = [parse(Float64, ARGS[i]) for i in 7:31] # all other parameters (see below)

T = parse(Int64, ARGS[32])     # number of time steps for the simulation
seed = parse(Int64, ARGS[33])  # random seed for the simulation

# define the model parameters
params = Dict(
    :z_c => zs[1],                             #no. of aplications in consumption good market
    :z_k => zs[2],                             #no. of aplications in capiatal good market
    :z_e => zs[3],                             #number of job applications
    :xi => floats[1],                          #memory parameter human wealth
    :chi => floats[2],                         #fraction of wealth devoted to consumption
    :q_adj => floats[3],                       #quantity adjustment parameter
    :p_adj => floats[4],                       #price adjustment parameter
    :mu => floats[5],                          #bank's gross mark-up
    :eta => floats[6],                         #capital depreciation
    :Iprob => floats[7],                       #probability of investing
    :phi => floats[8],                         #bank's leverage parameter
    :theta => floats[9],                       #rate of debt reimbursment
    :delta => floats[10],                      #memory parameter in the capital utilization rate
    :alpha => floats[11],                      #labour productivity
    :k => floats[12],                          #capital productivity
    :div => floats[13],                        #share of dividends
    :barX => floats[14],                       #desired capital utilization
    :inventory_depreciation => floats[15],     #rate at which capital firms' inventories depreciate
    :b1 => floats[16],                         #Parameters for risk evaluation by banks
    :b2 => floats[17],
    :b_k1 => floats[18],
    :b_k2 => floats[19],
    :interest_rate => floats[20],              #interest rate
    :subsidy => floats[21],                    #government subsidy as fraction of wages
    :tax_rate => floats[22],                   #tax rate

    #phillips curve
    :wage_update_up => floats[23],
    :wage_update_down => floats[24],
    :u_target => floats[25],

    #hard coded parameters
    :wb => 1.0,                #initial wage rate
    :tax_rate_d => 0.00,      #taxes on dividends (set to zero)
    :r_f => 0.01,           #general refinancing rate
)

# initialise the model
model = ABCredit.initialise_model(W, F, N; params)

# initialise data collector
d = ABCredit.run_one_sim!(model, T; seed)

ABCredit.save_csv(d, "simulation_data.csv")
