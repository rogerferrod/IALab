"""
Script used to run our experiment with CLIPS. It invokes CLIPS from command line and it runs some experiments.
"""

__author__ = "Roger Ferrod, Pio Raffaele Fina, Lorenzo Tabasso"

from pathlib import Path
import subprocess
import argparse
import itertools
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle
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
            elif content == "middle":
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
        plt.savefig("{0}/{1}-heat.png".format(output_folder, output_name))



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
        
        plt.savefig("{0}/{1}-solve.png".format(output_folder, output_name))


def get_clips_cmd_argument(agent_dir, map_path):
    filenames = ["0_Main.clp",
            "1_Env.clp",
            "", # reserved place for map file
            "2_Heat.clp",
            "3_Convolution.clp",
            "4_Deliberate.clp",
            "5_Discover.clp",
            "6_Planning.clp",
            "7_Agent.clp"]
    map_index = 2
    args = ["{}".format(agent_dir/name) for name in filenames]
    args[map_index] = "{}".format(map_path)
    
    return list(itertools.chain.from_iterable((zip(itertools.cycle(['-l']), args))))

def get_clips_cmd(agent_dir, map_path, clipsbinary="clipsdos"):
    cmd = [clipsbinary]
    cmd.extend(get_clips_cmd_argument(agent_dir,map_path))
    run_file = ["-f2", "{}".format(agent_dir/"run_experiment.bat")]
    cmd.extend(run_file)

    return cmd
    
parser = argparse.ArgumentParser()
parser.add_argument("-m", "--maps", default=r"../../clips/maps", help="path to maps files")
parser.add_argument("-a", "--agent", default=r"../../clips/expert", help="path to clips agent")
parser.add_argument("-e", "--experiments", default="./experiments", help="path to experiments")
parser.add_argument("-en", "--expName", default="all", help="experiment name")
parser.add_argument("-p", "--paramsSetName", default="knowledge", help="parameters set name")


if __name__ == "__main__":
    args = parser.parse_args()

    maps_dir = Path(args.maps)
    agent_dir = Path(args.agent)
    experiment_dir = Path(args.experiments) / "experiment-{}".format(args.expName) / args.paramsSetName

    try:
        experiment_dir.mkdir(parents=True)
        for map_path in maps_dir.glob("*.clp"):
            out_file = experiment_dir / (map_path.stem + "_out.txt")
            with open(out_file, "w") as file:
                
                #print("calling {}".format(get_clips_cmd_argument(agent_dir,map_path)))
                print("Running experiment {} with parameters {} on map {}".format(args.expName,
                                                                                  args.paramsSetName,
                                                                                  map_path.stem))
                cmd_to_run = get_clips_cmd(agent_dir, map_path)
                #print(cmd_to_run)
                subprocess.run(cmd_to_run, stdout=file)
                               
                draw_heatmap(out_file, out_file.stem.split("_")[0], experiment_dir)
                parse_result(out_file, out_file.stem.split("_")[0], experiment_dir)
            
    except FileExistsError:
        print("Directories already exists! Please remove them before to try again!")