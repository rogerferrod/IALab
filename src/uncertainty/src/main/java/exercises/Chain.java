package exercises;/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import aima.core.probability.*;
import aima.core.probability.proposition.AssignmentProposition;
import aima.core.probability.bayes.*;
import aima.core.probability.bayes.impl.*;
import aima.core.probability.domain.*;
import aima.core.probability.util.*;

/**
 * @author torta
 */
public class Chain {
    public static void main(String[] args) {
        int n = Integer.parseInt(args[0]);

        System.out.println("Creo chain di " + n + " nodi");
        RandomVariable[] allrv = new RandomVariable[n];

        for (int i = 0; i < n; i++) {
            allrv[i] = new RandVar("X" + (i + 1), new BooleanDomain());
        }

        FiniteNode fn = new FullCPTNode(allrv[0], new double[]{0.5, 0.5});
        FiniteNode fn0 = fn;
        for (int i = 1; i < n; i++) {
            fn = new FullCPTNode(allrv[i], new double[]{0.5, 0.5, 0.5, 0.5}, fn);
        }
        BayesianNetwork bn = new BayesNet(fn0);

        System.out.println("Creo query variable e evidenza Xn=true");
        RandomVariable[] qrv = new RandomVariable[1];
        qrv[0] = allrv[0];
        AssignmentProposition[] ap = new AssignmentProposition[1];
        ap[0] = new AssignmentProposition(allrv[n - 1], Boolean.TRUE);

        CategoricalDistribution cd;
        //BayesInference[] allbi = new BayesInference[] {new EnumerationAsk(), new EliminationAsk(), new exercises.MyEliminationAsk()};
        BayesInference[] allbi = new BayesInference[]{new MyEliminationAsk()};

        for (BayesInference bi : allbi) {
            System.out.println("Simple query con " + bi.getClass());
            cd = bi.ask(qrv, ap, bn);
            System.out.print("P(X0|xn) = <");
            for (int i = 0; i < cd.getValues().length; i++) {
                System.out.print(cd.getValues()[i]);
                if (i < (cd.getValues().length - 1)) {
                    System.out.print(", ");
                } else {
                    System.out.println(">");
                }
            }
        }
    }

}