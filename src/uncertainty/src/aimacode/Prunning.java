package aimacode;

import aima.core.probability.CategoricalDistribution;
import aima.core.probability.Factor;
import aima.core.probability.RandomVariable;
import aima.core.probability.bayes.*;
import aima.core.probability.bayes.exact.EliminationAsk;
import aima.core.probability.bayes.impl.BayesNet;
import aima.core.probability.domain.Domain;
import aima.core.probability.proposition.AssignmentProposition;
import aima.core.probability.util.ProbUtil;
import aima.core.probability.util.RandVar;
import aimacode.bnparser.BifReader;

import java.util.*;
import java.util.stream.Collectors;

public class Prunning {

    private final RandomVariable[] queryVariables;
    private final AssignmentProposition[] evidences;
    private List<RandomVariable> queryVariablesList;
    private List<RandomVariable> evidenceVariablesList;
    private BayesianNetwork bn;

    public Prunning(RandomVariable[] queryVariables, AssignmentProposition[] evidences, BayesianNetwork bn) {
        this.queryVariables = queryVariables;
        this.evidences = evidences;
        this.bn = bn;
        this.queryVariablesList = new ArrayList<>(Arrays.asList(queryVariables));
        this.evidenceVariablesList = new ArrayList<>();
        for (AssignmentProposition ev : evidences) {
            this.evidenceVariablesList.add(ev.getTermVariable());
        }
    }

    public BayesianNetwork getNetwork() {
        return bn;
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

    private void updateNetwork(List<RandomVariable> variables, boolean modifyCPT, boolean removeEdges) {
        List<Node> roots = new ArrayList<>();
        List<RandomVariable> originalVariables = bn.getVariablesInTopologicalOrder();
        List<Node> newNodes = new ArrayList<>();
        for (RandomVariable var : originalVariables) {
            if (variables.contains(var)) {
                Node node = bn.getNode(var);
                MyCPTNode fn = (MyCPTNode) node;
                Set<Node> originalParents = node.getParents();
                double[] cpt = fn.getCPTDistribution();

                List<RandomVariable> filtered = originalParents.stream()
                        .map(Node::getRandomVariable)
                        .filter(variables::contains)
                        .collect(Collectors.toList());

                List<Node> newParents = new ArrayList<>();
                for (RandomVariable pVar : filtered) {
                    for (Node p : newNodes) {
                        if (p.getRandomVariable().equals(pVar)) {
                            newParents.add(p);
                        }
                    }
                }

                RandomVariable[] parentVars = newParents.stream()
                        .map(Node::getRandomVariable).toArray(RandomVariable[]::new);
                if (modifyCPT) {
                    if (cpt.length != ProbUtil.expectedSizeOfProbabilityTable(parentVars)) { // ho eliminato dei nodi padri
                        if (evidenceVariablesList.contains(var)) {
                            AssignmentProposition e = null;
                            for (AssignmentProposition ap : evidences) {
                                if (ap.getTermVariable().equals(var)) {
                                    e = ap;
                                }
                            }

                            Domain domain = var.getDomain();
                            String values = domain.toString();
                            String[] splits = values.substring(1, values.length() - 1).split(",");
                            String value = (String) e.getValue();
                            cpt = new double[splits.length];
                            for (int i = 0; i < splits.length; i++) {
                                cpt[i] = splits[i].equals(value) ? 1.0 : 0.0;
                            }
                        }
                    }
                }
                if (removeEdges) {
                    Set<RandomVariable> originalParentVars = originalParents.stream()
                            .map(Node::getRandomVariable).collect(Collectors.toSet());

                    for (RandomVariable parentVar : originalParentVars) {
                        AssignmentProposition e = null;
                        for (AssignmentProposition ap : evidences) {
                            if (ap.getTermVariable().equals(parentVar)) {
                                e = ap;
                            }
                        }
                        if (e != null) {
                            cpt = fn.getCPT().getFactorFor(e).getValues();
                        }
                    }
                }

                Node[] parentArray = new Node[newParents.size()];
                //FiniteNode newNode = new MyCPTNode(var, cpt, newParents.toArray(new Node[newParents.size()]))
                FiniteNode newNode = new MyCPTNode(var, cpt, newParents.toArray(parentArray));
                newNodes.add(newNode);
                /*if (node.isRoot()) {
                    roots.add(newNode);
                }*/
                if (newParents.size() == 0) {
                    roots.add(newNode);
                }
            }
        }

        Node[] rootNodes = new Node[roots.size()];
        bn = new BayesNet(roots.toArray(rootNodes));
    }

    private List<RandomVariable> theorem1() {
        Set<RandomVariable> ancestors = new HashSet<>();

        for (RandomVariable var : queryVariablesList) {
            ancestors.addAll(getAncestors(var));
        }
        for (RandomVariable var : evidenceVariablesList) {
            ancestors.addAll(getAncestors(var));
        }

        List<RandomVariable> nodes = bn.getVariablesInTopologicalOrder();
        List<RandomVariable> filtered = nodes.stream()
                .filter(x -> ancestors.contains(x) || queryVariablesList.contains(x) || evidenceVariablesList.contains(x))
                .collect(Collectors.toList()); //TODO sicuro di mantenere query?

        //bn = netFromVariables(filtered, false, false);
        return filtered;
    }

    private List<RandomVariable> theorem2() {
        MoralGraph moralGraph = new MoralGraph(bn);
        for (RandomVariable e : evidenceVariablesList) {
            moralGraph.removeVertex(e);
        }

        List<RandomVariable> bnVariables = bn.getVariablesInTopologicalOrder();
        List<RandomVariable> filtered = new ArrayList<>(evidenceVariablesList);
        for (RandomVariable bnVariable : bnVariables) {
            boolean separated = true;
            for (int x = 0; x < queryVariablesList.size() && separated; x++) {
                separated = moralGraph.getAllPaths(bnVariable, queryVariablesList.get(x)).size() == 0;
            }
            if (!separated) {
                filtered.add(bnVariable);
            }
        }

        //bn = netFromVariables(filtered, true, false);
        return filtered;
    }

    private List<RandomVariable> pruningEdges() {
        List<RandomVariable> filtered = bn.getVariablesInTopologicalOrder().stream()
                .filter(x -> !evidenceVariablesList.contains(x)).collect(Collectors.toList());

        //bn = netFromVariables(filtered, false, true);
        return filtered;
    }

    public void pruningNetwork() { //TODO not working
        Set<RandomVariable> filtered = new HashSet<>(theorem1());
        filtered.addAll(theorem2());
        filtered.addAll(pruningEdges());
        updateNetwork(new ArrayList<>(filtered), true, true);
    }

    public static void main(String[] args) {
        HashMap<String, RandomVariable> vaNamesMap = new HashMap<>();

        /*
        BayesianNetwork bn = BifReader.readBIF("./networks/cow.xml");
        for (RandomVariable va : bn.getVariablesInTopologicalOrder()) {
            vaNamesMap.put(va.getName(), va);
        }
        RandomVariable[] queryVariables = {vaNamesMap.get("Pregnancy"), vaNamesMap.get("Progesterone")};
        AssignmentProposition[] evidences = {new AssignmentProposition(vaNamesMap.get("Blood"), "P")};
         */

        BayesianNetwork bn = BifReader.readBIF("./networks/earthquake.xml");
        for (RandomVariable va : bn.getVariablesInTopologicalOrder()) {
            vaNamesMap.put(va.getName(), va);
        }
        RandomVariable[] queryVariables = {vaNamesMap.get("JohnCalls")};
        AssignmentProposition[] evidences = {new AssignmentProposition(vaNamesMap.get("Alarm"), "True")};

        Prunning prunning = new Prunning(queryVariables, evidences, bn);
        prunning.updateNetwork(prunning.theorem1(), false, false);
        prunning.updateNetwork(prunning.theorem2(), true, false);
        prunning.updateNetwork(prunning.pruningEdges(), false, true);

        //prunning.pruningNetwork();

        bn = prunning.getNetwork();

        BayesInference inference = new EliminationAsk();

        long start = System.currentTimeMillis();
        CategoricalDistribution distribution = inference.ask(queryVariables, evidences, bn);
        long finish = System.currentTimeMillis();
        long timeElapsed = finish - start;

        System.out.print("P(Pregnancy,Progesterone|Blood=P) = < ");
        double[] values = distribution.getValues();
        for (int i = 0; i < values.length; i++) {
            System.out.print(distribution.getValues()[i] + " ");
        }
        System.out.println(">");
        System.out.println("Time elapsed " + timeElapsed + " milliseconds");
    }
}