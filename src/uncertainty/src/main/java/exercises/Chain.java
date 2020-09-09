package exercises;

import aima.core.probability.*;
import aima.core.probability.bayes.exact.EliminationAsk;
import aima.core.probability.bayes.exact.EnumerationAsk;
import aima.core.probability.proposition.AssignmentProposition;
import aima.core.probability.bayes.*;
import aima.core.probability.bayes.impl.*;
import aima.core.probability.domain.*;
import aima.core.probability.util.*;

import java.util.ArrayList;
import java.util.List;

/**
 * @author torta
 * @author Roger Ferrod
 * @author Pio Raffaele Fia
 * @author Lorenzo Tabasso
 * <p>
 * Il programma deve:
 * 1) ricevere in input un numero intero n
 * 2) creare una BN a "catena" con N nodi X1, …, Xn
 * 3) inferire la distribuzione P(X1 | xn) per enumerazione e eliminazione di variabili
 * 4) confrontare i tempi impiegati dai due metodi al crescere di n
 * 5) cambiare l’ordinamento delle variabili provando quello "pessimo"
 * 6) confrontare i tempi impiegati dai due metodi al crescere di n
 */
public class Chain {
    public static void main(String[] args) {
        int n = Integer.parseInt(args[0]);

        System.out.println("Chain with " + n + " nodes");
        List<RandomVariable> randomVariables = new ArrayList<>();

        for (int i = 0; i < n; i++) {
            randomVariables.add(new RandVar("X" + (i + 1), new BooleanDomain()));
        }

        // root node
        FiniteNode f0 = new FullCPTNode(randomVariables.get(0), new double[]{0.5, 0.5});
        FiniteNode fn = f0;
        // other nodes
        for (RandomVariable va : randomVariables.subList(1, randomVariables.size())) {
            fn = new FullCPTNode(va, new double[]{0.5, 0.5, 0.5, 0.5}, fn);
        }

        // Bayes network
        BayesianNetwork bn = new BayesNet(f0);

        // Inferferences
        System.out.println("Query variable X0\tEvidence Xn=true");
        RandomVariable[] queryVariables = {randomVariables.get(1)};
        AssignmentProposition[] evidences = {new AssignmentProposition(randomVariables.get(randomVariables.size() - 1),
                Boolean.TRUE)};

        CategoricalDistribution cd;
        BayesInference[] methods = new BayesInference[]{
                new EnumerationAsk(),
                new EliminationAsk(),
                new exercises.MyEliminationAsk()};

        for (BayesInference inference : methods) {
            System.out.println("\n\nSimple query with " + inference.getClass());
            long start = System.currentTimeMillis();
            cd = inference.ask(queryVariables, evidences, bn);
            long finish = System.currentTimeMillis();
            long timeElapsed = finish - start;

            System.out.print("P(X0|xn) = < ");
            double[] values = cd.getValues();
            for (int i = 0; i < values.length; i++) {
                System.out.print(cd.getValues()[i] + " ");
            }
            System.out.println(">");
            System.out.println("Time elapsed " + timeElapsed + " milliseconds");
        }
    }
}