package aimacode.dynamic;

import aima.core.probability.RandomVariable;
import aima.core.probability.bayes.BayesianNetwork;
import aima.core.probability.bayes.FiniteNode;
import aima.core.probability.bayes.Node;
import aima.core.probability.bayes.impl.BayesNet;
import aima.core.probability.bayes.impl.DynamicBayesNet;

import java.util.*;

/**
 * Implementa una rete bayesiana dinamica rappresentandola come una serie (finita)
 * di reti bayesiane statiche
 */
public class WrapDynamicBayesNet {
    private final BayesianNetwork staticBN;
    private final DynamicBayesNet dbn;
    private final FiniteNode[] priorNodes;
    private final FiniteNode[] tNodes;
    private final HashMap<String, RandomVariable> vaNamesMap;
    private final Map<RandomVariable, RandomVariable> X1_to_X0;

    public WrapDynamicBayesNet(FiniteNode[] priorNodes, FiniteNode[] tNodes, HashMap<String, RandomVariable> vaNamesMap, Map<RandomVariable, RandomVariable> X1_to_X0, DynamicBayesNet dbn) {
        this.priorNodes = priorNodes;
        this.tNodes = tNodes;
        this.vaNamesMap = vaNamesMap;
        this.staticBN = new BayesNet(priorNodes);
        this.X1_to_X0 = X1_to_X0;
        this.dbn = dbn;
    }

    public BayesianNetwork getStaticBN() {
        return staticBN;
    }

    public FiniteNode[] getPriorNodes() {
        return priorNodes;
    }

    public DynamicBayesNet getDbn() {
        return dbn;
    }

    public RandomVariable[] getVariables() {
        return Arrays.stream(tNodes).map(Node::getRandomVariable).toArray(RandomVariable[]::new);
    }

    public HashMap<String, RandomVariable> getVaNamesMap() {
        return vaNamesMap;
    }

    public Map<RandomVariable, RandomVariable> getX1_to_X0() {
        return X1_to_X0;
    }
}
