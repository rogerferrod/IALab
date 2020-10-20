install.packages("devtools")
devtools::install_github("robson-fernandes/bnviewer")

library(bnlearn)
library(bnviewer)

# Setting the working directory to the folder which contains the script
setwd("/Users/lorenzotabasso/Desktop/University/IALAB/Progetto/IALab/src/uncertainty/networks/bif/")
cat("working directory set to:", getwd())

networks <- c("asia")

for (n in networks) {
    # Load the BN from bif file
    network_handler <- read.bif(sprintf("%s.bif", n))
    cat("network in use:", n)
    
    # Alternatives using .net, .rda, .rds files: https://www.bnlearn.com/documentation/man/foreign.html
    
    # Converting "network_handler" (a list of objects) to a "bn" object
    network <- bn.net(network_handler)
    
    # Pretty print the network
    viewer(network,
           bayesianNetwork.width = "100%",
           bayesianNetwork.height = "80vh",
           bayesianNetwork.layout = "layout_with_sugiyama",
           bayesianNetwork.title="Discrete Bayesian Network - Alarm",
           bayesianNetwork.subtitle = "Monitoring of emergency care patients",
           bayesianNetwork.footer = "Fig. 1 - Layout with Sugiyama"
    )
}
