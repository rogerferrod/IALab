import numpy as np
import pandas as pd
import xlsxwriter
import re
from collections import namedtuple
import sys

# main data structure 
Calendar = namedtuple("Calendar",["week","day","hour","id","lecture","professor"]) 

def parse_file(input_file):

    with open(input_file,"r") as file:
        lines = file.read()

        ## Parser specification
        regex_predicate = re.compile("calendar\(([0-9]+),([0-9]+),([0-9]+),([0-9]+),lecture\(\"([a-zA-Z0-9]+)\",\"([a-zA-Z0-9]+)\"\)\)")
        regex_top_level = re.compile("(Answer: [0-9]+)\n(.+)")


        # Parse 2 hardcoded nested levels: 
        # lvl 1) multiple answer-set
        parsed_content = {}
        for answer_set_match in re.finditer(regex_top_level,lines):
            answer_set_name = answer_set_match.groups()[0]
            answer_set =  answer_set_match.groups()[1]
            # lvl 2) predicates
            predicates = [Calendar._make(predicate_match.groups()) for predicate_match in re.finditer(regex_predicate,answer_set)]

            # build dictionary of parsed answer-sets (normalizing the key value)
            parsed_content[answer_set_name.replace(": ","_")] = predicates
    
    return parsed_content


if __name__ == '__main__':
    parsed_content = parse_file(sys.argv[1])
    
    # build dataframe and export as excel file
    for answer_set, predicates in parsed_content.items():
        df = pd.DataFrame(predicates, columns=Calendar._fields)
        df = df.sort_values(["week","day","hour"])
        file_name = "{}.xlsx".format(answer_set)
        df.to_excel(file_name)
        print("File {} generated".format(file_name))
    
