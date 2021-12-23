library(ggplot2)
library(ggpmisc)
library(shiny)

# create sequence for x-axis values.  

intervals <- 0.1
RPL_Coll_ratio <- seq(0,150.0, intervals) # Max RPL node collateralisation 
                                          # ratio is 150
no_of_intervals = 150/intervals + 1

# set RPL protocol values
Tot_supply <- 18000000.0
Inflation_rate <- 5.0
Annual_Emission <- Tot_supply * Inflation_rate / 100.0
Node_operator_allocation <- 0.7           # 70% of annual emission to node operators
Tot_RPL_for_node_ops <- Annual_Emission * Node_operator_allocation

# create dataframe to store and display values
RPL_data <- data.frame(RPL_Coll_ratio)

# function to calculate Annual Percentage Yield
# inputs:
# RPL_Coll_ratio = Average collateralisation ratio for all Rocket Pool nodes
# Node_ops = no. of nodes
# gwei = gas price
# mini_per_node = average no. of minipools per node 

apy <- function(eth_value, rpl_value, RPL_Coll_ratio, Node_ops, 
                     gwei, mini_per_node){
  
  
  node_amount_eth  <- 16 * mini_per_node * eth_value 
  node_amount_rpl  <- (RPL_Coll_ratio /100.0) * (node_amount_eth / rpl_value)
  Total_RPL_coll <- node_amount_rpl * Node_ops 
  # Cost of RPL transactions.  13/year (every 4 weeks) at 500K gas each
  Transaction_costs_in_eth <- 13 * 500000 * Node_ops * (gwei/1e9) 
  Transaction_costs_in_rpl <- Transaction_costs_in_eth * (eth_value / rpl_value)
  APY <- (((Tot_RPL_for_node_ops - Transaction_costs_in_rpl) / Total_RPL_coll)* 100.0)
  return(c(APY, node_amount_rpl, Total_RPL_coll, rep(Transaction_costs_in_rpl,no_of_intervals)))
}

#  Shiny function --------------------------------------------------------------------------

shinyServer(function(input, output) {

 
  output$RPLPlot <- renderPlot({
    
    # run apy function

    data_1 <- apy(input$eth_value, input$rpl_value, RPL_Coll_ratio, input$Node_ops,
                             input$gwei, input$mini_per_node)

    #populate dataframe with results from function
    
    RPL_data$APY <- round(data_1[1:no_of_intervals],1)
    RPL_data$RPL_per_node_required <- round(data_1[(no_of_intervals + 1):(2 * no_of_intervals)],2)
    RPL_data$Total_RPL_Collateralised <- round(data_1[((2 * no_of_intervals) +1):(3* no_of_intervals)],2)
    RPL_data$Tot_Transaction_costs <- round(data_1[((3 * no_of_intervals) +1):(4* no_of_intervals)],2)
    RPL_data$Total_RPL_for_distribution <- round(Tot_RPL_for_node_ops - RPL_data$Tot_Transaction_costs,2)

    
    # compute my node's APY based on network average collateralisation ratio
    # and my nodes collateralisation ratio
    
    Tot_coll <- RPL_data$Total_RPL_Collateralised[RPL_data$RPL_Coll_ratio == input$network_avg_coll]
    My_node_rpl_deposited <- round(RPL_data$RPL_per_node_required[RPL_data$RPL_Coll_ratio == input$my_node_coll] /input$mini_per_node)
    My_node_rpl_earned <- round((My_node_rpl_deposited / Tot_coll) * (RPL_data$Total_RPL_for_distribution[1]),1)
    My_APY <- round(100.0 * My_node_rpl_earned/ My_node_rpl_deposited, 1)
   
    # create second dataframe with individual node data to display on plot
    My_nodes_coll_ratio <- input$my_node_coll
    my_node_data <- data.frame(My_nodes_coll_ratio, My_node_rpl_deposited, My_node_rpl_earned, My_APY)
    #my_node_data <- format(list(my_node_data), big.mark = ",")
    
    # convert negative returns to zero if transaction costs exceed RPL for distribution
    if( RPL_data$Tot_Transaction_costs > Tot_RPL_for_node_ops){RPL_data$APY <- 0}
    if(RPL_data$Tot_Transaction_costs > Tot_RPL_for_node_ops){my_node_data$My_APY <- 0}
    if(RPL_data$Tot_Transaction_costs > Tot_RPL_for_node_ops){my_node_data$My_node_rpl_earned <- 0}

    # set limits for y-axis
    high <-  RPL_data$APY[RPL_data$RPL_Coll_ratio == input$Max_X_axis[1]]
    if(RPL_data$APY == 0){high  <- 0.05}
    low <-  RPL_data$APY[RPL_data$RPL_Coll_ratio == input$Max_X_axis[2]]

    
    
    (p <- ggplot(RPL_data, aes(RPL_Coll_ratio, APY)) + geom_line()
      + ## start of plot commands
        ylab('APY (%)') +
        xlab('Average Node RPL Collateralisation Ratio (%)') +
        ylim(low, high ) +
        scale_x_continuous(limits = c(input$Max_X_axis[1], input$Max_X_axis[2]))+
        theme_bw() +
        theme(axis.text.x  = element_text( size=14)) +
        theme(axis.text.y  = element_text( size=14)) +
        theme(panel.grid.minor = element_line(colour="white", size=0.3)) +
        annotate(geom = "table", x = c(input$Max_X_axis[2],input$Max_X_axis[2]), y = c(high,low + 0.9*(high-low)),
                 label = c(list(data.frame(lapply(RPL_data[RPL_data$RPL_Coll_ratio == input$network_avg_coll,],function(x){format(x, big.mark = ",", scientific = F)}))),
                           list(data.frame(lapply(my_node_data, function(x){format(x, big.mark = ",") })))), size = 4.5)
    )
  })
})
