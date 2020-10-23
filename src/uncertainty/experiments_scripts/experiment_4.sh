EXPERIMENT="E4"
OUTFILE=$EXPERIMENT"_out.txt"
MEM="8G"

cd ../out/static/
ORDERING="minfill"
VERBOSE="false"
JSON="../../input/static/Avg_queries.json"
NETWORKS="earthquake asia sachs alarm win95pts insurance munin_full pigs link andes"
PRUNING="true true true"

echo "last execution " $(date) >>$OUTFILE
for network in $NETWORKS; do
  echo "processing..."

  echo "Network:"$network "Order:"$ORDERING "Pruning:"$PRUNING

  echo __________________________________________________________________ >>$OUTFILE
  echo "Network:"$network "Order:"$ORDERING "Pruning:"$PRUNING >>$OUTFILE
  echo >>$OUTFILE
  java -Xms$MEM -jar static.jar $ORDERING $VERBOSE $JSON $network $PRUNING >>$OUTFILE 2>&1

  echo __________________________________________________________________ >>$OUTFILE
  echo >>$OUTFILE
  echo >>$OUTFILE
done
