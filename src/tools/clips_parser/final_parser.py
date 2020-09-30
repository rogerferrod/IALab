import numpy as np
import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle
import argparse
import re


def highlight_cell(x, y, ax=None, **kwargs):
    rect = plt.Rectangle((x-.5, y-.5), 1,1, fill=False, **kwargs)
    ax = ax or plt.gca()
    ax.add_patch(rect)
    return rect


def draw_heatmap(path, output_name, output_folder):
    heatmap = np.zeros(shape=(10,10))  # initializing the matrix
    
    with open(path, "r") as file:
        lines = file.read()
        regex_heatmap = re.compile("heat-map \(x (\d)\) \(y (\d)\) \(h (\d+)\)")
        regex_action = re.compile("\(action (.+)\) \(x (\d)\) \(y (\d)\)")
        regex_k_cell = re.compile("k-cell \(x (\d)\) \(y (\d)\) \(content (.+)\)\)")
        
        coordinates = re.findall(regex_heatmap, lines)
        actions = re.findall(regex_action, lines)
        k_cells = re.findall(regex_k_cell, lines)

        for x, y, value in coordinates:
            heatmap[int(x), int(y)] = value
                
        # Getting the cordinates of the cells containing 100
        cells_100 = np.where(heatmap == 100)
        # putting them all to 0
        heatmap[cells_100] = 0
        # putting them all to max value + 1
        heatmap[cells_100] = np.max(heatmap) + 1

        # Heatmap
        fig = plt.figure(figsize=(10,10))

        for x, y, content in k_cells:
            if content == "top":
                t = "t"
            elif content == "mid":
                t = "m"
            elif content == "bot":
                t = "b"
            elif content == "left":
                t = "l"
            elif content == "right":
                t = "r"
            elif content == "sub":
                t = "s"
            elif content == "water":
                t = "w"
            plt.text(int(y), int(x), t, ha="center", va="center", color="r")

        for content, x, y in actions:
            if content == "fire":
                highlight_cell(int(y), int(x), color="red", linewidth=2)
        
        plt.imshow(heatmap)
        plt.savefig("{0}{1}-heat.png".format(output_folder, output_name))


def parse_result(path, output_name, output_folder):
    with open(path,"r") as file:
        lines = file.read()
        
        regex_guess = re.compile("\(guess (\d) (\d)\)")
        regex_fires = re.compile("\(fire (\d) (\d)\)")
        
        guess = re.findall(regex_guess, lines)
        fires = re.findall(regex_fires, lines)

        # Final result
        fig = plt.figure(figsize=(10,10))
        plt.imshow(np.zeros(shape=(10,10)), cmap="gray")
        plt.xlabel("Y")
        plt.ylabel("X")

        for x, y in guess:
            highlight_cell(int(y), int(x), color="green", linewidth=2)

        for x, y in fires:
            plt.text(int(y), int(x), "F", ha="center", va="center", color="g")
        
        plt.savefig("{0}{1}-solve.png".format(output_folder, output_name))


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("-f", "--final", default="./input/out.txt", help="result")
    parser.add_argument("-t", "--heat", default="./input/heat.txt", help="heatmap")
    parser.add_argument("-o", "--output", default="./output/", help="output folder")
    args = parser.parse_args()
    final_file = args.final
    heat_file = args.heat
    output_folder = args.output

    output_name = final_file.split("/")[-1].split(".")[0]

    draw_heatmap(heat_file, output_name, output_folder)
    parse_result(final_file, output_name, output_folder)

    # python3 final_parser.py -f ./input/out0.txt  -t ./input/heat0.txt -o ./output/

