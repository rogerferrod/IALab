package aimacode.statics;

import aima.core.probability.CategoricalDistribution;
import aima.core.probability.RandomVariable;
import aima.core.probability.bayes.BayesInference;
import aima.core.probability.bayes.BayesianNetwork;
import aima.core.probability.proposition.AssignmentProposition;
import aimacode.bnparser.BifReader;
import org.json.JSONObject;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;
import java.util.stream.Collectors;

public class StaticBN {

    public static void main(String[] args) throws IOException {
        args = new String[2];

        // Experiments configuration
        args[0] = "./input/static/E1_ordering.json"; // queries

        // Chosen network
        args[1] = "earthquake_00";
//        args[1] = "asia_00";
//        args[1] = "sachs_00";
//        args[1] = "alarm_00";
//        args[1] = "win95pts_00"; // LOOP
//        args[1] = "insurance_00";
//        args[1] = "munin_full_00"; // LOOP
//        args[1] = "pigs_00"; // Exception: Java Heap Space
//        args[1] = "andes_00"; // LOOP
//        args[1] = "link_00"; // LOOP

        // Reading the experiment's JSON
        String jsonData = new String(Files.readAllBytes(Paths.get(args[0])));
        JSONObject obj = new JSONObject(jsonData);

        // Reading the experiment configuration
        JSONObject config = (JSONObject) obj.get("config");

        String configOrder = "";
        switch (config.getString("order")) {
            case "TOPOLOGICAL":
                configOrder = EliminationAskStatic.TOPOLOGICAL;
                break;
            case "MIN_DEGREE":
                configOrder = EliminationAskStatic.MIN_DEGREE;
                break;
            case "MIN_FILL":
                configOrder = EliminationAskStatic.MIN_FILL;
                break;
        }

        System.out.println(configOrder);

        boolean configPruning = config.getBoolean("pruning");
        boolean configVerbose = config.getBoolean("verbose");

        JSONObject queries = (JSONObject) obj.get("queries");
        JSONObject chosenQuery = (JSONObject) queries.get(args[1]);

        String network = chosenQuery.getString("network");
        String query = chosenQuery.getString("query");
        String evidences = chosenQuery.getString("evidences");

        List<String> queryInput = Arrays.stream(query.split(",")).collect(Collectors.toList());
        List<String> evidencesInput = Arrays.stream(evidences.split(",")).collect(Collectors.toList());
        List<String[]> assignments = new ArrayList<>();
        for (String assignment : evidencesInput) {
            String[] splits = assignment.split("=");
            if (!splits[0].equals("")) {
                assignments.add(splits);
            }
        }

        HashMap<String, RandomVariable> vaNames = new HashMap<>();
        BayesianNetwork bn = BifReader.readBIF(network);
        for (RandomVariable va : bn.getVariablesInTopologicalOrder()) {
            vaNames.put(va.getName(), va);
        }

        // Attention: It only work with the VA's first letter to uppercase!
        RandomVariable[] queryVariables = queryInput.stream().map(vaNames::get).toArray(RandomVariable[]::new);
        AssignmentProposition[] aps = assignments.stream()
                .map(x -> new AssignmentProposition(vaNames.get(x[0]), x[1])).toArray(AssignmentProposition[]::new);

        if (configPruning) {
            NetworkPruning pruning = new NetworkPruning(bn, queryVariables, aps);
            pruning.updateNetwork(pruning.theorem1(), false, false);
            pruning.updateNetwork(pruning.theorem2(), true, false);
            pruning.updateNetwork(pruning.pruningEdges(), false, true);

            bn = pruning.getNetwork();
        }

        BayesInference inference = new EliminationAskStatic(configOrder, configVerbose);

        long start = System.currentTimeMillis();
        CategoricalDistribution distribution = inference.ask(queryVariables, aps, bn);
        long finish = System.currentTimeMillis();
        long timeElapsed = finish - start;

        System.out.print("P(" + query + "|" + evidences + ") = < ");
        double[] values = distribution.getValues();
        for (int i = 0; i < values.length; i++) {
            System.out.print(distribution.getValues()[i] + " ");
        }
        System.out.println(">");
        System.out.println("Time elapsed " + timeElapsed + " milliseconds");
    }
}
