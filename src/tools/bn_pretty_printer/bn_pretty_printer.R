#install.packages("devtools")
#devtools::install_github("robson-fernandes/bnviewer")

library(bnlearn)
library(bnviewer)

# Setting the working directory to the folder which contains the script
setwd("/Users/lorenzotabasso/Desktop/University/IALAB/Progetto/IALab/src/uncertainty/networks/bif/")
cat("working directory set to:", getwd())


# EARTHQUAKE  -----------------------------------------------------------------

# Load the BN from bif file
network_handler <- read.bif("earthquake.bif")
cat("network in use:", n)
    
# Alternatives using .net, .rda, .rds files: 
# https://www.bnlearn.com/documentation/man/foreign.html
    
# Converting "network_handler" (a list of objects) to a "bn" object
network <- bn.net(network_handler)
    
# Pretty print the network
viewer(network,
    bayesianNetwork.width = "100%",
    bayesianNetwork.height = "500px",
    bayesianNetwork.layout = "layout_with_sugiyama",
    bayesianNetwork.title="Static Bayesian Network - Earthquake",
    )

# ASIA ------------------------------------------------------------------------
network_handler <- read.bif("asia.bif")
cat("network in use:", n)

network <- bn.net(network_handler)

viewer(network,
       bayesianNetwork.width = "100%",
       bayesianNetwork.height = "500px",
       bayesianNetwork.layout = "layout_with_sugiyama",
       bayesianNetwork.title="Static Bayesian Network - Asia",
)

# SACHS -----------------------------------------------------------------------
network_handler <- read.bif("sachs.bif")
cat("network in use:", n)

network <- bn.net(network_handler)

viewer(network,
       bayesianNetwork.width = "100%",
       bayesianNetwork.height = "500px",
       bayesianNetwork.layout = "layout_with_sugiyama",
       bayesianNetwork.title="Static Bayesian Network - Sachs",
)

# ALARM -----------------------------------------------------------------------
network_handler <- read.bif("alarm.bif")
cat("network in use:", n)

network <- bn.net(network_handler)

viewer(network,
       bayesianNetwork.width = "100%",
       bayesianNetwork.height = "500px",
       bayesianNetwork.layout = "layout_with_sugiyama",
       bayesianNetwork.title="Static Bayesian Network - Alarm",
)

# MILDEW ----------------------------------------------------------------------
network_handler <- read.bif("mildew.bif")
cat("network in use:", n)

network <- bn.net(network_handler)

viewer(network,
       bayesianNetwork.width = "100%",
       bayesianNetwork.height = "500px",
       bayesianNetwork.layout = "layout_with_sugiyama",
       bayesianNetwork.title="Static Bayesian Network - Mildew",
)

# WIN95PTS --------------------------------------------------------------------
network_handler <- read.bif("win95pts.bif")
cat("network in use:", n)

network <- bn.net(network_handler)

viewer(network,
       bayesianNetwork.width = "100%",
       bayesianNetwork.height = "500px",
       bayesianNetwork.layout = "layout_with_sugiyama",
       bayesianNetwork.title="Static Bayesian Network - Win95pts",
)

# INSURANCE -------------------------------------------------------------------
network_handler <- read.bif("insurance.bif")
cat("network in use:", n)

network <- bn.net(network_handler)

viewer(network,
       bayesianNetwork.width = "100%",
       bayesianNetwork.height = "500px",
       bayesianNetwork.layout = "layout_with_sugiyama",
       bayesianNetwork.title="Static Bayesian Network - Insurance",
)

# BARLEY ----------------------------------------------------------------------
network_handler <- read.bif("barley.bif")
cat("network in use:", n)

network <- bn.net(network_handler)

viewer(network,
       bayesianNetwork.width = "100%",
       bayesianNetwork.height = "500px",
       bayesianNetwork.layout = "layout_with_sugiyama",
       bayesianNetwork.title="Static Bayesian Network - Barley",
)

# WATER -----------------------------------------------------------------------
network_handler <- read.bif("water.bif")
cat("network in use:", n)

network <- bn.net(network_handler)

viewer(network,
       bayesianNetwork.width = "100%",
       bayesianNetwork.height = "500px",
       bayesianNetwork.layout = "layout_with_sugiyama",
       bayesianNetwork.title="Static Bayesian Network - Water",
)

# MUNIN -----------------------------------------------------------------------
network_handler <- read.bif("munin.bif")
cat("network in use:", n)

network <- bn.net(network_handler)

viewer(network,
       bayesianNetwork.width = "100%",
       bayesianNetwork.height = "500px",
       bayesianNetwork.layout = "layout_with_sugiyama",
       bayesianNetwork.title="Static Bayesian Network - Munin",
)

# PIGS ------------------------------------------------------------------------
network_handler <- read.bif("pigs.bif")
cat("network in use:", n)

network <- bn.net(network_handler)

viewer(network,
       bayesianNetwork.width = "100%",
       bayesianNetwork.height = "500px",
       bayesianNetwork.layout = "layout_with_sugiyama",
       bayesianNetwork.title="Static Bayesian Network - Pigs",
)

# ANDES -----------------------------------------------------------------------
network_handler <- read.bif("andes.bif")
cat("network in use:", n)

network <- bn.net(network_handler)

viewer(network,
       bayesianNetwork.width = "100%",
       bayesianNetwork.height = "500px",
       bayesianNetwork.layout = "layout_with_sugiyama",
       bayesianNetwork.title="Static Bayesian Network - Andes",
)

# LINK ------------------------------------------------------------------------
network_handler <- read.bif("link.bif")
cat("network in use:", n)

network <- bn.net(network_handler)

viewer(network,
       bayesianNetwork.width = "100%",
       bayesianNetwork.height = "500px",
       bayesianNetwork.layout = "layout_with_sugiyama",
       bayesianNetwork.title="Static Bayesian Network - Link",
)

