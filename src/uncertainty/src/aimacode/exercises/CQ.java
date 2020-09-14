package aimacode.exercises;

import aima.core.probability.CategoricalDistribution;
import aima.core.probability.RandomVariable;
import aima.core.probability.bayes.BayesInference;
import aima.core.probability.bayes.BayesianNetwork;
import aima.core.probability.bayes.exact.EliminationAsk;
import aima.core.probability.proposition.AssignmentProposition;
import aimacode.bnparser.BifReader;

import java.util.HashMap;

/**
 * @author torta
 * @author Roger Ferrod
 * @author Pio Raffaele Fia
 * @author Lorenzo Tabasso
 * <p>
 * Il programma deve:
 * 1) creare la BN dell’esercizio su ArtificialInsemination
 * 2) inferire la distribuzione P(Pregnancy, Progesterone| blood) con il metodo per eliminazione di variabili
 */
public class CQ {

    public static void main(String[] args) {
        HashMap<String, RandomVariable> vaNamesMap = new HashMap<>();

        BayesianNetwork bn = BifReader.readBIF("./networks/cow.xml");
        for (RandomVariable va : bn.getVariablesInTopologicalOrder()) {
            vaNamesMap.put(va.getName(), va);
        }

        RandomVariable[] queryVariables = {vaNamesMap.get("Pregnancy"), vaNamesMap.get("Progesterone")};
        AssignmentProposition[] evidences = {new AssignmentProposition(vaNamesMap.get("Blood"), "P")};

        BayesInference inference = new EliminationAsk();

        long start = System.currentTimeMillis();
        CategoricalDistribution distribution = inference.ask(queryVariables, evidences, bn);
        long finish = System.currentTimeMillis();
        long timeElapsed = finish - start;

        System.out.print("P(Pregnancy,Progesterone|Blood=P) = < ");
        double[] values = distribution.getValues();
        for (int i = 0; i < values.length; i++) {
            System.out.print(distribution.getValues()[i] + " ");
        }
        System.out.println(">");
        System.out.println("Time elapsed " + timeElapsed + " milliseconds");
    }
}