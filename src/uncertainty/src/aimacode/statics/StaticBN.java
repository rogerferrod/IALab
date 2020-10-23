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
        // Reading the experiment's JSON
        String jsonData = new String(Files.readAllBytes(Paths.get(args[2])));
        JSONObject obj = new JSONObject(jsonData);
        JSONObject experiment = (JSONObject) obj.get(args[3]);

        String configOrder = "";
        switch (args[0]) {
            case "topological":
                configOrder = EliminationAskStatic.TOPOLOGICAL;
                break;
            case "mindegree":
                configOrder = EliminationAskStatic.MIN_DEGREE;
                break;
            case "minfill":
                configOrder = EliminationAskStatic.MIN_FILL;
                break;
        }

        boolean configVerbose = Boolean.parseBoolean(args[1]);

        System.out.println("Actual configuration:");
        System.out.println("- Network: " + args[2]);
        System.out.println("- Ordering: " + configOrder);

        boolean configPruningTh1 = Boolean.parseBoolean(args[4]);
        boolean configPruningTh2 = Boolean.parseBoolean(args[5]);
        boolean configPruningPruningEdges = Boolean.parseBoolean(args[6]);

        String network = experiment.getString("network");
        String query = experiment.getString("query");
        String evidences = experiment.getString("evidences");

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

        // Pruning - DON'T change the parameters!!
        if (configPruningTh1 || configPruningTh2 || configPruningPruningEdges) {
            System.out.println("- Pruning:");
            NetworkPruning pruning = new NetworkPruning(bn, queryVariables, aps);
            if (configPruningTh1) {
                System.out.println("\t- Theorem 1");
                pruning.updateNetwork(pruning.theorem1(), false, false);
            }
            if (configPruningTh2) {
                System.out.println("\t- Theorem 2");
                pruning.updateNetwork(pruning.theorem2(), true, false);
            }
            if (configPruningPruningEdges) {
                System.out.println("\t- PruningEdges()");
                pruning.updateNetwork(pruning.pruningEdges(), false, true);
            }
            bn = pruning.getNetwork();
        }
        System.out.println(); // just for prettier output

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
