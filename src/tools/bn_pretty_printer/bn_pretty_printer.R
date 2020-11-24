# BN Pretty Printer
#
# A simple R script that pretty prints a BN in a customizable way.
# To check out more, see bnlearn and bnviewer documentation (the second one is recomended).
# bnleanr: https://www.bnlearn.com/
# bnviewer: http://robsonfernandes.net/bnviewer/ (mirror 1)
# bnviewer: https://github.com/robson-fernandes/bnviewer (mirror 2)

# First, install the required packages
#install.packages("bnlearn")
#install.packages("devtools")
#devtools::install_github("robson-fernandes/bnviewer")

# Load the packages
library(bnlearn)
library(bnviewer)

# Load the BN from .net file
nh <- read.net("/Users/lorenzotabasso/Desktop/University/IALAB/Progetto/IALab/src/uncertainty/networks/earthquake.bif")

# You can also read the BN from the ".bif" format, but we encourage you to use ".net" format.
#nh <- read.bif(path to BN)

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


