package aimacode.statics;

import aima.core.probability.RandomVariable;
import aima.core.probability.bayes.BayesianNetwork;
import aima.core.probability.bayes.Node;
import aima.core.probability.bayes.exact.EliminationAsk;
import aima.core.probability.bayes.impl.BayesNet;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

public class EliminationMinFill extends EliminationAsk {

    @Override
    protected List<RandomVariable> order(BayesianNetwork bn, Collection<RandomVariable> vars) {
        BayesNet network = (BayesNet) bn;
        List<RandomVariable> variables = network.getVariablesInTopologicalOrder();
        List<RandomVariable> ordered = new ArrayList<>();

        Set<Node> nodes = variables.stream().map(bn::getNode).collect(Collectors.toSet());

        int size = variables.size();
        InteractionGraph interGraph = new InteractionGraph(nodes);

        for (int i = 0; i < size; i++) {
            RandomVariable var = interGraph.findMinFillVariable();
            interGraph.updateEdges(var);
            interGraph.delete(var);
            ordered.add(var);
        }

        return ordered;
    }
}

