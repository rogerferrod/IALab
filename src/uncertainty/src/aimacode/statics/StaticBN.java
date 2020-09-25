package aimacode.statics;

import aima.core.probability.CategoricalDistribution;
import aima.core.probability.RandomVariable;
import aima.core.probability.bayes.BayesInference;
import aima.core.probability.bayes.BayesianNetwork;
import aima.core.probability.proposition.AssignmentProposition;
import aimacode.bnparser.BifReader;

import java.util.*;
import java.util.stream.Collectors;

public class StaticBN {
    public static void main(String[] args) {
        HashMap<String, RandomVariable> vaNames = new HashMap<>(); // name : va

        args = new String[4];

        //args[3] = EliminationAskBN.TOPOLOGICAL;
        args[3] = EliminationAskStatic.MIN_DEGREE;
        //args[3] = EliminationAskBN.MIN_FILL;

        /*args[0] = "./networks/cow.xml";
        args[1] = "Pregnancy,Progesterone";
        args[2] = "Blood=P";*/

        args[0] = "./networks/cow.xml";
        args[1] = "Pregnancy,Progesterone";
        args[2] = "Blood=P,Urine=P";

        /*args[0] = "./networks/earthquake.xml";
        args[1] = "JohnCalls";
        args[2] = "Alarm=True";*/

        /*args[0] = "./networks/survey.xml";
        args[1] = "S";
        args[2] = "T=Car";*/

        /*args[0] = "./networks/alarm.xml";
        args[1] = "MINVOLSET";
        args[2] = "VENTTUBE=LOW";*/

        /*args[0] = "./networks/munin.xml";
        args[1] = "DIFFN_DISTR";
        args[2] = "DIFFN_M_SEV_DIST=NO";*/

        /*args[0] = "./networks/link.xml";
        args[1] = "Z_2_a_f";
        args[2] = "D0_10_d_p=A";*/

        /*args[0] = "./networks/win95pts.xml";
        args[1] = "PrtCbl";
        args[2] = "TnrSpply=Low";*/

        List<String> queryInput = Arrays.stream(args[1].split(",")).collect(Collectors.toList());
        List<String> evidencesInput = Arrays.stream(args[2].split(",")).collect(Collectors.toList());
        List<String[]> assignements = new ArrayList<>();
        for (String assignement : evidencesInput) {
            String[] splits = assignement.split("=");
            assignements.add(splits);
        }

        BayesianNetwork bn = BifReader.readBIF(args[0]);
        for (RandomVariable va : bn.getVariablesInTopologicalOrder()) {
            vaNames.put(va.getName(), va);
        }

        RandomVariable[] queryVariables = queryInput.stream().map(vaNames::get).toArray(RandomVariable[]::new);
        AssignmentProposition[] evidences = assignements.stream()
                .map(x -> new AssignmentProposition(vaNames.get(x[0]), x[1])).toArray(AssignmentProposition[]::new);

        NetworkPruning pruning = new NetworkPruning(bn, queryVariables, evidences);
        pruning.updateNetwork(pruning.theorem1(), false, false);
        pruning.updateNetwork(pruning.theorem2(), true, false);
        pruning.updateNetwork(pruning.pruningEdges(), false, true);

        bn = pruning.getNetwork();

        BayesInference inference = new EliminationAskStatic(args[3]);

        long start = System.currentTimeMillis();
        CategoricalDistribution distribution = inference.ask(queryVariables, evidences, bn);
        long finish = System.currentTimeMillis();
        long timeElapsed = finish - start;

        System.out.print("P(" + args[1] + "|" + args[2] + ") = < ");
        double[] values = distribution.getValues();
        for (int i = 0; i < values.length; i++) {
            System.out.print(distribution.getValues()[i] + " ");
        }
        System.out.println(">");
        System.out.println("Time elapsed " + timeElapsed + " milliseconds");
    }
}
