package aimacode.dynamic;

import aima.core.probability.RandomVariable;
import aima.core.probability.bayes.BayesianNetwork;
import aima.core.probability.bayes.FiniteNode;
import aima.core.probability.bayes.Node;
import aima.core.probability.proposition.AssignmentProposition;

import java.util.*;
import java.util.stream.Collectors;

public class DynamicBN {
    public static void main(String[] args) {

        args = new String[1];
        //args[0] = "topological";
        args[0] = "mindegree";
        //args[0] = "minfill";

        NetworkFactory factory = new NetworkFactory();
        //MyDynamicBayesNetwork dbn = factory.umbrellaNetwork();
        MyDynamicBayesNetwork dbn = factory.windNetwork();
        BayesianNetwork network = dbn.getStaticBN();

        String[] argsEv = new String[]{"1", "0", "1", "0", "1"};
        int m = argsEv.length;
        ArrayList<String> evNames = new ArrayList<>(Arrays.asList("Umbrella_t"));

        Map<Integer, AssignmentProposition[]> evidencesOverTime = new LinkedHashMap<>(); //t : evidences(t)
        Map<Integer, ArrayList<RandomVariable>> variablesOverTime = new LinkedHashMap<>(); //t : va(t)
        RandomVariable[] query = Arrays.stream(dbn.getVariables()).filter(x -> !evNames.contains(x.getName())).toArray(RandomVariable[]::new);

        for (String varName : evNames) {
            RandomVariable var = dbn.getVaNamesMap().get(varName);
            evidencesOverTime.put(0, null);
            for (int i = 1; i <= m; i++) {
                AssignmentProposition as = new AssignmentProposition(var, Integer.parseInt(argsEv[i - 1]) == 0 ? Boolean.FALSE : Boolean.TRUE);
                evidencesOverTime.put(i, new AssignmentProposition[]{as});
            }
        }

        ArrayList<FiniteNode> priorNodes = new ArrayList<>(Arrays.asList(Arrays.stream(dbn.getPriorNodes()).filter(x -> !evNames.contains(x.getRandomVariable().getName())).toArray(FiniteNode[]::new)));
        variablesOverTime.put(0, new ArrayList<>(priorNodes.stream().map(Node::getRandomVariable).collect(Collectors.toList())));

        RollupFiltering filtering = new RollupFiltering(evidencesOverTime, variablesOverTime, network, query, dbn.getX1_to_X0(), args[0]);
        System.out.println(filtering);

        System.out.println("\nFinal distribution " + filtering.rollup() + "\n");
    }
}
