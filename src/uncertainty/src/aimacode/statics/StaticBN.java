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
        String jsonData = new String(Files.readAllBytes(Paths.get(args[2])));
        JSONObject obj = new JSONObject(jsonData);
        JSONObject experiment = (JSONObject) obj.get(args[3]);

        boolean pruning1 = Boolean.parseBoolean(args[4]);
        boolean pruning2 = Boolean.parseBoolean(args[5]);
        boolean pruning3 = Boolean.parseBoolean(args[6]);

        String network = experiment.getString("network");
        String query = experiment.getString("query");
        String evidences = experiment.getString("evidences");

        List<String> queryInput = Arrays.stream(query.split(",")).collect(Collectors.toList());
        List<String> evidencesInput = Arrays.stream(evidences.split(",")).collect(Collectors.toList());
        List<String[]> assignements = new ArrayList<>();
        for (String assignement : evidencesInput) {
            String[] splits = assignement.split("=");
            if (!splits[0].equals("")) {
                assignements.add(splits);
            }
        }

        HashMap<String, RandomVariable> vaNames = new HashMap<>();
        BayesianNetwork bn = BifReader.readBIF(network);
        for (RandomVariable va : bn.getVariablesInTopologicalOrder()) {
            vaNames.put(va.getName(), va);
        }

        RandomVariable[] queryVariables = queryInput.stream().map(vaNames::get).toArray(RandomVariable[]::new);
        AssignmentProposition[] aps = assignements.stream()
                .map(x -> new AssignmentProposition(vaNames.get(x[0]), x[1])).toArray(AssignmentProposition[]::new);

        NetworkPruning pruning = new NetworkPruning(bn, queryVariables, aps);
        if (pruning1)
            pruning.updateNetwork(pruning.theorem1(), false, false);
        if (pruning2)
            pruning.updateNetwork(pruning.theorem2(), true, false);
        if (pruning3)
            pruning.updateNetwork(pruning.pruningEdges(), false, true);
        bn = pruning.getNetwork();

        BayesInference inference = new EliminationAskStatic(args[0], Boolean.parseBoolean(args[1]));

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
