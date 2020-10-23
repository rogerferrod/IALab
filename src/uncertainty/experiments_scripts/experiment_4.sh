EXPERIMENT="E4"
OUTFILE=$EXPERIMENT"_out.txt"
MEM="10G" # assigning 10 GB of memory

cd ../out/static/
ORDERING="minfill"
VERBOSE="false"
JSON="../../input/static/E4_treewidth.json"
NETWORKS="earthquake asia sachs alarm win95pts insurance munin_full pigs andes link"
PRUNING="true true true"

echo "last execution " $(date) >> $OUTFILE
for network in $NETWORKS
do 
    echo "processing..."

    echo  "Network:"$network "Order:"$ORDERING "Pruning:"$PRUNING
    
    echo __________________________________________________________________>> $OUTFILE
    echo  "Network:"$network "Order:"$ORDERING "Pruning:"$PRUNING >> $OUTFILE
    echo >> $OUTFILE
    java -Xms$MEM -jar static.jar $ORDERING $VERBOSE $JSON $network $PRUNING >> $OUTFILE
    
    echo __________________________________________________________________>> $OUTFILE
    echo >> $OUTFILE
    echo >> $OUTFILE
done