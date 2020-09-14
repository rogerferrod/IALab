package aimacode;

import aima.core.probability.CategoricalDistribution;
import aima.core.probability.RandomVariable;
import aima.core.probability.bayes.*;
import aima.core.probability.bayes.exact.EliminationAsk;
import aima.core.probability.bayes.impl.BayesNet;
import aima.core.probability.proposition.AssignmentProposition;
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

    private BayesianNetwork netFromVariables(List<RandomVariable> variables) {
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

                Node[] parentArray = new Node[newParents.size()];
                //FiniteNode newNode = new MyCPTNode(var, cpt, newParents.toArray(new Node[newParents.size()]))
                FiniteNode newNode = new MyCPTNode(var, cpt, newParents.toArray(parentArray));
                newNodes.add(newNode);
                if (node.isRoot()) {
                    roots.add(newNode);
                }
            }
        }

        Node[] rootNodes = new Node[roots.size()];
        return new BayesNet(roots.toArray(rootNodes));
    }

    public void pruningNode() {
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

        bn = netFromVariables(filtered);
    }

    public static void main(String[] args) {
        HashMap<String, RandomVariable> vaNamesMap = new HashMap<>();

        BayesianNetwork bn = BifReader.readBIF("./networks/cow.xml");
        for (RandomVariable va : bn.getVariablesInTopologicalOrder()) {
            vaNamesMap.put(va.getName(), va);
        }

        RandomVariable[] queryVariables = {vaNamesMap.get("Pregnancy"), vaNamesMap.get("Progesterone")};
        AssignmentProposition[] evidences = {new AssignmentProposition(vaNamesMap.get("Blood"), "P")};

        Prunning prunning = new Prunning(queryVariables, evidences, bn);
        prunning.pruningNode();

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
