package aimacode.dynamic;

import aima.core.probability.RandomVariable;
import aima.core.probability.bayes.BayesianNetwork;
import aima.core.probability.bayes.FiniteNode;
import aima.core.probability.bayes.impl.BayesNet;

import java.util.HashMap;
import java.util.Map;

public class MyDynamicBayesNetwork {
    private final BayesianNetwork staticBN;
    private final FiniteNode[] priorNodes;
    private final FiniteNode[] tNodes;
    private final HashMap<String, RandomVariable> vaNamesMap;
    private final Map<RandomVariable, RandomVariable> X1_to_X0;

    public MyDynamicBayesNetwork(FiniteNode[] priorNodes, FiniteNode[] tNodes, HashMap<String, RandomVariable> vaNamesMap, Map<RandomVariable, RandomVariable> X1_to_X0) {
        this.priorNodes = priorNodes;
        this.tNodes = tNodes;
        this.vaNamesMap = vaNamesMap;
        this.staticBN = new BayesNet(priorNodes);
        this.X1_to_X0 = X1_to_X0;
    }

    public BayesianNetwork getStaticBN() {
        return staticBN;
    }

    public FiniteNode[] getPriorNodes() {
        return priorNodes;
    }

    public FiniteNode[] gettNodes() {
        return tNodes;
    }

    public HashMap<String, RandomVariable> getVaNamesMap() {
        return vaNamesMap;
    }

    public Map<RandomVariable, RandomVariable> getX1_to_X0() {
        return X1_to_X0;
    }
}
