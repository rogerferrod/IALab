EXPERIMENT="E0"
OUTFILE=$EXPERIMENT"_out.txt"
MEM="10G" # assigning 10 GB of memory

cd ../out/static/
ORDERING="topological"
VERBOSE="false"
JSON="../../input/static/Avg_queries.json"
NETWORKS="earthquake asia sachs alarm win95pts insurance munin_full pigs andes link"
PRUNING="false false false"

echo "last execution " $(date) >> $OUTFILE
for network in $NETWORKS
do 
    echo "processing..."

    echo  "Network:"$network "Order:"$ORDERING "Pruning:"$PRUNING
    
    echo __________________________________________________________________>> $OUTFILE
    echo >> $OUTFILE
    echo  "Network:"$network "Order:"$ORDERING "Pruning:"$PRUNING >> $OUTFILE
    echo >> $OUTFILE
    java -Xms$MEM -jar static.jar $ORDERING $VERBOSE $JSON $network $PRUNING >> $OUTFILE
    
    echo >> $OUTFILE
done