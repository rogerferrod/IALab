OUTFILE="out.txt"

SCRIPTS=$1/*.pl # get prolog scripts from directory passed as first argument
PROLOG=swipl

echo "last execution " $(date) >>$OUTFILE
for script in $SCRIPTS; do
    echo __________________________________________________________________ >>$OUTFILE
    echo $script >> $OUTFILE
    echo >>$OUTFILE
    /usr/bin/time -p $PROLOG $script >> $OUTFILE 2>&1
    

    echo __________________________________________________________________ >>$OUTFILE
    echo >>$OUTFILE
    echo >>$OUTFILE
done
echo >>$OUTFILE
echo >>$OUTFILE
