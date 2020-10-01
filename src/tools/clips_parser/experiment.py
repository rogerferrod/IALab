from pathlib import Path
import subprocess
import argparse

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
    args = ["-l {}".format(agent_dir/name) for name in filenames]
    args[map_index] = "-l {}".format(map_path)
    
    return args

def get_clips_cmd(agent_dir, map_path):
    cmd = ["clips"]
    cmd.extend(get_clips_cmd_argument(agent_dir,map_path))
    run_file = "-f2 {}".format(agent_dir/"run.bat")
    cmd.append(run_file)
    
    return cmd


parser = argparse.ArgumentParser()
parser.add_argument("-m", "--maps", default="maps", help="path to maps files")
parser.add_argument("-a", "--agent", default="expert", help="path to clips agent")
parser.add_argument("-e", "--experiments", default="experiments", help="path to experiments")
parser.add_argument("-en", "--expName", required=True, help="experiment name")
parser.add_argument("-p", "--paramsSetName", required=True, help="parameters set name")



if __name__ == "__main__":
    args = parser.parse_args()

    maps_dir = Path(args.maps)
    agent_dir = Path(args.agent)
    experiment_dir = Path(args.experiments) / "experiment-{}".format(args.expName) / args.paramsSetName


    try:
        experiment_dir.mkdir(parents=True)
        for map_path in maps_dir.glob("*.clp"):
            #run_dir = experiment_dir / map_path.stem
            #run_dir.mkdir()
            out_file = experiment_dir / "out.txt"
            
            with open(out_file, "w") as file:
                cmd_to_run = get_clips_cmd(agent_dir, map_path)
                print("Running experiment {} with parameters {} on map {}".format(args.expName,
                                                                              args.paramsSetName,
                                                                                map_path.stem))
                subprocess.run(cmd_to_run, stdout=file)
            
    except FileExistsError:
        print("Directories already exists! Please remove them before to try again!")