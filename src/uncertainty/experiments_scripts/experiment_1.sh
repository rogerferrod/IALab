EXPERIMENT="E1"
OUTFILE=$EXPERIMENT"_out.txt"

cd ../out/static/
ORDERING="topological"
VERBOSE="false"
JSON="../../input/static/E1_ordering.json"
NETWORKS="earthquake asia"
PRUNINGS=("true false false"
          "false true false"
          "false false true"
          "true true true")

echo "last execution " $(date) >> $OUTFILE
for network in $NETWORKS
do 
    echo "processing..."
    for i in  0 1 2 3 # loop trough pruning combinantions
    do
        echo  "Network:"$network "Order:"$ORDERING "Pruning:"${PRUNINGS[i]}
        
        echo __________________________________________________________________>> $OUTFILE
        echo  "Network:"$network "Order:"$ORDERING "Pruning:"${PRUNINGS[i]} &>> $OUTFILE
        echo >> $OUTFILE
        java -jar static.jar $ORDERING $VERBOSE $JSON $network ${PRUNINGS[i]} &>> $OUTFILE
        
        echo __________________________________________________________________>> $OUTFILE
        echo >> $OUTFILE
        echo >> $OUTFILE
    done
done