package aimacode.statics;

import java.util.*;

import aima.core.probability.RandomVariable;
import aima.core.probability.bayes.Node;

public class InteractionGraph {

    private final Map<RandomVariable, Set<RandomVariable>> adj;
    private final Set<RandomVariable> deleted;

    public InteractionGraph(Set<Node> nodes) {
        this.adj = new HashMap<>();
        this.deleted = new HashSet<>();
        for (Node node : nodes) {
            adj.put(node.getRandomVariable(), new HashSet<>(node.getCPD().getFor()));
        }
    }

    public RandomVariable findMinDegreeVariable() {
        RandomVariable actualMin = null;
        int minNumber = Integer.MAX_VALUE;

        for (RandomVariable var : adj.keySet()) {
            if (deleted.contains(var)) {
                continue;
            }

            int neighbours = getNeighbours(var).size();
            if (neighbours < minNumber) {
                minNumber = neighbours;
                actualMin = var;
            }
        }

        return actualMin;
    }

    public RandomVariable findMinFillVariable() {
        RandomVariable actualMin = null;
        int minNumber = Integer.MAX_VALUE;

        for (RandomVariable var : adj.keySet()) {
            if (deleted.contains(var)) {
                continue;
            }

            int edges = countUpdatedEdges(var);
            if (edges < minNumber) {
                minNumber = edges;
                actualMin = var;
            }
        }

        return actualMin;
    }

    public void delete(RandomVariable var) {
        deleted.add(var);
    }


    public void updateEdges(RandomVariable var) {
        for (RandomVariable n1 : adj.get(var)) {
            if (deleted.contains(n1)) {
                continue;
            }

            for (RandomVariable n2 : adj.get(var)) {
                if (deleted.contains(n2)) {
                    continue;
                }

                // se già presente verrà ignorato dal set
                adj.computeIfAbsent(n1, k -> new HashSet<>());
                adj.get(n1).add(n2);

                adj.computeIfAbsent(n2, k -> new HashSet<>());
                adj.get(n2).add(n1);
            }
        }
    }

    private int countUpdatedEdges(RandomVariable var) {
        int counter = 0;
        for (RandomVariable n1 : adj.get(var)) {
            if (deleted.contains(n1)) {
                continue;
            }

            for (RandomVariable n2 : adj.get(var)) {
                if (deleted.contains(n2)) {
                    continue;
                }

                if (adj.get(n1) != null && !adj.get(n1).contains(n2)) {
                    counter++;
                }
                if (adj.get(n2) != null && !adj.get(n2).contains(n1)) {
                    counter++;
                }
            }
        }

        return counter;
    }

    private Set<RandomVariable> getNeighbours(RandomVariable var) {
        Set<RandomVariable> neighbours = adj.get(var);
        neighbours.removeAll(deleted);
        return neighbours;
    }

}

