package aimacode.statics;

import aima.core.probability.RandomVariable;
import aima.core.probability.bayes.BayesianNetwork;
import aima.core.probability.bayes.Node;
import aima.core.probability.bayes.exact.EliminationAsk;
import aima.core.probability.bayes.impl.BayesNet;

import java.util.*;
import java.util.stream.Collectors;

public class EliminationAskBN extends EliminationAsk {

    final private String ordering;

    public EliminationAskBN(String ordering) {
        this.ordering = ordering;
    }

    @Override
    protected List<RandomVariable> order(BayesianNetwork bn, Collection<RandomVariable> vars) {
        if (ordering.equals("topological")) {
            List<RandomVariable> order = new ArrayList<>(vars);
            Collections.reverse(order);
            return order;
        }

        BayesNet network = (BayesNet) bn;
        List<RandomVariable> variables = network.getVariablesInTopologicalOrder();
        List<RandomVariable> ordered = new ArrayList<>();
        Set<Node> nodes = variables.stream().map(bn::getNode).collect(Collectors.toSet());
        int size = variables.size();
        InteractionGraph interGraph = new InteractionGraph(nodes);

        switch (ordering) {
            case "mindegree":
                for (int i = 0; i < size; i++) {
                    RandomVariable var = interGraph.findMinDegreeVariable();
                    interGraph.updateEdges(var);
                    interGraph.delete(var);
                    ordered.add(var);
                }
                break;
            case "minfill":
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

