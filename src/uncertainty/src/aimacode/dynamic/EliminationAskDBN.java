package aimacode.dynamic;

import java.util.*;
import java.util.stream.Collectors;

import aima.core.probability.CategoricalDistribution;
import aima.core.probability.Factor;
import aima.core.probability.RandomVariable;
import aima.core.probability.bayes.BayesianNetwork;
import aima.core.probability.bayes.FiniteNode;
import aima.core.probability.bayes.Node;
import aima.core.probability.proposition.AssignmentProposition;
import aima.core.probability.util.ProbabilityTable;

public class EliminationAskDBN {
    private static final ProbabilityTable _identity = new ProbabilityTable(new double[]{1.0});

    public EliminationAskDBN() {

    }

    public CategoricalDistribution eliminationAsk(final RandomVariable[] X,
                                                  final AssignmentProposition[] e,
                                                  final BayesianNetwork bn,
                                                  ProbabilityTable oldTable,
                                                  Map<RandomVariable, RandomVariable> X1_to_X0,
                                                  Map<Integer, ArrayList<RandomVariable>> variablesOverTime) {

        Set<RandomVariable> hidden = new HashSet<>();
        List<RandomVariable> vars = new ArrayList<>();
        calculateVariables(X, e, bn, hidden, vars); //update hidden and vars

        List<Factor> factors = new ArrayList<>();
        ArrayList<RandomVariable> newVariables = new ArrayList<>();
        for (RandomVariable rv : oldTable.getArgumentVariables()) {
            newVariables.add(X1_to_X0.get(rv)); // X1 -> X0
        }
        ProbabilityTable tempTable = new ProbabilityTable(oldTable.getValues(), newVariables.toArray(new RandomVariable[newVariables.size()]));
        System.out.println("\toldTable= " + tempTable + " " + tempTable.getArgumentVariables());

        factors.add(0, tempTable);

        for (RandomVariable var : vars) { // foreach variable
            if (!variablesOverTime.get(0).contains(var)) {
                factors.add(0, makeFactor(var, e, bn));
            }
        }

        System.out.println("\toldFactor=" + factors);

        for (int i : variablesOverTime.keySet()) {
            for (RandomVariable var : variablesOverTime.get(i)) {
                if (i == 0 || (i == 1 && hidden.contains(var))) {
                    System.out.println("\tsumOut(" + var + ")");
                    List<Factor> toSumOut = factors.stream()
                            .filter(x -> x.contains(var)).collect(Collectors.toList());
                    factors.removeAll(toSumOut);
                    factors.addAll(sumOut(var, toSumOut, bn));
                }

            }
        }

        Factor product = pointwiseProduct(factors);
        System.out.println("\tnewFactor=" + factors);
        ProbabilityTable newTable = ((ProbabilityTable) product.pointwiseProductPOS(_identity, X)).normalize();
        System.out.println("\tnewTable= " + newTable + " " + newTable.getArgumentVariables());
        return newTable;
    }

    /*
     *
     * Original Code
     *
     */
    public CategoricalDistribution ask(final RandomVariable[] X,
                                       final AssignmentProposition[] observedEvidence,
                                       final BayesianNetwork bn,
                                       ProbabilityTable oldFact, Map<RandomVariable, RandomVariable> x_1Tox_0,
                                       Map<Integer, ArrayList<RandomVariable>> timeStepToRv) {
        return this.eliminationAsk(X, observedEvidence, bn, oldFact, x_1Tox_0, timeStepToRv);
    }

    protected void calculateVariables(final RandomVariable[] X,
                                      final AssignmentProposition[] e, final BayesianNetwork bn,
                                      Set<RandomVariable> hidden, Collection<RandomVariable> bnVARS) {

        bnVARS.addAll(bn.getVariablesInTopologicalOrder());
        hidden.addAll(bnVARS);

        for (RandomVariable x : X) {
            hidden.remove(x);
        }
        for (AssignmentProposition ap : e) {
            hidden.removeAll(ap.getScope());
        }

        return;
    }

    protected List<RandomVariable> order(BayesianNetwork bn,
                                         Collection<RandomVariable> vars) {
        // Note: Trivial Approach:
        // For simplicity just return in the reverse order received,
        // i.e. received will be the default topological order for
        // the Bayesian Network and we want to ensure the network
        // is iterated from bottom up to ensure when hidden variables
        // are come across all the factors dependent on them have
        // been seen so far.
        List<RandomVariable> order = new ArrayList<RandomVariable>(vars);
        Collections.reverse(order);

        return order;
    }


    private Factor makeFactor(RandomVariable var, AssignmentProposition[] e,
                              BayesianNetwork bn) {

        Node n = bn.getNode(var);
        if (!(n instanceof FiniteNode)) {
            throw new IllegalArgumentException(
                    "Elimination-Ask only works with finite Nodes.");
        }
        FiniteNode fn = (FiniteNode) n;
        List<AssignmentProposition> evidence = new ArrayList<AssignmentProposition>();
        for (AssignmentProposition ap : e) {
            if (fn.getCPT().contains(ap.getTermVariable())) {
                evidence.add(ap);
            }
        }

        return fn.getCPT().getFactorFor(
                evidence.toArray(new AssignmentProposition[evidence.size()]));
    }

    private List<Factor> sumOut(RandomVariable var, List<Factor> factors,
                                BayesianNetwork bn) {
        List<Factor> summedOutFactors = new ArrayList<Factor>();
        List<Factor> toMultiply = new ArrayList<Factor>();
        for (Factor f : factors) {
            if (f.contains(var)) {
                toMultiply.add(f);
            } else {
                // This factor does not contain the variable
                // so no need to sum out - see AIMA3e pg. 527.
                summedOutFactors.add(f);
            }
        }

        summedOutFactors.add(pointwiseProduct(toMultiply).sumOut(var));

        return summedOutFactors;
    }

    private Factor pointwiseProduct(List<Factor> factors) {

        Factor product = factors.get(0);
        for (int i = 1; i < factors.size(); i++) {
            product = product.pointwiseProduct(factors.get(i));
        }

        return product;
    }
}