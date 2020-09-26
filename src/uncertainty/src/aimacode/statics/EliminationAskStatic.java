package aimacode.statics;

import aima.core.probability.RandomVariable;
import aima.core.probability.bayes.BayesianNetwork;
import aima.core.probability.bayes.Node;
import aima.core.probability.bayes.exact.EliminationAsk;
import aima.core.probability.bayes.impl.BayesNet;

import java.util.*;
import java.util.stream.Collectors;

/**
 * Estensione della Variable Elimination con, in aggiunta, l'implementazione di diversi ordinamenti
 */
public class EliminationAskStatic extends EliminationAsk {
    final public static String TOPOLOGICAL = "topological";
    final public static String MIN_DEGREE = "mindegree";
    final public static String MIN_FILL = "minfill";

    final private String ordering;

    public EliminationAskStatic(String ordering) {
        this.ordering = ordering;
    }

    /**
     * Ordina una collezione di variabili secondo l'ordinamento specificato in "ordering"
     *
     * @param bn   Rete Bayesiana di appartenenza
     * @param vars Variabili da ordinare
     * @return varibili ordinate
     */
    @Override
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
}

