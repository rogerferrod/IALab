package exercises;/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import aima.core.probability.CategoricalDistribution;
import aima.core.probability.RandomVariable;
import aima.core.probability.bayes.approx.BayesSampleInference;
import aima.core.probability.bayes.BayesianNetwork;
import aima.core.probability.bayes.approx.LikelihoodWeighting;
import aima.core.probability.bayes.approx.RejectionSampling;
import aima.core.probability.proposition.AssignmentProposition;
import bnparser.BifReader;

import java.util.HashMap;
import java.util.List;

/**
 * @author torta
 */
public class Approx {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        HashMap<String, RandomVariable> rvsmap = new HashMap<>();
        BayesSampleInference rs = new RejectionSampling();
        BayesSampleInference lw = new LikelihoodWeighting();

        int N = Integer.parseInt(args[0]);
        BayesianNetwork bn = BifReader.readBIF("./networks/cow.xml");
        List<RandomVariable> rvs = bn.getVariablesInTopologicalOrder();
        for (RandomVariable rv : rvs) {
            rvsmap.put(rv.getName(), rv);
        }

        // caso 1: RS vs LW con blood=true
        System.out.println("Caso 1");
        RandomVariable[] qrv = new RandomVariable[2];
        qrv[0] = rvsmap.get("Pregnancy");
        qrv[1] = rvsmap.get("Progesterone");
        AssignmentProposition[] ap = new AssignmentProposition[1];
        ap[0] = new AssignmentProposition(rvsmap.get("Blood"), "P");

        doInference(qrv, ap, bn, rs, N);
        doInference(qrv, ap, bn, lw, N);

        // caso 2: RS vs LW con blood=true (evidenza poco probabile)
        System.out.println("Caso 2");
        ap[0] = new AssignmentProposition(rvsmap.get("Blood"), "N");

        doInference(qrv, ap, bn, rs, N);
        doInference(qrv, ap, bn, lw, N);

        // caso 3: LW progesterone dato pregnancy=true VS blood=true 
        // (evidenza "in alto" nell'ordine VS "in basso")
        System.out.println("Caso 3");
        qrv = new RandomVariable[1];
        qrv[0] = rvsmap.get("Progesterone");

        ap[0] = new AssignmentProposition(rvsmap.get("Pregnancy"), "True");
        doInference(qrv, ap, bn, lw, N);
        ap[0] = new AssignmentProposition(rvsmap.get("Blood"), "P");
        doInference(qrv, ap, bn, lw, N);
    }

    private static void doInference(RandomVariable[] qrv, AssignmentProposition[] ap,
                                    BayesianNetwork bn, BayesSampleInference bi, int N) {
        CategoricalDistribution cd = bi.ask(qrv, ap, bn, N);
        System.out.println("Inference " + bi.getClass().getSimpleName());

        System.out.print("<");
        for (int i = 0; i < cd.getValues().length; i++) {
            System.out.print(cd.getValues()[i]);
            if (i < (cd.getValues().length - 1)) {
                System.out.print(", ");
            } else {
                System.out.println(">");
            }
        }

        return;
    }
}