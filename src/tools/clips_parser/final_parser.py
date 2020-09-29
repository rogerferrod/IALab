import numpy as np
import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle
import argparse
import re


heatmap = np.zeros(shape=(10,10))  # initializing the matrix

def highlight_cell(y, x, ax=None, **kwargs):
    rect = plt.Rectangle((x-.5, y-.5), 1,1, fill=False, **kwargs)
    ax = ax or plt.gca()
    ax.add_patch(rect)
    return rect


def annotate_heatmap():
    for g in guess:
        x = int(g[0])
        y = int(g[1])
        highlight_cell(x,y, color="green", linewidth=2)

    for f in fires:
        x = int(f[0])
        y = int(f[1])
        plt.text(y, x, "F", ha="center", va="center", color="g")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("-i", "--input", default="./input/out155-2.txt", help="input file")
    args = parser.parse_args()
    input_file = args.input

    with open(input_file,"r") as file:
        lines = file.read()
        
        regex_heatmap = re.compile("heat-map \(x (\d)\) \(y (\d)\) \(h (\d+)\)")
        regex_guess = re.compile("\(guess (\d) (\d)\)")
        regex_fires = re.compile("\(fire (\d) (\d)\)")
        
        coordinates = re.findall(regex_heatmap, lines)
        guess = re.findall(regex_guess, lines)
        fires = re.findall(regex_fires, lines)
        
        for c in coordinates:
            x = int(c[0])
            y = int(c[1])
            value = int(c[2])
            
            heatmap[x,y] = value
                
        # Getting the cordinates of the cells containing 100
        cells_100 = np.where(heatmap == 100)
        # putting them all to 0
        heatmap[cells_100] = 0
        # putting them all to max value + 1
        heatmap[cells_100] = np.max(heatmap) + 1
    
    fig = plt.figure(figsize=(8,8))
    # plt.imshow(heatmap)
    plt.imshow(np.zeros(shape=(10,10)), cmap="gray")
    plt.xlabel("Y")
    plt.ylabel("X")
    annotate_heatmap()
    plt.show()
