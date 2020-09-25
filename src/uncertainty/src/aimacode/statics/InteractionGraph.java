package aimacode.statics;

import aima.core.probability.RandomVariable;
import aima.core.probability.bayes.Node;

import java.util.*;

/**
 * Implementazione di un grafo di interazione
 * Non potendo modificare a proprio piacere la rete bayesiana,
 * simuliamo l'eliminazione di nodo tramite l'insieme "deleted".
 */
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
        int minNeighbours = Integer.MAX_VALUE;
        RandomVariable actualMin = null;

        for (RandomVariable var : adj.keySet()) {
            if (deleted.contains(var)) {
                continue;
            }

            int neighbours = getNeighbours(var).size();
            if (neighbours < minNeighbours) {
                minNeighbours = neighbours;
                actualMin = var;
            }
        }

        return actualMin;
    }

    public RandomVariable findMinFillVariable() {
        int minEdges = Integer.MAX_VALUE;
        RandomVariable actualMin = null;

        for (RandomVariable var : adj.keySet()) {
            if (deleted.contains(var)) {
                continue;
            }

            int edges = countUpdatedEdges(var);
            if (edges < minEdges) {
                minEdges = edges;
                actualMin = var;
            }
        }

        return actualMin;
    }

    public void delete(RandomVariable var) {
        deleted.add(var);
    }

    public void updateEdges(RandomVariable var) {
        for (RandomVariable r1 : adj.get(var)) {
            if (deleted.contains(r1)) {
                continue;
            }

            for (RandomVariable r2 : adj.get(var)) {
                if (deleted.contains(r2)) {
                    continue;
                }

                // non occorre verificare la presenza di duplicati in quando
                // il grafo è modellato con insiemi anzichè liste di adiacenza
                adj.computeIfAbsent(r1, k -> new HashSet<>());
                adj.get(r1).add(r2);

                adj.computeIfAbsent(r2, k -> new HashSet<>());
                adj.get(r2).add(r1);
            }
        }
    }

    private int countUpdatedEdges(RandomVariable var) {
        int counter = 0;
        for (RandomVariable r1 : adj.get(var)) {
            if (deleted.contains(r1)) {
                continue;
            }

            for (RandomVariable r2 : adj.get(var)) {
                if (deleted.contains(r2)) {
                    continue;
                }

                if (adj.get(r1) != null && !adj.get(r1).contains(r2)) {
                    counter++;
                }
                if (adj.get(r2) != null && !adj.get(r2).contains(r1)) {
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

