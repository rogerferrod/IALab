EXPERIMENT="D1"
OUTFILE=$EXPERIMENT"_out.txt"

cd ../out/dynamic/
ORDERING="mindegree minfill"
VERBOSE="false"
JSON="../../input/dynamic/DBNexperiments.json"
NETWORKS="Umbrella_00 UmbrellaWind_00 TwoFactors_00 earthquake_00 fivestates_00 fivestates2_00"


echo "last execution " $(date) >>$OUTFILE
for network in $NETWORKS; do
  for order in $ORDERING; do
      echo "processing..."

      echo "Network:"$network "Order:"$order

      echo __________________________________________________________________ >>$OUTFILE
      echo "Network:"$network "Order:"$order >>$OUTFILE
      echo >>$OUTFILE
      java -jar dynamic.jar $order $VERBOSE $JSON $network >>$OUTFILE 2>&1

      echo __________________________________________________________________ >>$OUTFILE
      echo >>$OUTFILE
      echo >>$OUTFILE
  done
done
