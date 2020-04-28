# First, make this file executable
# chmod a+x pipeline-parser.sh

# Run Clingo and put output in temporany file, in order to parse the result.
cd ../../asp/
clingo master.cl > ../tools/timetable_maker/temp.txt

# Go back to the parser directory.
cd ../tools/timetable_maker/

# Check your path to your google drive before continue
echo Check the script path to Google Drive folder.
while true; do
    read -p "Do you want to exit, in order to check the right path? " yn
    case $yn in
        [Yy]* ) exit;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

# Copy the temp.txt file to Lorenzo's Google Drive
cp -f temp.txt /Volumes/GoogleDrive/Il\ mio\ Drive/Magistrale/Corsi/IALAB/Progetto/Progetto\ 19-20/1\ -\ PROLOG\ e\ ASP/test/