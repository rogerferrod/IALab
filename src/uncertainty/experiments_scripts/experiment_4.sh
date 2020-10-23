EXPERIMENT="E4"
OUTFILE=$EXPERIMENT"_out.txt"

cd ../out/static/
ORDERING="minfill"
VERBOSE="false"
JSON="../../input/static/E4_treewidth.json"
NETWORKS="earthquake asia"
PRUNING="true true true"

echo "last execution " $(date) >> $OUTFILE
for network in $NETWORKS
do 
    echo "processing..."

    echo  "Network:"$network "Order:"$ORDERING "Pruning:"$PRUNING
    
    echo __________________________________________________________________>> $OUTFILE
    echo  "Network:"$network "Order:"$ORDERING "Pruning:"$PRUNING &>> $OUTFILE
    echo >> $OUTFILE
    java -jar static.jar $ORDERING $VERBOSE $JSON $network $PRUNING &>> $OUTFILE
    
    echo __________________________________________________________________>> $OUTFILE
    echo >> $OUTFILE
    echo >> $OUTFILE
done