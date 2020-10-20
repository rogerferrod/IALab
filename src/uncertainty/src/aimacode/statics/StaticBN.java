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
        args = new String[4];
        args[0] = EliminationAskStatic.TOPOLOGICAL;
        //args[0] = EliminationAskStatic.MIN_DEGREE;
        //args[0] = EliminationAskStatic.MIN_FILL;

        args[1] = "false";
        //args[2] = "./input/static/BNexperiments.json";
        args[2] = "./input/static/E0_baseline.json";

        //args[3] = "asia_00";
        //args[3] = "cow_01";
        //args[3] = "cow_02";
        //args[3] = "earthquake_00";
        //args[3] = "sachs_00";
        //args[3] = "survey_00";
        //args[3] = "alarm_00";
        //args[3] = "insurance_00";
        //args[3] = "insurance_01";
        //args[3] = "win95pts_00";
        //args[3] = "link_00";
        //args[3] = "andes_00"; //TODO troppo grossa??
        //args[3] = "munin_full_00";

//        args[3] = "earthquake_00"; // OK
//        args[3] = "asia_00"; // OK
//        args[3] = "sachs_00"; // OK
//        args[3] = "mildew_00";
//        args[3] = "win95pts_00"; // OK
//        args[3] = "pathfinder_00";
//        args[3] = "water_00";
//        args[3] = "munin_full_00"; // OK
        args[3] = "pigs_00";
//        args[3] = "andes_00"; //TODO troppo grossa??
//        args[3] = "link_00";

        String jsonData = new String(Files.readAllBytes(Paths.get(args[2])));
        JSONObject obj = new JSONObject(jsonData);
        JSONObject experiment = (JSONObject) obj.get(args[3]);

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

        // Attention: It only work with the VA's first letter to uppercase!
        RandomVariable[] queryVariables = queryInput.stream().map(vaNames::get).toArray(RandomVariable[]::new);
        AssignmentProposition[] aps = assignements.stream()
                .map(x -> new AssignmentProposition(vaNames.get(x[0]), x[1])).toArray(AssignmentProposition[]::new);

        NetworkPruning pruning = new NetworkPruning(bn, queryVariables, aps);
        pruning.updateNetwork(pruning.theorem1(), false, false);
        pruning.updateNetwork(pruning.theorem2(), true, false);
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
