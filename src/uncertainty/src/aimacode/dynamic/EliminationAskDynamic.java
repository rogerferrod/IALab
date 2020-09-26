package aimacode.dynamic;

import aima.core.probability.CategoricalDistribution;
import aima.core.probability.Factor;
import aima.core.probability.RandomVariable;
import aima.core.probability.bayes.BayesianNetwork;
import aima.core.probability.bayes.FiniteNode;
import aima.core.probability.bayes.Node;
import aima.core.probability.bayes.impl.BayesNet;
import aima.core.probability.proposition.AssignmentProposition;
import aima.core.probability.util.ProbabilityTable;
import aimacode.statics.InteractionGraph;

import java.util.*;
import java.util.stream.Collectors;

public class EliminationAskDynamic {
    final public static String TOPOLOGICAL = "topological";
    final public static String MIN_DEGREE = "mindegree";
    final public static String MIN_FILL = "minfill";

    private static final ProbabilityTable _identity = new ProbabilityTable(new double[]{1.0});
    private final String ordering;
    private final boolean verbose;

    public EliminationAskDynamic(String ordering, boolean verbose) {
        this.ordering = ordering;
        this.verbose = verbose;
    }

    public CategoricalDistribution ask(final RandomVariable[] X,
                                       final AssignmentProposition[] observedEvidence,
                                       final BayesianNetwork bn,
                                       Map<RandomVariable, RandomVariable> X1_to_X0,
                                       ProbabilityTable oldFactor) {
        return this.eliminationAsk(X, observedEvidence, bn, X1_to_X0, oldFactor);
    }


    public CategoricalDistribution eliminationAsk(final RandomVariable[] X,
                                                  final AssignmentProposition[] e,
                                                  final BayesianNetwork bn,
                                                  Map<RandomVariable, RandomVariable> X1_to_X0,
                                                  ProbabilityTable oldFactor) {

        Set<RandomVariable> hidden = new HashSet<>();
        List<RandomVariable> vars = new ArrayList<>();
        calculateVariables(X, e, bn, hidden, vars); // aggiorna hidden e vars

        ArrayList<RandomVariable> previousVar = new ArrayList<>();
        for (RandomVariable var : oldFactor.getArgumentVariables()) {
            previousVar.add(X1_to_X0.get(var)); // copia VA precedenti (t=0)
        }

        ProbabilityTable previousTable = new ProbabilityTable(oldFactor.getValues(), previousVar.toArray(new RandomVariable[previousVar.size()]));
        Set<RandomVariable> priorVariables = previousTable.getArgumentVariables();
        //TODO controllare con reti che generano più fattori

        // factors <- [old_factor]
        List<Factor> factors = new ArrayList<>();
        factors.add(0, previousTable);

        if (verbose)
            System.out.println("\tPreviousFactors=" + factorsToString(factors));

        for (RandomVariable var : order(bn, vars)) {
            if (!priorVariables.contains(var)) { // se t != 0 (già in factors)
                // factors <- [MAKE-FACTOR(var, e) | factors]
                factors.add(0, makeFactor(var, e, bn));
            }
        }

        if (verbose)
            System.out.println("\tTempFactors=" + factorsToString(factors));

        for (RandomVariable var : order(bn, hidden)) {
            List<Factor> toSumOut = factors.stream().filter(x -> x.contains(var)).collect(Collectors.toList());
            factors.removeAll(toSumOut);
            factors.addAll(sumOut(var, toSumOut, bn));
            if (verbose) {
                System.out.println("\tsumOut(" + var + ")");
                System.out.println("\tTempFactors=" + factorsToString(factors));
            }
        }

        Factor product = pointwiseProduct(factors);
        ProbabilityTable newTable = ((ProbabilityTable) product.pointwiseProductPOS(_identity, X)).normalize();
        if (verbose) {
            System.out.println("\tNewFactors=" + factorsToString(factors));
            System.out.println("\tnewTable" + newTable.getArgumentVariables() + " = " + newTable);
        }
        return newTable;
    }

    /**
     * Ordina una collezione di variabili secondo l'ordinamento specificato in "ordering"
     *
     * @param bn   Rete Bayesiana di appartenenza
     * @param vars Variabili da ordinare
     * @return varibili ordinate
     */
    protected List<RandomVariable> order(BayesianNetwork bn, Collection<RandomVariable> vars) {
        if (ordering.equals(TOPOLOGICAL)) {
            List<RandomVariable> order = new ArrayList<>(vars);
            Collections.reverse(order);
            return order;
        }

        BayesNet network = (BayesNet) bn;
        List<RandomVariable> variables = network.getVariablesInTopologicalOrder().stream()
                .filter(vars::contains).collect(Collectors.toList());
        List<RandomVariable> ordered = new ArrayList<>();
        Set<Node> nodes = variables.stream().map(bn::getNode).collect(Collectors.toSet());
        InteractionGraph interGraph = new InteractionGraph(nodes);
        int size = variables.size();

        switch (ordering) {
            case MIN_DEGREE:
                for (int i = 0; i < size; i++) {
                    RandomVariable var = interGraph.findMinDegreeVariable();
                    interGraph.updateEdges(var);
                    interGraph.delete(var);
                    ordered.add(var);
                }
                break;
            case MIN_FILL:
                for (int i = 0; i < size; i++) {
                    RandomVariable var = interGraph.findMinFillVariable();
                    interGraph.updateEdges(var);
                    interGraph.delete(var);
                    ordered.add(var);
                }
                break;
        }
        return ordered;
    }

    private String factorsToString(List<Factor> factors) {
        StringBuilder str = new StringBuilder();
        for (Factor f : factors) {
            str.append(f.getArgumentVariables().toString()).append(f).append("; ");
        }
        return str.toString();
    }

    /*
     *
     * Original Code
     *
     */

    protected void calculateVariables(final RandomVariable[] X,
                                      final AssignmentProposition[] e,
                                      final BayesianNetwork bn,
                                      Set<RandomVariable> hidden,
                                      Collection<RandomVariable> bnVARS) {

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