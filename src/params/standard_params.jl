
dir = @__DIR__

original = readdlm(joinpath(dir, "parameters_original_value.csv"), '\n', Float64)
to_be = readdlm(joinpath(dir, "parameters_to_be_estimated.csv"), ',', Int)'
estimated = readdlm(joinpath(dir, "estimated_parameters.csv"), ',', Float64)'

par = original

# define the model parameters
const PARAMS_ORIGINAL = Dict(
    :z_c => Int(par[1]),                    #no. of aplications in consumption good market
    :z_k => Int(par[2]),                    #no. of aplications in capiatal good market
    :z_e => Int(par[3]),                    #number of job applications
    :xi => par[4],                          #memory parameter human wealth
    :chi => par[5],                         #fraction of wealth devoted to consumption
    :q_adj => par[6],                       #quantity adjustment parameter
    :p_adj => par[7],                       #price adjustment parameter
    :mu => par[8],                          #bank's gross mark-up
    :eta => par[9],                         #capital depreciation
    :Iprob => par[10],                      #probability of investing
    :phi => par[11],                        #bank's leverage parameter
    :theta => par[12],                      #rate of debt reimbursment
    :delta => par[13],                      #memory parameter in the capital utilization rate
    :alpha => par[14],                      #labour productivity
    :k => par[15],                          #capital productivity
    :div => par[16],                        #share of dividends
    :barX => par[17],                       #desired capital utilization
    :inventory_depreciation => par[18],     #rate at which capital firms' inventories depreciate
    :b1 => par[19],                         #Parameters for risk evaluation by banks
    :b2 => par[20],
    :b_k1 => par[21],
    :b_k2 => par[22],
    :interest_rate => par[23],
    :subsidy => par[24],
    :maastricht => par[25],
    :target_deficit => par[26],
    :tax_rate => par[27],

    #phillips curve
    :wage_update_up => par[28],
    :wage_update_down => par[29],
    :u_target => par[30],

    #hard coded parameters
    :wb => 1.0,                #initial wage rate
    :tax_rate_d => 0.00,      #taxes on dividends (set to zero)
    :r_f => 0.01,           #general refinancing rate
)

par[to_be] = estimated

const PARAMS_GRAZZINI = Dict(
    :z_c => Int(par[1]),                    #no. of aplications in consumption good market
    :z_k => Int(par[2]),                    #no. of aplications in capiatal good market
    :z_e => Int(par[3]),                    #number of job applications
    :xi => par[4],                          #memory parameter human wealth
    :chi => par[5],                         #fraction of wealth devoted to consumption
    :q_adj => par[6],                       #quantity adjustment parameter
    :p_adj => par[7],                       #price adjustment parameter
    :mu => par[8],                          #bank's gross mark-up
    :eta => par[9],                         #capital depreciation
    :Iprob => par[10],                      #probability of investing
    :phi => par[11],                        #bank's leverage parameter
    :theta => par[12],                      #rate of debt reimbursment
    :delta => par[13],                      #memory parameter in the capital utilization rate
    :alpha => par[14],                      #labour productivity
    :k => par[15],                          #capital productivity
    :div => par[16],                        #share of dividends
    :barX => par[17],                       #desired capital utilization
    :inventory_depreciation => par[18],     #rate at which capital firms' inventories depreciate
    :b1 => par[19],                         #Parameters for risk evaluation by banks
    :b2 => par[20],
    :b_k1 => par[21],
    :b_k2 => par[22],
    :interest_rate => par[23],
    :subsidy => par[24],
    :maastricht => par[25],
    :target_deficit => par[26],
    :tax_rate => par[27],

    #phillips curve
    :wage_update_up => par[28],
    :wage_update_down => par[29],
    :u_target => par[30],

    #hard coded parameters
    :wb => 1.0,                #initial wage rate
    :tax_rate_d => 0.00,      #taxes on dividends (set to zero)
    :r_f => 0.01,           #general refinancing rate
)



params = copy(PARAMS_ORIGINAL)

theta =
    [0.36, 0.069, 0.956, 0.764, 1.3769999999999587, 0.089, 0.016, 0.8160000000000003, 0.002, 0.044, 0.8810000000000003]

ordered_par_names = [:Iprob, :chi, :delta, :inventory_depreciation, :mu, :p_adj, :phi, :q_adj, :tax_rate, :theta, :xi]

for (i, name) in enumerate(ordered_par_names)
    params[name] = theta[i]
end

const PARAMS_RL = params

real_data = readdlm(joinpath(dir, "FRED_data.txt"), ' ', Float64, skipstart=1)

const REAL_DATA_EXAMPLE = real_data