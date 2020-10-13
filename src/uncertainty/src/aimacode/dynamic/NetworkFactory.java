package aimacode.dynamic;

import aima.core.probability.RandomVariable;
import aima.core.probability.bayes.BayesianNetwork;
import aima.core.probability.bayes.FiniteNode;
import aima.core.probability.bayes.Node;
import aima.core.probability.bayes.impl.BayesNet;
import aima.core.probability.bayes.impl.DynamicBayesNet;
import aima.core.probability.bayes.impl.FullCPTNode;
import aima.core.probability.domain.BooleanDomain;
import aima.core.probability.util.RandVar;
import aimacode.statics.CPTNode;
import org.apache.commons.lang3.ArrayUtils;

import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;
import java.util.Random;

public class NetworkFactory {
    public final static String UMBRELLA = "umbrella";
    public final static String WIND = "wind";
    public final static String TWOFACTORS = "twofactors";
    private final Random generator = new Random(42);

    public WrapDynamicBayesNet getNetwork(String net) {
        switch (net) {
            case UMBRELLA:
                return umbrellaNetwork();
            case WIND:
                return windNetwork();
            case TWOFACTORS:
                return twoFactors();
            default:
                return null;
        }
    }

    public WrapDynamicBayesNet getNetwork(BayesianNetwork bn, Map<String, List<String>> mapping, Set<String> evNames) {
        return getRandomNetwork(bn, mapping, evNames);
    }

    private WrapDynamicBayesNet umbrellaNetwork() {
        HashMap<String, RandomVariable> vaNamesMap = new HashMap<>();
        Map<RandomVariable, RandomVariable> X1_to_X0 = new LinkedHashMap<>();
        Map<RandomVariable, RandomVariable> X0_to_X1 = new LinkedHashMap<>();

        RandVar priorRainVar = new RandVar("Rain_0", new BooleanDomain());
        FiniteNode priorRain = new FullCPTNode(priorRainVar, new double[]{0.5, 0.5});
        vaNamesMap.put("Rain_0", priorRainVar);

        BayesNet priorNetwork = new BayesNet(priorRain); // importante che sia qui: non deve ancora avere figli

        RandVar tRainVar = new RandVar("Rain_t", new BooleanDomain());
        FiniteNode tRain = new FullCPTNode(tRainVar, new double[]{0.7, 0.3, 0.3, 0.7}, priorRain);
        vaNamesMap.put("Rain_t", tRainVar);

        RandVar tUmbrellaVar = new RandVar("Umbrella_t", new BooleanDomain());
        FiniteNode tUmbrella = new FullCPTNode(tUmbrellaVar, new double[]{0.9, 0.1, 0.2, 0.8}, tRain);
        vaNamesMap.put("Umbrella_t", tUmbrellaVar);

        X1_to_X0.put(tRainVar, priorRainVar);
        X0_to_X1.put(priorRainVar, tRainVar);

        Set<RandomVariable> E_1 = new HashSet<>();
        E_1.add(tUmbrellaVar);
        DynamicBayesNet dbn = new DynamicBayesNet(priorNetwork, X0_to_X1, E_1, priorRain);

        return new WrapDynamicBayesNet(new FiniteNode[]{priorRain}, new FiniteNode[]{tRain, tUmbrella}, vaNamesMap, X1_to_X0, dbn);
    }

    private WrapDynamicBayesNet windNetwork() {
        HashMap<String, RandomVariable> vaNamesMap = new HashMap<>();
        Map<RandomVariable, RandomVariable> X1_to_X0 = new LinkedHashMap<>();
        Map<RandomVariable, RandomVariable> X0_to_X1 = new LinkedHashMap<>();

        RandVar priorRainVar = new RandVar("Rain_0", new BooleanDomain());
        FiniteNode priorRain = new FullCPTNode(priorRainVar, new double[]{0.5, 0.5});
        vaNamesMap.put("Rain_0", priorRainVar);

        RandVar priorWindVar = new RandVar("Wind_0", new BooleanDomain());
        FiniteNode priorWind = new FullCPTNode(priorWindVar, new double[]{0.5, 0.5});
        vaNamesMap.put("Wind_0", priorWindVar);

        BayesNet priorNetwork = new BayesNet(priorRain, priorWind);

        RandVar tRainVar = new RandVar("Rain_t", new BooleanDomain());
        FiniteNode tRain = new FullCPTNode(tRainVar, new double[]{0.6, 0.4, 0.8, 0.2, 0.4, 0.6, 0.2, 0.8}, priorRain, priorWind);
        vaNamesMap.put("Rain_t", tRainVar);

        RandVar tWindVar = new RandVar("Wind_t", new BooleanDomain());
        FiniteNode tWind = new FullCPTNode(tWindVar, new double[]{0.7, 0.3, 0.3, 0.7}, priorWind);
        vaNamesMap.put("Wind_t", tWindVar);

        RandVar tUmbrellaVar = new RandVar("Umbrella_t", new BooleanDomain());
        FiniteNode tUmbrella = new FullCPTNode(tUmbrellaVar, new double[]{0.9, 0.1, 0.2, 0.8}, tRain);
        vaNamesMap.put("Umbrella_t", tUmbrellaVar);

        X1_to_X0.put(tRainVar, priorRainVar);
        X1_to_X0.put(tWindVar, priorWindVar);
        X0_to_X1.put(priorRainVar, tRainVar);
        X0_to_X1.put(priorWindVar, tWindVar);

        Set<RandomVariable> E_1 = new HashSet<>();
        E_1.add(tUmbrellaVar);
        DynamicBayesNet dbn = new DynamicBayesNet(priorNetwork, X0_to_X1, E_1, priorRain, priorWind);

        return new WrapDynamicBayesNet(new FiniteNode[]{priorRain, priorWind}, new FiniteNode[]{tRain, tWind, tUmbrella}, vaNamesMap, X1_to_X0, dbn);
    }

    private WrapDynamicBayesNet twoFactors() {
        HashMap<String, RandomVariable> vaNamesMap = new HashMap<>();
        Map<RandomVariable, RandomVariable> X1_to_X0 = new LinkedHashMap<>();
        Map<RandomVariable, RandomVariable> X0_to_X1 = new LinkedHashMap<>();

        RandVar priorZVar = new RandVar("Z_0", new BooleanDomain());
        FiniteNode priorZ = new FullCPTNode(priorZVar, new double[]{0.5, 0.5});
        vaNamesMap.put("Z_0", priorZVar);

        RandVar priorXVar = new RandVar("X_0", new BooleanDomain());
        FiniteNode priorX = new FullCPTNode(priorXVar, new double[]{0.5, 0.5});
        vaNamesMap.put("X_0", priorXVar);

        RandVar priorYVar = new RandVar("Y_0", new BooleanDomain());
        FiniteNode priorY = new FullCPTNode(priorYVar, new double[]{0.5, 0.5});
        vaNamesMap.put("Y_0", priorYVar);

        BayesNet priorNetwork = new BayesNet(priorX, priorY, priorZ);

        RandVar tZVar = new RandVar("Z_t", new BooleanDomain());
        FiniteNode tZ = new FullCPTNode(tZVar, new double[]{0.7, 0.3, 0.3, 0.7}, priorZ);
        vaNamesMap.put("Z_t", tZVar);

        RandVar tGVar = new RandVar("G_t", new BooleanDomain());
        FiniteNode tG = new FullCPTNode(tGVar, new double[]{0.9, 0.1, 0.2, 0.8}, tZ);
        vaNamesMap.put("G_t", tGVar);

        RandVar tXVar = new RandVar("X_t", new BooleanDomain());
        FiniteNode tX = new FullCPTNode(tXVar, new double[]{0.6, 0.4, 0.8, 0.2, 0.4, 0.6, 0.2, 0.8}, priorX, priorY);
        vaNamesMap.put("X_t", tXVar);

        RandVar tYVar = new RandVar("Y_t", new BooleanDomain());
        FiniteNode tY = new FullCPTNode(tYVar, new double[]{0.7, 0.3, 0.3, 0.7}, priorY);
        vaNamesMap.put("Y_t", tYVar);

        RandVar tEVar = new RandVar("E_t", new BooleanDomain());
        FiniteNode tE = new FullCPTNode(tEVar, new double[]{0.9, 0.1, 0.2, 0.8}, tX);
        vaNamesMap.put("E_t", tEVar);

        RandVar tFVar = new RandVar("F_t", new BooleanDomain());
        FiniteNode tF = new FullCPTNode(tFVar, new double[]{0.9, 0.1, 0.2, 0.8}, tY);
        vaNamesMap.put("F_t", tFVar);

        X1_to_X0.put(tXVar, priorXVar);
        X1_to_X0.put(tYVar, priorYVar);
        X1_to_X0.put(tZVar, priorZVar);
        X0_to_X1.put(priorXVar, tXVar);
        X0_to_X1.put(priorYVar, tYVar);
        X0_to_X1.put(priorZVar, tZVar);

        Set<RandomVariable> E_1 = new HashSet<>();
        E_1.add(tEVar);
        E_1.add(tFVar);
        E_1.add(tGVar);
        DynamicBayesNet dbn = new DynamicBayesNet(priorNetwork, X0_to_X1, E_1, priorX, priorY, priorZ);

        return new WrapDynamicBayesNet(new FiniteNode[]{priorX, priorY, priorZ}, new FiniteNode[]{tX, tY, tZ, tE, tF, tG}, vaNamesMap, X1_to_X0, dbn);
    }

    private WrapDynamicBayesNet getRandomNetwork(BayesianNetwork bn, Map<String, List<String>> mapping, Set<String> evNames) {
        HashMap<String, RandomVariable> vaNamesMap = new HashMap<>();
        Map<RandomVariable, RandomVariable> X1_to_X0 = new LinkedHashMap<>();
        Map<RandomVariable, RandomVariable> X0_to_X1 = new LinkedHashMap<>();

        // priorNodes (t = 0)
        List<Node> priorNodes = new ArrayList<>();
        List<FiniteNode> roots = new ArrayList<>();
        for (RandomVariable var : bn.getVariablesInTopologicalOrder()) {
            String name = var.getName();
            if (!evNames.contains(name)) {
                String newName = name + "_0";
                RandVar priorVar = new RandVar(newName, new BooleanDomain());
                FiniteNode priorNode = new FullCPTNode(priorVar, new double[]{0.5, 0.5});
                vaNamesMap.put(newName, priorVar);
                priorNodes.add(priorNode);
                if (bn.getNode(var).isRoot()) { // se originariamente era root
                    roots.add(priorNode);
                }
            }
        }
        BayesNet priorNetwork = new BayesNet(priorNodes.toArray(new Node[0]));

        // tNodes (t = 1)
        List<FiniteNode> tmpNodes = new ArrayList<>();
        Map<String, Node> mapNodes = new HashMap<>();
        List<FiniteNode> tNodes = new ArrayList<>();
        for (RandomVariable var : bn.getVariablesInTopologicalOrder()) { // importante che sia in ordine topologico inverso
            String name = var.getName();
            String newName = name + "_t";
            RandVar tVar = new RandVar(newName, new BooleanDomain());
            CPTNode oldNode = (CPTNode) bn.getNode(var);
            Node[] parents = oldNode.getParentsList().stream()
                    .map(x -> mapNodes.get(x.getRandomVariable().getName() + "_t")).toArray(Node[]::new);
            FiniteNode tNode = new CPTNode(tVar, oldNode.getCPTDistribution(), parents);
            vaNamesMap.put(newName, tVar);
            tmpNodes.add(tNode);
            mapNodes.put(newName, tNode);
        }

        for (FiniteNode tNode : tmpNodes) {
            // tNodes with intergraph link
            CPTNode oldNode = (CPTNode) tNode;
            String name = oldNode.getRandomVariable().getName();
            if (mapping.containsKey(name)) {
                List<Node> parents = oldNode.getParentsList();
                List<String> previousVarNames = mapping.get(name);
                List<Node> previousNodes = priorNodes.stream()
                        .filter(x -> previousVarNames.contains(x.getRandomVariable().getName())).collect(Collectors.toList());

                RandVar tVar = (RandVar) oldNode.getRandomVariable();
                double[] cpt = new double[0];
                if (parents.size() != 0) { // se è root
                    cpt = oldNode.getCPTDistribution();
                }

                Node[] newParents = Stream.concat(parents.stream(), previousNodes.stream()).toArray(Node[]::new);

                int missingSize = (int) (2 * Math.pow(2.0, newParents.length) - cpt.length);
                for (int i = 0; i < missingSize / 2; i++) {
                    double rnd = generator.nextDouble();
                    cpt = ArrayUtils.addAll(cpt, rnd, 1 - rnd);
                }

                tNode = new FullCPTNode(tVar, cpt, newParents);
            }
            tNodes.add(tNode);
        }

        Set<RandomVariable> E_1 = new HashSet<>();
        for (FiniteNode tNode : tNodes) {
            RandomVariable tVar = tNode.getRandomVariable();
            String name = tVar.getName().split("_")[0];
            if (!evNames.contains(name)) {
                String priorName = name + "_0";
                RandomVariable priorVar = vaNamesMap.get(priorName);
                X1_to_X0.put(tVar, priorVar);
                X0_to_X1.put(priorVar, tVar);
            } else {
                E_1.add(tVar);
            }
        }

        FiniteNode[] priorRoots = roots.toArray(new FiniteNode[0]);
        DynamicBayesNet dbn = new DynamicBayesNet(priorNetwork, X0_to_X1, E_1, priorRoots);
        FiniteNode[] tNodeArray = tNodes.toArray(new FiniteNode[0]);

        return new WrapDynamicBayesNet(priorRoots, tNodeArray, vaNamesMap, X1_to_X0, dbn);
    }
}

