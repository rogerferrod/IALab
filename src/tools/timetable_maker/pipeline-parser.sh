# First, make this file executable
# chmod a+x pipeline-parser.sh

# Run Clingo and put output in temporany file, in order to parse the result.
cd ../../asp/
clingo master.cl > ../tools/timetable_maker/temp.txt

# Go back to the parser directory.
cd ../tools/timetable_maker/

# And run the parser on the temp file, which contains the otput.
python3 parser.py temp.txt

# Now open the Excel file and have fun!