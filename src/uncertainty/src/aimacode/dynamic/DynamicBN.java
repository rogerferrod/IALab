package aimacode.dynamic;

import aima.core.probability.RandomVariable;
import aima.core.probability.proposition.AssignmentProposition;

import java.util.*;

public class DynamicBN {
    public static void main(String[] args) {

        args = new String[2];
        //args[0] = EliminationAskDynamic.TOPOLOGICAL;
        args[0] = EliminationAskDynamic.MIN_DEGREE;
        //args[0] = EliminationAskDynamic.MIN_FILL;

        args[1] = "true";

        NetworkFactory factory = new NetworkFactory();
        //MyDynamicBayesNetwork dbn = factory.umbrellaNetwork();
        MyDynamicBayesNetwork dbn = factory.windNetwork();

        String[] argsEv = new String[]{"1", "0", "1", "0", "1"};
        int m = argsEv.length;
        ArrayList<String> evNames = new ArrayList<>(Arrays.asList("Umbrella_t"));

        Map<Integer, AssignmentProposition[]> evidencesOverTime = new LinkedHashMap<>(); //t : evidences(t)
        RandomVariable[] query = Arrays.stream(dbn.getVariables())
                .filter(x -> !evNames.contains(x.getName())).toArray(RandomVariable[]::new);

        for (String varName : evNames) {
            RandomVariable var = dbn.getVaNamesMap().get(varName);
            evidencesOverTime.put(0, null);
            for (int i = 1; i <= m; i++) {
                AssignmentProposition as = new AssignmentProposition(var,
                        Integer.parseInt(argsEv[i - 1]) == 0 ? Boolean.FALSE : Boolean.TRUE);
                evidencesOverTime.put(i, new AssignmentProposition[]{as});
            }
        }

        RollupFiltering filtering = new RollupFiltering(dbn, query, evidencesOverTime, args[0], Boolean.parseBoolean(args[1]));
        System.out.println(filtering);

        System.out.println("\nFinal distribution " + filtering.rollup() + "\n");
    }
}
