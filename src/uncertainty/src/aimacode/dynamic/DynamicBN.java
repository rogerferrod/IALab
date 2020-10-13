package aimacode.dynamic;

import aima.core.probability.RandomVariable;
import aima.core.probability.bayes.BayesianNetwork;
import aima.core.probability.proposition.AssignmentProposition;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;
import java.util.stream.Collectors;

import aimacode.bnparser.BifReader;
import org.json.*;

public class DynamicBN {
    public static void main(String[] args) throws IOException {
        args = new String[4];
        args[0] = EliminationAskDynamic.TOPOLOGICAL;
        //args[0] = EliminationAskDynamic.MIN_DEGREE;
        //args[0] = EliminationAskDynamic.MIN_FILL;

        args[1] = "true";
        args[2] = "./input/DBNexperiments.json";
        //args[3] = "Umbrella_00";
        //args[3] = "UmbrellaWind_00";
        args[3] = "TwoFactors_00";
        //args[3] = "Random_00";
        //args[3] = "Random_02";
        //args[3] = "Random_03";
        //args[3] = "Random_04";
        //args[3] = "Random_05";

        String jsonData = new String(Files.readAllBytes(Paths.get(args[2])));
        JSONObject obj = new JSONObject(jsonData);
        JSONObject experiment = (JSONObject) obj.get(args[3]);
        String network = experiment.getString("network");
        JSONObject evidencesInput = (JSONObject) experiment.get("evidences");

        int m = (int) experiment.get("iterations");
        int n = evidencesInput.length();
        String[] argsEvNames = evidencesInput.keySet().toArray(new String[n]);
        String[][] argsEv = new String[n][m];

        for (int i = 0; i < n; i++) {
            JSONArray arr = (JSONArray) evidencesInput.get(argsEvNames[i]);
            for (int j = 0; j < arr.length(); j++) {
                argsEv[i][j] = arr.getString(j);
            }
        }

        Map<String, List<String>> mapping = new HashMap<>();
        JSONObject map = (JSONObject) experiment.get("map");
        for (String key : map.keySet()) {
            mapping.put(key, map.getJSONArray(key).toList().stream().map(Object::toString).collect(Collectors.toList()));
        }

        WrapDynamicBayesNet dbn = null;
        NetworkFactory factory = new NetworkFactory();
        if (mapping.size() != 0) {
            BayesianNetwork bn = BifReader.readBIF(network);
            Set<String> evNames = evidencesInput.keySet();
            dbn = factory.getNetwork(bn, mapping, evNames);
        } else {
            dbn = factory.getNetwork((String) experiment.get("network"));
        }

        ArrayList<String> evNames = new ArrayList<>(Arrays.asList(argsEvNames));
        Map<Integer, AssignmentProposition[]> evidencesOverTime = new LinkedHashMap<>(); //t : evidences(t)
        RandomVariable[] query = Arrays.stream(dbn.getVariables())
                .filter(x -> !evNames.contains(x.getName())).toArray(RandomVariable[]::new);

        for (int j = 0; j < evNames.size(); j++) {
            String varName = evNames.get(j);
            RandomVariable var = dbn.getVaNamesMap().get(varName);
            evidencesOverTime.put(0, null);
            for (int i = 1; i <= m; i++) {
                AssignmentProposition as = new AssignmentProposition(var,
                        Integer.parseInt(argsEv[j][i - 1]) == 0 ? Boolean.FALSE : Boolean.TRUE);
                if (!evidencesOverTime.containsKey(i)) {
                    evidencesOverTime.put(i, new AssignmentProposition[evNames.size()]);
                }
                evidencesOverTime.get(i)[j] = as;
            }
        }

        RollupFiltering filtering = new RollupFiltering(dbn, query, evidencesOverTime, args[0], Boolean.parseBoolean(args[1]));
        System.out.println(filtering);

        System.out.println("\nFinal distribution " + filtering.rollup() + "\n");
    }
}
