library(shiny)
library(shinyWidgets)

shinyUI(fluidPage(
  setBackgroundColor(
    color = c("#FDA172","#BE5504"),
    gradient = "linear",
    direction = "bottom"
  ),
  

        titlePanel("RPL Yield for Node Operators"),

        sidebarLayout(position = "left",

                sidebarPanel(
                        sliderInput("eth_value",
                                    "ETH value ($)",
                                    min = 1,
                                    max = 20000,
                                    value = 2500,
                                    step = 5),

                        sliderInput("rpl_value",
                                    "RPL value ($)",
                                    min = 1,
                                    max = 1000,
                                    value = 20,
                                    step = 1),
                        
                        sliderInput("Node_ops",
                                    "Number of nodes",
                                    min = 0.0,
                                    max = 20000,
                                    value = 3000,
                                    step = 100),
                        
                        sliderInput("mini_per_node",
                                    "Average number of minipools per node",
                                    min = 1,
                                    max = 10,
                                    value = 1,
                                    step = 1),
                        
                        sliderInput("network_avg_coll",
                                    "Average node collaterlisation for Rocketpool",
                                    min = 10,
                                    max = 150,
                                    value = 30,
                                    step = 1),
                        
                        sliderInput("my_node_coll",
                                    "My Node  collaterallisation ratio",
                                    min = 10,
                                    max = 150,
                                    value = 20,
                                    step = 1),
                        
                       
                        sliderInput("gwei",
                                    "Gas price (gwei)",
                                    min = 0,
                                    max = 1000,
                                    value = 100,
                                    step = 1),
                        
                        sliderInput("Max_X_axis", 
                                   "Change X Axis scale", 
                                   min = 10,
                                   max = 150, 
                                   value = c(10, 50),
                                   step = 1)

                        ),

                mainPanel(p('Plot shows the Annual Percentage Yield (APY) for RPL
                staked within Rocket Pool Nodes. Calculations based
                on spreadsheet in RPL tokenomics announcement. Assumptions 
                are an annual inflation rate of 5%, with 70% of annual
                emission going to node operators. There are transaction costs involved
                in processing the smart contract which allocates the RPL rewards. 
                  The cost is around 500 000 in gas each transaction. 
                  Currently transactions are planned for every four weeks, so 13 
                  per year'),
                p('Rocket Pool requires you to deposit 16ETH in your minipool along
                with a minimum of 10% of that value (to a max of 150%)  in RPL.
                You then earn rewards on that RPL along with the ETH staking 
                rewards. Adjust the parameters on the left to find out how 
                many RPL your node will earn each year.'),
                p('This is not an official Rocket Pool tool.  Use at your own risk.
                  Code and underlying calculations available at GITXXXXXXXX'),
                
                plotOutput("RPLPlot")
                                                     
                )
        )
))
