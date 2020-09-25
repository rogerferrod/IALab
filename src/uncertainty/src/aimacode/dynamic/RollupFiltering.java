package aimacode.dynamic;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Map;

import aima.core.probability.CategoricalDistribution;
import aima.core.probability.RandomVariable;
import aima.core.probability.bayes.BayesianNetwork;
import aima.core.probability.bayes.exact.EliminationAsk;
import aima.core.probability.proposition.AssignmentProposition;
import aima.core.probability.util.ProbabilityTable;

public class RollupFiltering {
    private final Map<Integer, AssignmentProposition[]> evidenceOverTime; //t : evidences(t)
    private final Map<Integer, ArrayList<RandomVariable>> variablesOverTime; //t : va(t)
    private final BayesianNetwork network;
    private final RandomVariable[] queryVariables;
    private final Map<RandomVariable, RandomVariable> X1_to_X0;
    private final String ordering;

    public RollupFiltering(Map<Integer, AssignmentProposition[]> evidences,
                           Map<Integer, ArrayList<RandomVariable>> timeStepToRv,
                           BayesianNetwork b, RandomVariable[] qRV,
                           Map<RandomVariable, RandomVariable> x_1Tox_0,
                           String ordering) {

        this.evidenceOverTime = evidences;
        this.variablesOverTime = timeStepToRv;
        this.network = b;
        this.queryVariables = qRV;
        this.X1_to_X0 = x_1Tox_0;
        this.ordering = ordering;
    }

    public CategoricalDistribution rollup() {
        // t = 1 (slice 0 - 1)
        ProbabilityTable previousTable = (ProbabilityTable) new EliminationAsk().ask(queryVariables, evidenceOverTime.get(1), network);

        // slices
        for (int i = 1; i < evidenceOverTime.size(); i++) {
            System.out.println("\nslice " + (i - 1) + "-" + i);
            previousTable = (ProbabilityTable) new EliminationAskDBN(ordering).ask(queryVariables,
                    evidenceOverTime.get(i), network,
                    previousTable, X1_to_X0, variablesOverTime);
            System.out.println("Distribution at step " + i + ": " + previousTable);
        }

        return previousTable;
    }

    @Override
    public String toString() {
        String[] queryStr = Arrays.stream(queryVariables).map(RandomVariable::getName).toArray(String[]::new);
        StringBuilder strProb = new StringBuilder("P(");
        for (String var : queryStr) {
            strProb.append(var).append(",");
        }
        strProb = new StringBuilder(strProb.substring(0, strProb.length() - 1) + " | ");

        String[] evidencesStr = Arrays.stream(evidenceOverTime.get(1)).map(x -> x.getTermVariable().toString()).toArray(String[]::new);
        for (String var : evidencesStr) {
            strProb.append(var).append(",");
        }
        strProb = new StringBuilder(strProb.substring(0, strProb.length() - 1) + ")");

        StringBuilder strTime = new StringBuilder();
        for (Map.Entry<Integer, AssignmentProposition[]> entry : evidenceOverTime.entrySet()) {
            AssignmentProposition[] as = entry.getValue();
            if (as != null) {
                strTime.append(entry.getKey()).append(" -> ");
                for (AssignmentProposition e : as) {
                    strTime.append(e.toString()).append(",");
                }
                strTime = new StringBuilder(strTime.substring(0, strTime.length() - 1) + "\n");
            }
        }
        return strProb + "\nObservations:\n" + strTime;
    }

}

