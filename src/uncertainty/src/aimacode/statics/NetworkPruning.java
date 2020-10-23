package aimacode.statics;

import aima.core.probability.RandomVariable;
import aima.core.probability.bayes.*;
import aima.core.probability.bayes.impl.BayesNet;
import aima.core.probability.proposition.AssignmentProposition;

import java.util.*;
import java.util.stream.Collectors;

/**
 * Implementa diversi metodi per semplificare la rete bayesiana
 */
public class NetworkPruning {
    private final AssignmentProposition[] evidences;
    private final List<RandomVariable> queryVariablesList;
    private final List<RandomVariable> evidenceVariablesList;
    private BayesianNetwork bn;

    public NetworkPruning(BayesianNetwork bn, RandomVariable[] queryVariables, AssignmentProposition[] evidences) {
        this.bn = bn;
        this.queryVariablesList = new ArrayList<>(Arrays.asList(queryVariables));
        this.evidences = evidences;
        this.evidenceVariablesList = new ArrayList<>();
        for (AssignmentProposition ev : evidences) {
            this.evidenceVariablesList.add(ev.getTermVariable());
        }
    }

    public BayesianNetwork getNetwork() {
        return bn;
    }

    /**
     * Genera una nuova rete bayesiana a partire da una lista di variabili rilevanti
     *
     * @param variables   variabili rilevanti
     * @param modifyCPT   true se l'operazione richiede la modifica delle CPT (teorema 2)
     * @param removeEdges true se l'operazione richiede la rimozione degli archi (pruning edges)
     */
    public void updateNetwork(List<RandomVariable> variables, boolean modifyCPT, boolean removeEdges) {
        if (!removeEdges && variables.size() == bn.getVariablesInTopologicalOrder().size()) {
            return;
        }

        List<Node> roots = new ArrayList<>();
        List<RandomVariable> originalVariables = bn.getVariablesInTopologicalOrder();
        List<Node> newNodes = new ArrayList<>();
        for (RandomVariable var : originalVariables) {
            if (variables.contains(var)) {
                Node node = bn.getNode(var);
                CPTNode fn = (CPTNode) node;
                Set<Node> originalParents = node.getParents();
                double[] cpt = fn.getCPTDistribution();

                List<RandomVariable> parentFiltered = originalParents.stream()
                        .map(Node::getRandomVariable)
                        .filter(variables::contains)
                        .collect(Collectors.toList());

                // genera nuovi padri mantenendo, rispetto alla rete originale, solo quelli rilevanti
                List<Node> newParents = new ArrayList<>();
                for (RandomVariable pVar : parentFiltered) {
                    for (Node p : newNodes) {
                        if (p.getRandomVariable().equals(pVar)) {
                            newParents.add(p);
                        }
                    }
                }

                if (modifyCPT) {
                    // se ho eliminato dei nodi padri, allora modifico la CPT del figlio
                    if (originalParents.size() != newParents.size()) {
                        if (evidenceVariablesList.contains(var)) {
                            AssignmentProposition evidence = null;
                            for (AssignmentProposition ap : evidences) {
                                if (ap.getTermVariable().equals(var)) {
                                    evidence = ap;
                                }
                            }

                            // aggiorna l'assegnazione della VA secondo il reale valore dettato dall'evidenza
                            String domain = var.getDomain().toString();
                            String[] values = domain.substring(1, domain.length() - 1).split(",");
                            String evidenceVal = (String) evidence.getValue();
                            cpt = new double[values.length];
                            for (int i = 0; i < values.length; i++) {
                                cpt[i] = values[i].trim().equals(evidenceVal) ? 1.0 : 0.0;
                            }
                        }
                    }
                }
                if (removeEdges) {
                    newParents = newParents.stream().filter(x -> !evidenceVariablesList.contains(x.getRandomVariable())).collect(Collectors.toList());
                    Set<RandomVariable> originalParentVars = originalParents.stream()
                            .map(Node::getRandomVariable).collect(Collectors.toSet());

                    for (RandomVariable parentVar : originalParentVars) {
                        AssignmentProposition evidence = null;
                        for (AssignmentProposition ap : evidences) {
                            if (ap.getTermVariable().equals(parentVar)) {
                                evidence = ap;
                            }
                        }
                        if (evidence != null) {
                            // costruisce un nuovo fattore con le VA che non sono parte dell'evidenza
                            cpt = fn.getCPT().getFactorFor(evidence).getValues();
                        }
                    }
                }

                // crea il nuovo nodo
                Node[] parentArray = new Node[newParents.size()];
                FiniteNode newNode = new CPTNode(var, cpt, newParents.toArray(parentArray));
                newNodes.add(newNode);
                if (newParents.size() == 0) {
                    roots.add(newNode);
                }
            }
        }

        // crea una nuova rete
        Node[] rootNodes = new Node[roots.size()];
        bn = new BayesNet(roots.toArray(rootNodes));
    }

    /**
     * Un nodo X è irrilevante, a meno che non appartenga ad ancestors({Q} U {E})
     *
     * @return lista di nodi rilevandi (i.e. da mantenere)
     */
    public List<RandomVariable> theorem1() {
        Set<RandomVariable> ancestors = new HashSet<>();

        for (RandomVariable var : queryVariablesList) {
            ancestors.addAll(getAncestors(var));
        }
        for (RandomVariable var : evidenceVariablesList) {
            ancestors.addAll(getAncestors(var));
        }

        List<RandomVariable> nodes = bn.getVariablesInTopologicalOrder();
        return nodes.stream()
                .filter(x -> ancestors.contains(x) || queryVariablesList.contains(x) || evidenceVariablesList.contains(x))
                .collect(Collectors.toList());
    }

    /**
     * Un nodo è irrilevante se è m-separato, tramite E, da Q
     *
     * @return lista di nodi rilevandi (i.e. da mantenere)
     */
    public List<RandomVariable> theorem2() {
        MoralGraph moralGraph = new MoralGraph(bn);

        // rimuovendo le evidenze dal grafo morale, sarà sufficiente verificare se esiste un path
        // che collega il nodo ai nodi della query
        for (RandomVariable e : evidenceVariablesList) {
            moralGraph.removeVertex(e);
        }

        List<RandomVariable> variables = bn.getVariablesInTopologicalOrder();
        List<RandomVariable> filtered = new ArrayList<>(evidenceVariablesList);
        for (RandomVariable variable : variables) {
            boolean separated = true;
            for (int x = 0; x < queryVariablesList.size() && separated; x++) {
                separated = moralGraph.getAllPaths(variable, queryVariablesList.get(x)).size() == 0;
            }
            if (!separated) {
                filtered.add(variable);
            }
        }

        return filtered;
    }

    /**
     * Un arco è irrilevante se è generato da un nodo di evidenza,
     * la sua rimozione comporta la modifica dei nodi coinvolti
     *
     * @return lista di nodi rilevandi (i.e. da mantenere)
     */
    public List<RandomVariable> pruningEdges() {
        return bn.getVariablesInTopologicalOrder();
    }

    private Set<RandomVariable> getAncestors(RandomVariable var) {
        Node node = this.bn.getNode(var);
        if (node == null) {
            throw new RuntimeException("Node not found");
        }
        Set<RandomVariable> ancestors = new HashSet<>();
        for (Node parent : node.getParents()) {
            ancestors.add(parent.getRandomVariable());
            ancestors.addAll(getAncestors(parent.getRandomVariable()));
        }
        return ancestors;
    }
}