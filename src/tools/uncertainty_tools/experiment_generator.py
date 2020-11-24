"""
Config generator for Experiment 3 of Uncertainty project.
"""

__author__ = "Roger Ferrod, Pio Raffaele Fina, Lorenzo Tabasso"


import numpy as np
import numpy.random as rnd
from pgmpy.readwrite import XMLBIFReader as BIFReader
import json
from pathlib import Path

"""
Experiment 3-simple setup:
EXP = "E3"
QTYPE = "simple"
N_RUNS = 10
N_QUERY = 1
N_EVIDENCES = 0
network_file = "../../networks/test100.xml"

Experiment 3-evidence setup:
EXP = "E3"
QTYPE = "evidence"
N_RUNS = 10
N_QUERY = 1
N_EVIDENCES = 5
network_file = "../../networks/test100.xml"

Experiment 3-conjunctive setup:
EXP = "E3"
QTYPE = "conjunctive"
N_RUNS = 10
N_QUERY = 3
N_EVIDENCES = 5
network_file = "../../networks/test100.xml"
"""

EXP = "E3"
QTYPE = "simple"
N_RUNS = 10
N_QUERY = 1
N_EVIDENCES = 0
network_file = "../../networks/test100.xml"




def generate_json_experiment(network, query, evidences):
    evidences_string = ",".join(["{}={}".format(va,state) for va,state in evidences])
    network_output = Path(network).with_suffix(".xml") # change extension from bif to xml

    experiment = {'network':str(network_output),
            'query': ','.join(query),
            'evidences': evidences_string}

    return experiment


if __name__ == "__main__":
    np.random.seed(1620)

    reader = BIFReader(network_file)   
    nodes = reader.get_variables()
    states = reader.get_states()

    experiments = {}

    sampled = rnd.choice(nodes, size=(N_RUNS, N_QUERY + N_EVIDENCES), replace=False)
    
    for i, run in enumerate(sampled): # for each run
        query = run[0:N_QUERY]
        evidences = run[N_QUERY:]

        evidences = [(va,rnd.choice(states[va])) for va in evidences] # sample random state for a give va
        query = np.char.capitalize(query)
        
        if len(evidences) != 0:
            evidences = np.char.capitalize(evidences)

        exp_run = generate_json_experiment(network_file, query, evidences)
        name = "{}_{}_run#{}".format(EXP,QTYPE,i+1)
        experiments[name] = exp_run
    
    out_file = Path("../../input/static/{}_{}.json".format(EXP,QTYPE))
    with out_file.open("w") as file:
        file.write(json.dumps(experiments,indent=4))
