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
        NetworkFactory factory = new NetworkFactory();
        MyDynamicBayesNetwork dbn = factory.umbrellaNetwork();
        BayesianNetwork network = dbn.getStaticBN();

        args = new String[]{"1", "0", "1", "0", "1"};
        int m = args.length;
        String evName = "Umbrella_t";
        String qrName = "Rain_t";

        Map<Integer, AssignmentProposition[]> evidencesOverTime = new LinkedHashMap<>(); //t : evidences(t)
        Map<Integer, ArrayList<RandomVariable>> variablesOverTime = new LinkedHashMap<>(); //t : va(t)
        RandomVariable[] query = dbn.getStaticBN().getVariablesInTopologicalOrder().stream().filter(x -> x.getName().equals(qrName)).toArray(RandomVariable[]::new);

        RandomVariable var = dbn.getVaNamesMap().get(evName);
        evidencesOverTime.put(0, null);
        for (int i = 1; i <= m; i++) {
            AssignmentProposition as = new AssignmentProposition(var, Integer.parseInt(args[i - 1]) == 0 ? Boolean.FALSE : Boolean.TRUE);
            evidencesOverTime.put(i, new AssignmentProposition[]{as});
        }

        ArrayList<FiniteNode> priorNodes = new ArrayList<>(Arrays.asList(Arrays.stream(dbn.getPriorNodes()).filter(x -> !x.getRandomVariable().getName().equals(evName)).toArray(FiniteNode[]::new)));
        variablesOverTime.put(0, new ArrayList<>(priorNodes.stream().map(Node::getRandomVariable).collect(Collectors.toList())));

        RollupFiltering filtering = new RollupFiltering(evidencesOverTime, variablesOverTime, network, query, dbn.getX1_to_X0());
        System.out.println(filtering);

        System.out.println("\nFinal distribution " + filtering.rollUp() + "\n");
    }
}
