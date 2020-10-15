import numpy as np
import networkx as nx
from pgmpy.readwrite import BIFReader
from networkx.algorithms.approximation.treewidth import treewidth_min_degree,treewidth_min_fill_in
from pathlib import Path
import csv
import argparse



def compute_treewidth_from_BIF(reader):
    edges = ["{} {}".format(e1,e2) for e1,e2 in reader.get_edges()] # make a suitable format for network

    network = nx.parse_edgelist(edges)

    treewidth_deg, tree_decomposition = treewidth_min_degree(network)
    treewidth_fill, tree_decomposition = treewidth_min_fill_in(network)

    return treewidth_deg, treewidth_fill


if __name__ == "__main__":
    
    parser = argparse.ArgumentParser()
    parser.add_argument("-i", "--input", default=".", help="path to BIF network files")
    parser.add_argument("-o", "--output", default="out.csv", help="output path")

    args = parser.parse_args()

    input_path = Path(args.input)
    output_file = Path(args.output)
    
    with output_file.open("w", newline='') as csvfile:
        writer = csv.writer(csvfile, delimiter=',')
        writer.writerow(["network","treewidth_min_degree", "treewidth_min_fill_in"]) # csv header

        for network_file in input_path.glob("*.bif"):
            print("Parsing {}".format(network_file.name))
            reader = BIFReader(network_file)   
            
            name = network_file.stem 
            print("Computing treewidth for {}".format(name))   
            min_degree, min_fill = compute_treewidth_from_BIF(reader)
            
            writer.writerow([name, min_degree, min_fill])
    

    
