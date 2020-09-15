package aimacode;

import java.util.*;

import aima.core.probability.RandomVariable;
import aima.core.probability.bayes.BayesianNetwork;
import aima.core.probability.bayes.Node;


public class MoralGraph {
    private HashMap<RandomVariable, Set<RandomVariable>> adjacencyList;

    public MoralGraph(BayesianNetwork bn) {
        this.adjacencyList = new HashMap<>();
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
        return this.adjacencyList.keySet().size();
    }

    public void addVertex(RandomVariable v) {
        if (!this.adjacencyList.containsKey(v)) {
            this.adjacencyList.put(v, new HashSet<>());
        }
    }

    public void removeVertex(RandomVariable v) {
        if (this.adjacencyList.containsKey(v)) {
            this.adjacencyList.remove(v);
            for (RandomVariable u : this.getAllVertices()) {
                this.adjacencyList.get(u).remove(v);
            }
        }
    }

    public void addEdge(RandomVariable v, RandomVariable u) {
        if (this.adjacencyList.containsKey(v) && this.adjacencyList.containsKey(u)) {
            this.adjacencyList.get(v).add(u);
            this.adjacencyList.get(u).add(v);
        }
    }

    public void removeEdge(RandomVariable v, RandomVariable u) {
        if (this.adjacencyList.containsKey(v) && this.adjacencyList.containsKey(u)) {
            this.adjacencyList.get(v).remove(u);
            this.adjacencyList.get(u).remove(v);
        }
    }

    public boolean isAdjacent(RandomVariable v, RandomVariable u) {
        return this.adjacencyList.get(v).contains(u);
    }

    public Iterable<RandomVariable> getNeighbors(RandomVariable v) {
        return this.adjacencyList.get(v);
    }

    public int getNeighborsNumber(RandomVariable v) {
        return this.adjacencyList.get(v).size();
    }

    public List<RandomVariable> getNeighborsList(RandomVariable v) {
        return new ArrayList<RandomVariable>(this.adjacencyList.get(v));
    }

    public Iterable<RandomVariable> getAllVertices() {
        return this.adjacencyList.keySet();
    }

    public boolean contains(RandomVariable rv) {
        return this.adjacencyList.containsKey(rv);
    }

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

        if (!adjacencyList.containsKey(u) || !adjacencyList.containsKey(d)) {
            return;
        }

        if (u.equals(d)) {
            paths.add(new ArrayList<>(local));
            return;
        }

        isVisited.put(u, true);

        for (RandomVariable var : adjacencyList.get(u)) {
            if (!isVisited.containsKey(var) || !isVisited.get(var)) {
                local.add(var);
                getAllPathsAUX(var, d, isVisited, local, paths);
                local.remove(var);
            }
        }

        isVisited.put(u, false);
    }
}

