EXPERIMENT="E3"
QTYPES="simple evidence conjunctive"
MEM="8G" # assigning 10 GB of memory

ORDERING="minfill"
VERBOSE="false"
NETWORK="insurance"
PRUNING="true true true"

cd ../out/static/
for query in $QTYPES # loop trough scenario
do 
    JSON="../../input/static/$EXPERIMENT\_$query.json"
    OUTFILE=${EXPERIMENT}_${query}_out.txt
    echo "last execution " $(date) >> $OUTFILE
    echo "processing..."

    echo  "Network:"$NETWORK "Order:"$ORDERING "Pruning:"$PRUNING # to stdout
    
    echo __________________________________________________________________>> $OUTFILE
    echo  "Network:"$NETWORK "Order:"$ORDERING "Pruning:"$PRUNING >> $OUTFILE
    echo >> $OUTFILE
    java -Xms$MEM -jar static.jar $ORDERING $VERBOSE $JSON $NETWORK $PRUNING >> $OUTFILE 2>&1
    
    echo __________________________________________________________________>> $OUTFILE
    echo >> $OUTFILE
    echo >> $OUTFILE

done