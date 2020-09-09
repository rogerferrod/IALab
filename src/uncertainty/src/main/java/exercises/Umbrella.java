/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package exercises;

import aima.core.probability.CategoricalDistribution;
import aima.core.probability.example.*;
import aima.core.probability.hmm.HiddenMarkovModel;
import aima.core.probability.hmm.exact.HMMForwardBackward;
import aima.core.probability.proposition.AssignmentProposition;
import aima.core.probability.util.ProbabilityTable;

import java.util.ArrayList;
import java.util.List;

/**
 * @author torta
 */
public class Umbrella {
    public static void main(String[] args) {
        // numero di predizioni da fare
        int n = Integer.parseInt(args[0]);

        // crea AP (con indici 0...m-1) per evidenza a tempo 1...m
        int m = args.length - 1;
        AssignmentProposition[] aps = null;
        if (m > 0) {
            aps = new AssignmentProposition[m];
            for (int i = 0; i < m; i++) {
                aps[i] = new AssignmentProposition(ExampleRV.UMBREALLA_t_RV,
                        Integer.parseInt(args[i + 1]) == 0 ? Boolean.FALSE : Boolean.TRUE);
            }
        }

        HMMForwardBackward hmmfb = new HMMForwardBackward(HMMExampleFactory.getUmbrellaWorldModel());

        CategoricalDistribution f = new ProbabilityTable(new double[]{
                0.5, 0.5}, ExampleRV.RAIN_t_RV);

        for (int i = 0; i < m; i++) {
            List<AssignmentProposition> e = new ArrayList<AssignmentProposition>();
            e.add(aps[i]);
            f = hmmfb.forward(f, e);
        }

        System.out.println("P(X" + m + "|e1:" + m + ")");
        printCD(f);

        HMMPredict hmmp = new HMMPredict(HMMExampleFactory.getUmbrellaWorldModel());

        for (int i = 0; i < n; i++) {
            f = hmmp.predict(f);
        }

        System.out.println("P(X" + (m + n) + "|e1:" + m + ")");
        printCD(f);

    }

    private static void printCD(CategoricalDistribution cd) {
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
