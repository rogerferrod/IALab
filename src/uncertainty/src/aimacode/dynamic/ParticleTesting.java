package aimacode.dynamic;

import aima.core.probability.RandomVariable;
import aima.core.probability.bayes.approx.ParticleFiltering;
import aima.core.probability.proposition.AssignmentProposition;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.stream.Collectors;
import java.util.*;


public class ParticleTesting {

    public static void main(String[] args) throws IOException {
        args = new String[3];
        args[0] = "10000";

        args[1] = "./input/experiments.json";
        //args[2] = "Umbrella_00";
        //args[2] = "UmbrellaWind_00";
        args[2] = "TwoFactors_00";

        int iterations = Integer.parseInt(args[0]);

        String jsonData = new String(Files.readAllBytes(Paths.get(args[1])));
        JSONObject obj = new JSONObject(jsonData);
        JSONObject experiment = (JSONObject) obj.get(args[2]);
        JSONObject evidencesInput = (JSONObject) experiment.get("evidences");

        int m = (int) experiment.get("iterations");
        int n = evidencesInput.length();
        String[] argsEvNames = evidencesInput.keySet().toArray(new String[n]);
        AssignmentProposition[][] aps = new AssignmentProposition[m][n];

        NetworkFactory factory = new NetworkFactory();
        WrapDynamicBayesNet dbn = factory.getNetwork((String) experiment.get("network"));

        for (int i = 0; i < n; i++) {
            String varName = argsEvNames[i];
            JSONArray arr = (JSONArray) evidencesInput.get(varName);
            for (int j = 0; j < arr.length(); j++) {
                String ev = arr.getString(j);
                RandomVariable var = dbn.getVaNamesMap().get(varName);
                aps[j][i] = new AssignmentProposition(var, Integer.parseInt(ev) == 0 ? Boolean.FALSE : Boolean.TRUE);
            }
        }

        ParticleFiltering pf = new ParticleFiltering(iterations, dbn.getDynamicBN());

        for (int i = 0; i < m; i++) {
            AssignmentProposition[][] S = pf.particleFiltering(aps[i]);
            System.out.println("Time " + (i + 1));
            printSamples(S, iterations);
        }
    }

    private static void printSamples(AssignmentProposition[][] S, int n) {
        HashMap<String, Integer> hm = new HashMap<>();

        int nstates = S[0].length;

        for (int i = 0; i < n; i++) {
            String key = "";
            for (int j = 0; j < nstates; j++) {
                AssignmentProposition ap = S[i][j];
                key += ap.getValue().toString();
            }
            Integer val = hm.get(key);
            if (val == null) {
                hm.put(key, 1);
            } else {
                hm.put(key, val + 1);
            }
        }

        // ordinamento alfabetico inverso
        List<String> sorted = new ArrayList<>(hm.keySet()).stream().sorted().collect(Collectors.toList());
        Collections.reverse(sorted);
        for (String key : sorted) {
            System.out.println(key + ": " + hm.get(key) / (double) n);
        }
    }
}