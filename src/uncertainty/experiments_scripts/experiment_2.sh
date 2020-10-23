EXPERIMENT="E2"
OUTFILE=$(pwd)/$EXPERIMENT"_out.txt"

cd ../out/static/
ORDERINGS=("topological" "mindegree" "minfill")
VERBOSE="false"
JSON="../../input/static/E2_ordering_pruning.json"
NETWORKS="earthquake asia"
PRUNING="false false false"


for network in $NETWORKS # loop trough networks
do 
    echo "processing..."
    for i in  0 1 2 # loop trough orderings
    do
        echo  "Network:"$network "Order:"${ORDERINGS[i]} "Pruning:"$PRUNING # to stdout
        
        echo __________________________________________________________________>> $OUTFILE
        echo  "Network:"$network "Order:"${ORDERINGS[i]} "Pruning:"$PRUNING &>> $OUTFILE
        echo >> $OUTFILE
        java -jar static.jar ${ORDERINGS[i]} $VERBOSE $JSON $network $PRUNING &>> $OUTFILE # execute
        
        echo __________________________________________________________________>> $OUTFILE
        echo >> $OUTFILE
        echo >> $OUTFILE
    done
done