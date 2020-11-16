#install.packages("devtools")
#devtools::install_github("robson-fernandes/bnviewer")

library(bnlearn)
library(bnviewer)

# Load the BN from bif file
nh <- read.net("/Users/lorenzotabasso/Desktop/University/IALAB/Progetto/IALab/src/uncertainty/networks/earthquake.bif")

# Converting "network_handler" (a list of objects) to a "bn" object
n <- bn.net(nh)

# Pretty print the network
# TODO: change the descriptions and comment for each network
bnviewer::viewer(n,
       bayesianNetwork.width = "100%",
       bayesianNetwork.height = "80vh",
       bayesianNetwork.layout = "layout_with_sugiyama",
       bayesianNetwork.title="Discrete Bayesian Network - Alarm",
       bayesianNetwork.subtitle = "Monitoring of emergency care patients",
       bayesianNetwork.footer = "Fig. 1 - Layout with Sugiyama",
       
       node.colors = list(background = "#f4bafd",
                          border = "#2b7ce9",
                          highlight = list(background = "#97c2fc",
                                           border = "#2b7ce9"))
)


