"""
Script used to determine the treewidth of a BN.
"""

__author__ = "Roger Ferrod, Pio Raffaele Fina, Lorenzo Tabasso"

import networkx as nx
from pgmpy.readwrite import BIFReader
from networkx.algorithms.approximation.treewidth import treewidth_min_degree,treewidth_min_fill_in
from pathlib import Path
import csv
import argparse
import numpy as np

NETWORK_FILE_EXTENSIONS = "bif"

def compute_treewidth_from_BIF(reader):
    edges = ["{} {}".format(e1,e2) for e1,e2 in reader.get_edges()] # make a suitable format for network

    network = nx.parse_edgelist(edges,create_using=nx.DiGraph)
    
    undirected_network = network.to_undirected()
    treewidth_deg, tree_decomposition = treewidth_min_degree(undirected_network)
    treewidth_fill, tree_decomposition = treewidth_min_fill_in(undirected_network)

    return network, treewidth_deg, treewidth_fill


if __name__ == "__main__":
    
    parser = argparse.ArgumentParser()
    parser.add_argument("-i", "--input", default=".", help="path to BIF network files")
    parser.add_argument("-o", "--output", default="out.csv", help="output path")

    args = parser.parse_args()

    input_path = Path(args.input)
    output_file = Path(args.output)
    
    
    with output_file.open("w", newline='') as csvfile:
        writer = csv.writer(csvfile, delimiter=',')
        writer.writerow(["network", "nodes", "edges",
                                     "max_in_degree", "avg_degree", 
                                     "treewidth_min_degree", "treewidth_min_fill_in"]) # csv header

        counter = 0
        for network_file in input_path.glob("*.{}".format(NETWORK_FILE_EXTENSIONS)):
            print("Parsing {}".format(network_file.name))
            reader = BIFReader(network_file)   
            
            name = network_file.stem 
            print("Computing treewidth for {}".format(name))   
            network, min_degree, min_fill = compute_treewidth_from_BIF(reader)
            
            nodes = network.order()
            edges = network.size()
            max_indegree = (np.array([n for node,n in network.in_degree()])).max()
            avg_degree = (np.array([n for node,n in network.degree()])).mean()

            writer.writerow([name, nodes, edges,
                                   max_indegree, avg_degree, 
                                   min_degree, min_fill])
            counter += 1


        
        print("Processed {} networks".format(counter))
    

    
