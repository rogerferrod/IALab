package exercises;/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import aima.core.probability.CategoricalDistribution;
import aima.core.probability.RandomVariable;
import aima.core.probability.bayes.BayesInference;
import aima.core.probability.bayes.BayesianNetwork;
import aima.core.probability.bayes.exact.EliminationAsk;
import aima.core.probability.proposition.AssignmentProposition;
import bnparser.BifReader;

import java.util.HashMap;
import java.util.List;

/**
 * @author torta
 */
public class CQ {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        HashMap<String, RandomVariable> rvsmap = new HashMap<>();

        BayesianNetwork bn = BifReader.readBIF("./networks/cow.xml");
        List<RandomVariable> rvs = bn.getVariablesInTopologicalOrder();
        for (RandomVariable rv : rvs) {
            System.out.println(rv.getName());
            rvsmap.put(rv.getName(), rv);
        }

        RandomVariable[] qrv = new RandomVariable[2];
        qrv[0] = rvsmap.get("Pregnancy");
        qrv[1] = rvsmap.get("Progesterone");
        AssignmentProposition[] ap = new AssignmentProposition[1];
        ap[0] = new AssignmentProposition(rvsmap.get("Blood"), "P");

        BayesInference bi = new EliminationAsk();

        CategoricalDistribution cd = bi.ask(qrv, ap, bn);

        System.out.print("<");
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