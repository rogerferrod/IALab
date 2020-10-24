EXPERIMENT="D0"
OUTFILE=$EXPERIMENT"_out.txt"

cd ../out/dynamic/
ORDERING="topological"
VERBOSE="false"
JSON="../../input/dynamic/DBNexperiments.json"
NETWORKS="Umbrella_00 UmbrellaWind_00 TwoFactors_00 earthquake_00 fivestates_00 fivestates2_00 tenstates_00"
ITERATIONS="10000"

echo "last execution " $(date) >>$OUTFILE
for network in $NETWORKS; do
  echo "processing..."

  echo "Network:"$network "Order:"$ORDERING

  echo __________________________________________________________________ >>$OUTFILE
  echo "Network:"$network "Order:"$ORDERING >>$OUTFILE
  echo >>$OUTFILE
  java -jar dynamic.jar $ORDERING $VERBOSE $JSON $network >>$OUTFILE 2>&1

  echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ >>$OUTFILE
  java -jar ../particle/particle.jar $ITERATIONS $JSON $network >>$OUTFILE 2>&1

  echo __________________________________________________________________ >>$OUTFILE
  echo >>$OUTFILE
  echo >>$OUTFILE
done
