# RPL_plot
[Rocket Pool](https://medium.com/rocket-pool) is an Ethereum staking platform that lets you run a validator and earn rewards with a stake of 16ETH as opposed to the normally required 32ETH. Rocket Pool requires that along with your 16ETH you deposit a minimum of 10% of that value (to a max of 150%)  in RPL, the Rocket Pool protocol token. You then earn rewards on that RPL, along with the normal ETH staking rewards.

This is an R Shiny [application](https://tommw.shinyapps.io/RPL_apy/) that plots the Annual Percentage Yield (APY) for RPL staked within Rocket Pool ETH Staking nodes. Calculations are based on the spreadsheet in the RPL [tokenomics announcement](https://medium.com/rocket-pool/rocket-pool-staking-protocol-part-3-3029afb57d4c). 

Assumptions are an annual inflation rate of 5%, with 70% of annual emission going to node operators. There are transaction costs involved
in processing the smart contract which allocates the RPL rewards. The cost is around 500K in gas for each transaction. Currently transactions 
are planned for every four weeks, so 13 per year.                
                
## Calculations



### for all nodes:

RPL in circulation = 18 000 000  
Inflation rate = 5.0%    
Annual Emission = 18 000 000 * Inflation_rate / 100.0  
Node operator allocation = 70%             
Total RPL available for node operators = Annual Emission * Node operator allocation = 630 000 RPL 

Value of ETH  in each node = 16 * minipools per node * ETH price  
RPL required per node =  (average Rocketpool node deposit percentage) * (Value of ETH  in each node  / RPL price)  
Total RPL deposited = RPL required per node * number of nodes  
  
Cost of RPL transactions.  13/year (every 4 weeks) at 500K gas each :  

Transaction costs in ETH = 13 * 500000 * number of nodes * (gas price / 1e9)   
Transaction costs in RPL =  Transaction costs in eth * (ETH value / RPL value)  


 APY = ((Total RPL deposited - Transaction costs in RPL) / Total_RPL_deposited)* 100.0  
 
 These calculations appear to give the same results as the tokenomics spreadsheet but any checking would be appreciated.
  
### for an individual  node:

My node rpl deposited = RPL required per node / minipools per node      #at my nodes collateralisation ratio 
My node rpl earned =  (My node rpl deposited / Total RPL deposited) * (Total RPL deposited - Transaction costs in RPL)  
My APY = (My_node_rpl_earned/ My_node_rpl_deposited) * 100



## The code to do list


- Improve presentation of numbers, put them in separte table, better format.
- use reactive() where helpful
- clean up variable names
- plot is stepped at finer resolutions
- limit Total RPL deposited to Total RPL in circulation

