package aimacode;

import aima.core.probability.CategoricalDistribution;
import aima.core.probability.RandomVariable;
import aima.core.probability.bayes.BayesInference;
import aima.core.probability.bayes.BayesianNetwork;
import aima.core.probability.bayes.exact.EliminationAsk;
import aima.core.probability.proposition.AssignmentProposition;
import aimacode.bnparser.BifReader;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.stream.Collectors;

public class StaticBN {
    public static void main(String[] args) {
        HashMap<String, RandomVariable> vaNamesMap = new HashMap<>();

        args = new String[3];
        /*args[0] = "./networks/cow.xml";
        args[1] = "Pregnancy,Progesterone";
        args[2] = "Blood=P";*/

        /*args[0] = "./networks/cow.xml";
        args[1] = "Pregnancy,Progesterone";
        args[2] = "Blood=P,Urine=P";*/

        args[0] = "./networks/earthquake.xml";
        args[1] = "JohnCalls";
        args[2] = "Alarm=True";

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
            vaNamesMap.put(va.getName(), va);
        }

        RandomVariable[] queryVariables = queryInput.stream().map(x -> vaNamesMap.get(x)).toArray(RandomVariable[]::new);
        AssignmentProposition[] evidences = assignements.stream()
                .map(x -> new AssignmentProposition(vaNamesMap.get(x[0]), x[1])).toArray(AssignmentProposition[]::new);


        SimplePruning simplePruning = new SimplePruning(queryVariables, evidences, bn);
        simplePruning.updateNetwork(simplePruning.theorem1(), false, false);
        simplePruning.updateNetwork(simplePruning.theorem2(), true, false);
        simplePruning.updateNetwork(simplePruning.pruningEdges(), false, true);

        bn = simplePruning.getNetwork();

        BayesInference inference = new EliminationAsk();

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

        //********************************************************************/
        /*
        EfficientPruning pruning = new EfficientPruning(queryVariables, evidences, bn);
        pruning.pruning();
        bn = simplePruning.getNetwork();

        start = System.currentTimeMillis();
        distribution = inference.ask(queryVariables, evidences, bn);
        finish = System.currentTimeMillis();
        timeElapsed = finish - start;

        System.out.print("P(" + args[1] + "|" + args[2] + ") = < ");
        values = distribution.getValues();
        for (int i = 0; i < values.length; i++) {
            System.out.print(distribution.getValues()[i] + " ");
        }
        System.out.println(">");
        System.out.println("Time elapsed " + timeElapsed + " milliseconds");
         */
    }
}
