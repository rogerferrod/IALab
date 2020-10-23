EXPERIMENT="E2"
OUTFILE=$EXPERIMENT"_out.txt"
MEM="8G" # assigning 10 GB of memory

cd ../out/static/
ORDERINGS=("topological" "mindegree" "minfill")
VERBOSE="false"
JSON="../../input/static/E2_ordering_pruning.json"
NETWORKS="earthquake asia sachs alarm win95pts insurance munin_full pigs andes link"
PRUNING="false false false"

echo "last execution " $(date) >> $OUTFILE
for network in $NETWORKS # loop trough networks
do 
    echo "processing..."
    for i in  0 1 2 # loop trough orderings
    do
        echo  "Network:"$network "Order:"${ORDERINGS[i]} "Pruning:"$PRUNING # to stdout
        
        echo __________________________________________________________________>> $OUTFILE
        echo  "Network:"$network "Order:"${ORDERINGS[i]} "Pruning:"$PRUNING >> $OUTFILE
        echo >> $OUTFILE
        java -Xms$MEM -jar static.jar ${ORDERINGS[i]} $VERBOSE $JSON $network $PRUNING >> $OUTFILE 2>&1
        
        echo __________________________________________________________________>> $OUTFILE
        echo >> $OUTFILE
        echo >> $OUTFILE
    done
done