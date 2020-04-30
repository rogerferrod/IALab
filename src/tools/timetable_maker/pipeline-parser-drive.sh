# First, make this file executable
# chmod a+x pipeline-parser.sh

# Run Clingo and put output in temporany file, in order to parse the result.

# First, move to the master.cl folder
cd ../../asp/

# Select the right path to Google drive, in which the file temp.txt will be 
# copied after the run of this script.
echo Please choose your path to Goodle Drive: 
options=("Lorenzo" "Pio" "Roger" "Exit")
select opt in "${options[@]}"
do
    case $opt in
        "Lorenzo")
            echo "you chose Lorenzo's path to Google Drive"
            clingo master.cl > /Volumes/GoogleDrive/Il\ mio\ Drive/Magistrale/Corsi/IALAB/Progetto/Progetto\ 19-20/1\ -\ PROLOG\ e\ ASP/test/out.txt
            echo "temp.txt successfully copied at the specified location. Exiting from program."
            break
            ;;
        "Pio")
            echo "you chose Pio's path to Google Drive"
            echo "This path is currently empty. Exiting the program without copying temp.txt."
            # TODO: Pio's path to GDrive
            # clingo master.cl > PATH
            # echo "temp.txt successfully copied at the specified location. Exiting from program."
            break
            ;;
        "Roger")
            echo "you chose Roger's path to Google Drive"
            echo "This path is currently empty. Exiting the program without copying temp.txt."
            # TODO: Roger's path to GDrive
            # clingo master.cl > PATH
            # echo "temp.txt successfully copied at the specified location. Exiting from program."
            break
            ;;
        "Exit")
            echo "Exiting from program."
            break
            ;;
    esac
done