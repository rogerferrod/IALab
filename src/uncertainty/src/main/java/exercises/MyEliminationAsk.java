package exercises;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import aima.core.probability.CategoricalDistribution;
import aima.core.probability.Factor;
import aima.core.probability.RandomVariable;
import aima.core.probability.bayes.BayesianNetwork;
import aima.core.probability.bayes.FiniteNode;
import aima.core.probability.bayes.Node;
import aima.core.probability.bayes.exact.EliminationAsk;
import aima.core.probability.proposition.AssignmentProposition;
import aima.core.probability.util.ProbabilityTable;

/**
 * @author torta
 */
public class MyEliminationAsk extends EliminationAsk {
    private static final ProbabilityTable _identity = new ProbabilityTable(new double[]{1.0});

    @Override
    public CategoricalDistribution eliminationAsk(final RandomVariable[] X, final AssignmentProposition[] e,
                                                  final BayesianNetwork bn) {
        Set<RandomVariable> hidden = new HashSet<RandomVariable>();
        List<RandomVariable> VARS = new ArrayList<RandomVariable>();
        calculateVariables(X, e, bn, hidden, VARS);

        // factors <- []
        List<Factor> factors = new ArrayList<Factor>();
        // for each var in ORDER(bn.VARS) do
        for (int oidx = 0; oidx < order(bn, VARS).size(); oidx++) {
            RandomVariable var = order(bn, VARS).get(oidx);

            // int idx = Integer.parseInt(var.getName().substring(1));
            if (oidx % 2 == 0) {
                // factors <- [MAKE-FACTOR(var, e) | factors]
                factors.add(0, makeFactor(var, e, bn));
                if (oidx > 0) {
                    RandomVariable oddvar = order(bn, VARS).get(oidx - 1);
                    factors.add(0, makeFactor(oddvar, e, bn));
                }

                // if var is hidden variable then factors <- SUM-OUT(var,
                // factors)
                if (hidden.contains(var)) {
                    factors = sumOut(var, factors, bn);
                }
            }
        }
        for (int oidx = 0; oidx < order(bn, VARS).size(); oidx++) {
            RandomVariable var = order(bn, VARS).get(oidx);

            // int idx = Integer.parseInt(var.getName().substring(1));
            if (oidx % 2 == 1) {
                // factors.add(0, makeFactor(var, e, bn));

                // if var is hidden variable then factors <- SUM-OUT(var,
                // factors)
                if (hidden.contains(var)) {
                    factors = sumOut(var, factors, bn);
                }
            }
        }

        // return NORMALIZE(POINTWISE-PRODUCT(factors))
        Factor product = pointwiseProduct(factors);
        // Note: Want to ensure the order of the product matches the
        // query variables
        return ((ProbabilityTable) product.pointwiseProductPOS(_identity, X)).normalize();
    }

    public Factor makeFactor(RandomVariable var, AssignmentProposition[] e, BayesianNetwork bn) {

        Node n = bn.getNode(var);
        if (!(n instanceof FiniteNode)) {
            throw new IllegalArgumentException("Elimination-Ask only works with finite Nodes.");
        }
        FiniteNode fn = (FiniteNode) n;
        List<AssignmentProposition> evidence = new ArrayList<AssignmentProposition>();
        for (AssignmentProposition ap : e) {
            if (fn.getCPT().contains(ap.getTermVariable())) {
                evidence.add(ap);
            }
        }

        return fn.getCPT().getFactorFor(evidence.toArray(new AssignmentProposition[evidence.size()]));
    }

    public List<Factor> sumOut(RandomVariable var, List<Factor> factors, BayesianNetwork bn) {
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

    public Factor pointwiseProduct(List<Factor> factors) {

        Factor product = factors.get(0);
        for (int i = 1; i < factors.size(); i++) {
            product = product.pointwiseProduct(factors.get(i));
        }

        return product;
    }
}