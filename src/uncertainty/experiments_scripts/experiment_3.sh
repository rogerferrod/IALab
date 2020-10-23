EXPERIMENT="E3"
QTYPES="simple evidence conjunctive"
MEM="10G" # assigning 10 GB of memory

ORDERING="minfill"
VERBOSE="false"
NETWORK="insurance"
PRUNING="true true true"

RUN=10

cd ../out/static/
for query in $QTYPES # loop trough scenario
do 
    JSON="../../input/static/$EXPERIMENT\_$query.json"
    OUTFILE=${EXPERIMENT}_${query}_out.txt
    echo "last execution " $(date) >> $OUTFILE
    echo "processing..."
    for run in $(seq 1 $RUN)
    do
        echo  "Query:"$query "Network:"$NETWORK "Order:"$ORDERING "Pruning:"$PRUNING "Run:"$run # to stdout
        
        echo __________________________________________________________________>> $OUTFILE
        echo  "Network:"$NETWORK "Order:"$ORDERING "Pruning:"$PRUNING "Run:"$run>> $OUTFILE
        echo >> $OUTFILE
        EXP="${EXPERIMENT}_${query}_run#${run}"
        echo $EXP
        java -Xms$MEM -jar static.jar $ORDERING $VERBOSE $JSON $EXP $PRUNING >> $OUTFILE # execute
        
        echo __________________________________________________________________>> $OUTFILE
        echo >> $OUTFILE
        echo >> $OUTFILE
    done
done