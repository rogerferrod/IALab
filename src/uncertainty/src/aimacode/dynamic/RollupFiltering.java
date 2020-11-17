package aimacode.dynamic;

import aima.core.probability.CategoricalDistribution;
import aima.core.probability.Factor;
import aima.core.probability.RandomVariable;
import aima.core.probability.bayes.BayesianNetwork;
import aima.core.probability.proposition.AssignmentProposition;
import aima.core.probability.util.ProbabilityTable;
import aimacode.statics.EliminationAskStatic;

import java.util.*;


public class RollupFiltering {
    private final Map<Integer, AssignmentProposition[]> evidenceOverTime;
    private final BayesianNetwork network;
    private final RandomVariable[] queryVariables;
    private final Map<RandomVariable, RandomVariable> X1_to_X0;
    private final String ordering;
    private final boolean verbose;

    public RollupFiltering(WrapDynamicBayesNet dbn,
                           RandomVariable[] query,
                           Map<Integer, AssignmentProposition[]> evidencesOverTime,
                           String ordering,
                           boolean verbose) {

        this.network = dbn.getStaticBN();
        this.queryVariables = query;
        this.evidenceOverTime = evidencesOverTime;
        this.X1_to_X0 = dbn.getX1_to_X0();
        this.ordering = ordering;
        this.verbose = verbose;
    }

    public CategoricalDistribution rollup() {
        // slice 0 - 1
        List<Factor> factors = new ArrayList<>();
        ProbabilityTable previousTable = (ProbabilityTable) new EliminationAskStatic(ordering, verbose)
                .ask(queryVariables, evidenceOverTime.get(1), network);
        System.out.println("Time 1 [slice 0-1]: " + previousTable + "\n");
        factors.add(previousTable);

        // altre slices
        for (int i = 2; i < evidenceOverTime.size(); i++) {
            factors = new EliminationAskDynamic(ordering, verbose)
                    .ask(queryVariables, evidenceOverTime.get(i), network, X1_to_X0, factors);
            System.out.println("Time " + i + " [slice " + (i - 1) + "-" + i + "]: " + factors + "\n");
        }

        return new EliminationAskDynamic(ordering, verbose).createTable(queryVariables, factors);
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

