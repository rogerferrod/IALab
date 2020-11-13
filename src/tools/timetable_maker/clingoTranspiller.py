"""
A simple Clingo transpiler. It takes as input a .txt file containing the clingo
output, and it returns a .xlsx file containing the timetable rapresentation of
the input.
"""

__author__ = "Roger Ferrod, Pio Raffaele Fina, Lorenzo Tabasso"

import sys
import re
from collections import namedtuple
from optparse import OptionParser
import numpy as np
import pandas as pd
import xlsxwriter

if __name__ == "__main__":
    argv = sys.argv[1:]
    parser = OptionParser()

    parser.add_option("-i", "--input", default="../../asp/output/out.txt",
                        help="path to the clingo ouptput, encoded as a .txt file",
                        action="store", type="string", dest="input")

    parser.add_option("-o", "--output", default="output/timetable.xlsx",
                        help="path to the output foler", action="store", type="string",
                        dest="output")

    (options, args) = parser.parse_args()

    # Path to the clingo output file
    input_file = options.input

    Calendar = namedtuple("Calendar",["week","day","hour","id","lecture","professor"]) 
    with open(input_file,"r") as file:
        lines = file.read()
        
        # Parser specification:
        # we use a regex to match the answer set
        regex_predicate = re.compile("calendar\((\d+),(\d+),(\d+),(\d+),\"([\w\s:-]+)\",\"([\w\s:-]*)\"\)")
        regex_top_level = re.compile("(Answer: [\d]+)\n(.+)")


        # Parsing two hardcoded nested levels: 
        # lvl 1) multiple answer-set
        parsed_content = {}
        for answer_set_match in re.finditer(regex_top_level,lines):
            answer_set_name = answer_set_match.groups()[0]
            answer_set =  answer_set_match.groups()[1]
            
            # lvl 2) predicates
            predicates = [Calendar._make(predicate_match.groups()) for predicate_match in re.finditer(regex_predicate,answer_set)]
            
            # build dictionary of parsed answer-sets (normalizing the key value)
            parsed_content[answer_set_name.replace(": ","_")] = predicates

        # Moving the parsed_content inside a Pandas Dataframe
        df = pd.DataFrame(parsed_content['Answer_1'])

        # Conversion of type inside the datadframe (otherwise all the data will be imported as string)
        df = df.astype({'week': 'int64', 'day': 'int64', 'hour': 'int64'})

        # Setting DataFrame indexes
        df = df.set_index(['week','day','hour']).drop('id',axis=1)

        # Sorting based on previously defined indexes
        df = df.sort_index()

        # Replacing the day number with a better (and more readable) rapresentation
        df = df.replace({'day':{'1':'Lun (1)','2':'Mar (2)','3':'Mer (3)',
                        '4':'Gio (4)','5':'Ven (5)','6':'Sab (6)'}})

        df['Lecture'] = df['lecture'] + ": " + df['professor']
        df = df.drop(['lecture','professor'], axis=1)

        timetable = df.unstack('hour')
        timetable

        # Path of the output timetable
        output_path = options.output

        # Instaciating a ExcelWriter to save the output file.
        writer = pd.ExcelWriter(output_path, engine='xlsxwriter')

        # Exporting timetable in the excel file Timetable.xlsx inside Sheet1.
        timetable.to_excel(writer, sheet_name="Sheet1")

        print("Timetable transpiled into output/timetable.xlsx.")

        # Getting the xlsxwriter workbook and worksheet objects.
        workbook  = writer.book
        worksheet = writer.sheets['Sheet1']

        # Format 1. Light red fill with dark red text.
        format1 = workbook.add_format({'bg_color': '#FFC7CE','font_color': '#9C0006'})

        # Format 2. Green fill with dark green text.
        format2 = workbook.add_format({'bg_color': '#C6EFCE','font_color': '#006100'})
            
        # Format 3. Yellow fill with brown text.
        format3 = workbook.add_format({'bg_color': '#FFEB9B','font_color': '#9D744F'})
            
        # Format 4. Orange fill with light purple text.
        format4 = workbook.add_format({'bg_color': '#FFCC99','font_color': '#766882'})

        worksheet.conditional_format('C4:J59', {'type': 'text',
                                                'criteria': 'containing',
                                                'value': 'Recupero',
                                                'format': format1})

        worksheet.conditional_format('C4:J59', {'type': 'text',
                                                'criteria': 'containing',
                                                'value': 'Fondamenti di ICT e Paradigmi di Programmazione: Pozzato',
                                                'format': format2})

        worksheet.conditional_format('C4:J59', {'type': 'text',
                                                'criteria': 'containing',
                                                'value': 'Ambienti di sviluppo e linguaggi client-side per il web: Micalizio',
                                                'format': format3})


        # Close the Pandas Excel writer and output the Excel file.
        writer.save()

        print("Timetable formatting completed.")
