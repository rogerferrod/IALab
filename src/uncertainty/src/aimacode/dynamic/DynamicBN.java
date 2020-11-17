package aimacode.dynamic;

import aima.core.probability.RandomVariable;
import aima.core.probability.proposition.AssignmentProposition;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;

import org.json.*;

public class DynamicBN {
    public static void main(String[] args) throws IOException {
        args[0] = "topological";
        args[1] = "true";
        args[2] = "./input/dynamic/DBNexperiments.json";
        args[3] = "TwoFactors_00";
        String jsonData = new String(Files.readAllBytes(Paths.get(args[2])));
        JSONObject obj = new JSONObject(jsonData);
        JSONObject experiment = (JSONObject) obj.get(args[3]);
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

        NetworkFactory factory = new NetworkFactory();
        WrapDynamicBayesNet dbn = factory.getNetwork((String) experiment.get("network"));

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

        long start = System.currentTimeMillis();
        RollupFiltering filtering = new RollupFiltering(dbn, query, evidencesOverTime, args[0], Boolean.parseBoolean(args[1]));
        long finish = System.currentTimeMillis();
        long timeElapsed = finish - start;
        System.out.println(filtering);

        System.out.println("\nFinal distribution " + filtering.rollup() + "\n");
        System.out.println("Time elapsed " + timeElapsed + " milliseconds");

//        long start = System.nanoTime();
//        RollupFiltering filtering = new RollupFiltering(dbn, query, evidencesOverTime, args[0], Boolean.parseBoolean(args[1]));
//        long finish = System.nanoTime();
//        long timeElapsed = finish - start;
//        System.out.println(filtering);
//
//        System.out.println("\nFinal distribution " + filtering.rollup() + "\n");
//        System.out.println("Time elapsed " + timeElapsed + " nanoseconds");
    }
}
