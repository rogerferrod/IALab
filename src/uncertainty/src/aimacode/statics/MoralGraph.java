package aimacode.statics;

import aima.core.probability.RandomVariable;
import aima.core.probability.bayes.BayesianNetwork;
import aima.core.probability.bayes.Node;

import java.util.*;

/**
 * Implementazione del grafo morale, derivabile dalla rete bayesiana
 * eliminando la direzionalità e accoppiando tutti i padri
 */
public class MoralGraph {
    private final HashMap<RandomVariable, Set<RandomVariable>> adjacencySet;

    public MoralGraph(BayesianNetwork bn) {
        this.adjacencySet = new HashMap<>();
        List<RandomVariable> vars = bn.getVariablesInTopologicalOrder();
        for (RandomVariable var : vars) {
            addVertex(var);
            for (Node node : bn.getNode(var).getMarkovBlanket()) {
                RandomVariable nodeVar = node.getRandomVariable();
                if (!var.equals(nodeVar)) {
                    addVertex(nodeVar);
                    addEdge(var, nodeVar);
                }
            }
        }
    }

    public int size() {
        return this.adjacencySet.keySet().size();
    }

    public void addVertex(RandomVariable v) {
        if (!this.adjacencySet.containsKey(v)) {
            this.adjacencySet.put(v, new HashSet<>());
        }
    }

    public void removeVertex(RandomVariable v) {
        if (this.adjacencySet.containsKey(v)) {
            this.adjacencySet.remove(v);
            for (RandomVariable u : this.getAllVertices()) {
                this.adjacencySet.get(u).remove(v);
            }
        }
    }

    public void addEdge(RandomVariable v, RandomVariable u) {
        if (this.adjacencySet.containsKey(v) && this.adjacencySet.containsKey(u)) {
            this.adjacencySet.get(v).add(u);
            this.adjacencySet.get(u).add(v);
        }
    }

    public void removeEdge(RandomVariable v, RandomVariable u) {
        if (this.adjacencySet.containsKey(v) && this.adjacencySet.containsKey(u)) {
            this.adjacencySet.get(v).remove(u);
            this.adjacencySet.get(u).remove(v);
        }
    }

    public Iterable<RandomVariable> getAllVertices() {
        return this.adjacencySet.keySet();
    }

    /**
     * Depth First Seach per cercare ogni possibile percorso tra 2 nodi
     */
    public List<List<RandomVariable>> getAllPaths(RandomVariable s, RandomVariable d) {
        Map<RandomVariable, Boolean> isVisited = new HashMap<>();
        List<RandomVariable> local = new ArrayList<>();
        List<List<RandomVariable>> paths = new ArrayList<>();
        local.add(s);
        getAllPathsAUX(s, d, isVisited, local, paths);
        return paths;
    }

    private void getAllPathsAUX(RandomVariable u, RandomVariable d,
                                Map<RandomVariable, Boolean> isVisited, List<RandomVariable> local, List<List<RandomVariable>> paths) {

        if (!adjacencySet.containsKey(u) || !adjacencySet.containsKey(d)) {
            return;
        }

        if (u.equals(d)) {
            paths.add(new ArrayList<>(local));
            return;
        }

        isVisited.put(u, true);

        for (RandomVariable var : adjacencySet.get(u)) {
            if (!isVisited.containsKey(var) || !isVisited.get(var)) {
                local.add(var);
                getAllPathsAUX(var, d, isVisited, local, paths);
                local.remove(var);
            }
        }

        isVisited.put(u, false);
    }
}

