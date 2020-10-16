import numpy as np
import numpy.random as rnd
from pgmpy.readwrite import BIFReader
import json
from pathlib import Path

EXP = "E3"
QTYPE = "simple"
N_RUNS = 10
N_QUERY = 3
N_EVIDENCES = 5

def generate_json_experiment(network, query, evidences):
    evidences_string = ",".join(["{}={}".format(va,state) for va,state in evidences])
    
    experiment = {'network':network,
            'query': ','.join(query),
            'evidences': evidences_string}

    return experiment


if __name__ == "__main__":
    np.random.seed(1620)
    network_file = ".networks/bif/pathfinder.bif"

    reader = BIFReader(network_file)   
    nodes = reader.get_variables()
    states = reader.get_states()

    experiments = {}

    sampled = rnd.choice(nodes, size=(N_RUNS, N_QUERY + N_EVIDENCES), replace=False)
    
    for i, run in enumerate(sampled): # for each run
        query = run[0:N_QUERY]
        evidences = run[N_QUERY:]

        evidences = [(va,rnd.choice(states[va])) for va in evidences] # sample random state for a give va

        exp_run = generate_json_experiment(network_file, query, evidences)
        name = "{}_{}_run#{}".format(EXP,QTYPE,i+1)
        experiments[name] = exp_run
    
    out_file = Path("input/{}_{}.json".format(EXP,QTYPE))
    with out_file.open("w") as file:
        file.write(json.dumps(experiments,indent=4))
    