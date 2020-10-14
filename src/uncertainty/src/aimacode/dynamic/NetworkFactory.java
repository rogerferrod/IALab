package aimacode.dynamic;

import aima.core.probability.RandomVariable;
import aima.core.probability.bayes.FiniteNode;
import aima.core.probability.bayes.impl.BayesNet;
import aima.core.probability.bayes.impl.DynamicBayesNet;
import aima.core.probability.bayes.impl.FullCPTNode;
import aima.core.probability.domain.BooleanDomain;
import aima.core.probability.util.RandVar;

import java.util.*;

public class NetworkFactory {
    public final static String UMBRELLA = "umbrella";
    public final static String WIND = "wind";
    public final static String TWOFACTORS = "twofactors";
    public final static String EARTHQUAKE = "earthquake";
    public final static String FIVESTATES = "fivestates";
    public final static String FIVESTATES2 = "fivestates2";
    public final static String TENSTATES = "tenstates";

    public WrapDynamicBayesNet getNetwork(String net) {
        switch (net) {
            case UMBRELLA:
                return umbrellaNetwork();
            case WIND:
                return windNetwork();
            case TWOFACTORS:
                return twoFactors();
            case EARTHQUAKE:
                return earthquake();
            case FIVESTATES:
                return fivestates();
            case FIVESTATES2:
                return fivestates2();
            case TENSTATES:
                return tenstates();
            default:
                return null;
        }
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

    private WrapDynamicBayesNet earthquake() {
        HashMap<String, RandomVariable> vaNamesMap = new HashMap<>();
        Map<RandomVariable, RandomVariable> X1_to_X0 = new LinkedHashMap<>();
        Map<RandomVariable, RandomVariable> X0_to_X1 = new LinkedHashMap<>();

        RandVar priorAVar = new RandVar("A_0", new BooleanDomain());
        FiniteNode priorA = new FullCPTNode(priorAVar, new double[]{0.5, 0.5});
        vaNamesMap.put("A_0", priorAVar);

        RandVar priorBVar = new RandVar("B_0", new BooleanDomain());
        FiniteNode priorB = new FullCPTNode(priorBVar, new double[]{0.5, 0.5});
        vaNamesMap.put("B_0", priorBVar);

        RandVar priorCVar = new RandVar("C_0", new BooleanDomain());
        FiniteNode priorC = new FullCPTNode(priorCVar, new double[]{0.6, 0.4, 0.6, 0.4, 0.7, 0.3, 0.7, 0.3}, priorA, priorB);
        vaNamesMap.put("C_0", priorCVar);

        BayesNet priorNetwork = new BayesNet(priorA, priorB, priorC);

        RandVar tAVar = new RandVar("A_t", new BooleanDomain());
        FiniteNode tA = new FullCPTNode(tAVar, new double[]{0.7, 0.3, 0.3, 0.7}, priorA);
        vaNamesMap.put("A_t", tAVar);

        RandVar tBVar = new RandVar("B_t", new BooleanDomain());
        FiniteNode tB = new FullCPTNode(tBVar, new double[]{0.7, 0.3, 0.3, 0.7}, priorB);
        vaNamesMap.put("B_t", tBVar);

        RandVar tCVar = new RandVar("C_t", new BooleanDomain());
        FiniteNode tC = new FullCPTNode(tCVar, new double[]{0.7, 0.3, 0.3, 0.7, 0.2, 0.8, 0.2, 0.8, 0.2, 0.8, 0.2, 0.8, 0.7, 0.3, 0.3, 0.7}, priorC, tA, tB);
        vaNamesMap.put("C_t", tCVar);

        RandVar tDVar = new RandVar("D_t", new BooleanDomain());
        FiniteNode tD = new FullCPTNode(tDVar, new double[]{0.7, 0.3, 0.3, 0.7}, tC);
        vaNamesMap.put("D_t", tDVar);

        RandVar tEVar = new RandVar("E_t", new BooleanDomain());
        FiniteNode tE = new FullCPTNode(tEVar, new double[]{0.7, 0.3, 0.3, 0.7}, tC);
        vaNamesMap.put("E_t", tEVar);

        X1_to_X0.put(tAVar, priorAVar);
        X1_to_X0.put(tBVar, priorBVar);
        X1_to_X0.put(tCVar, priorCVar);
        X0_to_X1.put(priorAVar, tAVar);
        X0_to_X1.put(priorBVar, tBVar);
        X0_to_X1.put(priorCVar, tCVar);

        Set<RandomVariable> E_1 = new HashSet<>();
        E_1.add(tDVar);
        E_1.add(tEVar);
        DynamicBayesNet dbn = new DynamicBayesNet(priorNetwork, X0_to_X1, E_1, priorA, priorB);

        return new WrapDynamicBayesNet(new FiniteNode[]{priorA, priorB, priorC}, new FiniteNode[]{tA, tB, tC, tD, tE}, vaNamesMap, X1_to_X0, dbn);
    }

    private WrapDynamicBayesNet fivestates() {
        HashMap<String, RandomVariable> vaNamesMap = new HashMap<>();
        Map<RandomVariable, RandomVariable> X1_to_X0 = new LinkedHashMap<>();
        Map<RandomVariable, RandomVariable> X0_to_X1 = new LinkedHashMap<>();

        RandVar priorAVar = new RandVar("A_0", new BooleanDomain());
        FiniteNode priorA = new FullCPTNode(priorAVar, new double[]{0.5, 0.5});
        vaNamesMap.put("A_0", priorAVar);

        RandVar priorBVar = new RandVar("B_0", new BooleanDomain());
        FiniteNode priorB = new FullCPTNode(priorBVar, new double[]{0.5, 0.5, 0.6, 0.4}, priorA);
        vaNamesMap.put("B_0", priorBVar);

        RandVar priorCVar = new RandVar("C_0", new BooleanDomain());
        FiniteNode priorC = new FullCPTNode(priorCVar, new double[]{0.5, 0.5, 0.2, 0.8}, priorB);
        vaNamesMap.put("C_0", priorBVar);

        RandVar priorDVar = new RandVar("D_0", new BooleanDomain());
        FiniteNode priorD = new FullCPTNode(priorDVar, new double[]{0.5, 0.5, 0.4, 0.6}, priorC);
        vaNamesMap.put("D_0", priorDVar);

        BayesNet priorNetwork = new BayesNet(priorA, priorB, priorC, priorD);

        RandVar tAVar = new RandVar("A_t", new BooleanDomain());
        FiniteNode tA = new FullCPTNode(tAVar, new double[]{0.7, 0.3, 0.3, 0.7, 0.8, 0.2, 0.4, 0.6}, priorA, priorB);
        vaNamesMap.put("A_t", tAVar);

        RandVar tBVar = new RandVar("B_t", new BooleanDomain());
        FiniteNode tB = new FullCPTNode(tBVar, new double[]{0.7, 0.3, 0.5, 0.5}, tA);
        vaNamesMap.put("B_t", tBVar);

        RandVar tCVar = new RandVar("C_t", new BooleanDomain());
        FiniteNode tC = new FullCPTNode(tCVar, new double[]{0.7, 0.3, 0.2, 0.8}, tB);
        vaNamesMap.put("C_t", tCVar);

        RandVar tDVar = new RandVar("D_t", new BooleanDomain());
        FiniteNode tD = new FullCPTNode(tDVar, new double[]{0.7, 0.3, 0.1, 0.9}, tC);
        vaNamesMap.put("D_t", tDVar);

        RandVar tEVar = new RandVar("E_t", new BooleanDomain());
        FiniteNode tE = new FullCPTNode(tEVar, new double[]{0.7, 0.3, 0.3, 0.7, 0.2, 0.8, 0.2, 0.8, 0.2, 0.8, 0.2, 0.8, 0.7, 0.3, 0.3, 0.7}, tA, tC, tD);
        vaNamesMap.put("E_t", tEVar);

        X1_to_X0.put(tAVar, priorAVar);
        X1_to_X0.put(tBVar, priorBVar);
        X1_to_X0.put(tCVar, priorCVar);
        X1_to_X0.put(tDVar, priorDVar);
        X0_to_X1.put(priorAVar, tAVar);
        X0_to_X1.put(priorBVar, tBVar);
        X0_to_X1.put(priorCVar, tCVar);
        X0_to_X1.put(priorDVar, tDVar);

        Set<RandomVariable> E_1 = new HashSet<>();
        E_1.add(tEVar);
        DynamicBayesNet dbn = new DynamicBayesNet(priorNetwork, X0_to_X1, E_1, priorA);

        return new WrapDynamicBayesNet(new FiniteNode[]{priorA, priorB, priorC, priorD}, new FiniteNode[]{tA, tB, tC, tD, tE}, vaNamesMap, X1_to_X0, dbn);
    }

    private WrapDynamicBayesNet fivestates2() {
        HashMap<String, RandomVariable> vaNamesMap = new HashMap<>();
        Map<RandomVariable, RandomVariable> X1_to_X0 = new LinkedHashMap<>();
        Map<RandomVariable, RandomVariable> X0_to_X1 = new LinkedHashMap<>();

        RandVar priorAVar = new RandVar("A_0", new BooleanDomain());
        FiniteNode priorA = new FullCPTNode(priorAVar, new double[]{0.5, 0.5});
        vaNamesMap.put("A_0", priorAVar);

        RandVar priorBVar = new RandVar("B_0", new BooleanDomain());
        FiniteNode priorB = new FullCPTNode(priorBVar, new double[]{0.5, 0.5, 0.6, 0.4}, priorA);
        vaNamesMap.put("B_0", priorBVar);

        RandVar priorCVar = new RandVar("C_0", new BooleanDomain());
        FiniteNode priorC = new FullCPTNode(priorCVar, new double[]{0.5, 0.5, 0.2, 0.8}, priorB);
        vaNamesMap.put("C_0", priorBVar);

        RandVar priorDVar = new RandVar("D_0", new BooleanDomain());
        FiniteNode priorD = new FullCPTNode(priorDVar, new double[]{0.5, 0.5, 0.4, 0.6}, priorC);
        vaNamesMap.put("D_0", priorDVar);

        BayesNet priorNetwork = new BayesNet(priorA, priorB, priorC, priorD);

        RandVar tAVar = new RandVar("A_t", new BooleanDomain());
        FiniteNode tA = new FullCPTNode(tAVar, new double[]{0.7, 0.3, 0.3, 0.7, 0.8, 0.2, 0.4, 0.6}, priorA, priorB);
        vaNamesMap.put("A_t", tAVar);

        RandVar tBVar = new RandVar("B_t", new BooleanDomain());
        FiniteNode tB = new FullCPTNode(tBVar, new double[]{0.7, 0.3, 0.5, 0.5}, tA);
        vaNamesMap.put("B_t", tBVar);

        RandVar tCVar = new RandVar("C_t", new BooleanDomain());
        FiniteNode tC = new FullCPTNode(tCVar, new double[]{0.7, 0.3, 0.2, 0.8, 0.7, 0.3, 0.2, 0.8}, tB, priorC);
        vaNamesMap.put("C_t", tCVar);

        RandVar tDVar = new RandVar("D_t", new BooleanDomain());
        FiniteNode tD = new FullCPTNode(tDVar, new double[]{0.7, 0.3, 0.1, 0.9}, tC);
        vaNamesMap.put("D_t", tDVar);

        RandVar tEVar = new RandVar("E_t", new BooleanDomain());
        FiniteNode tE = new FullCPTNode(tEVar, new double[]{0.7, 0.3, 0.3, 0.7, 0.2, 0.8, 0.2, 0.8, 0.2, 0.8, 0.2, 0.8, 0.7, 0.3, 0.3, 0.7}, tA, tC, tD);
        vaNamesMap.put("E_t", tEVar);

        X1_to_X0.put(tAVar, priorAVar);
        X1_to_X0.put(tBVar, priorBVar);
        X1_to_X0.put(tCVar, priorCVar);
        X1_to_X0.put(tDVar, priorDVar);
        X0_to_X1.put(priorAVar, tAVar);
        X0_to_X1.put(priorBVar, tBVar);
        X0_to_X1.put(priorCVar, tCVar);
        X0_to_X1.put(priorDVar, tDVar);

        Set<RandomVariable> E_1 = new HashSet<>();
        E_1.add(tEVar);
        DynamicBayesNet dbn = new DynamicBayesNet(priorNetwork, X0_to_X1, E_1, priorA);

        return new WrapDynamicBayesNet(new FiniteNode[]{priorA, priorB, priorC, priorD}, new FiniteNode[]{tA, tB, tC, tD, tE}, vaNamesMap, X1_to_X0, dbn);
    }

    private WrapDynamicBayesNet tenstates() {
        HashMap<String, RandomVariable> vaNamesMap = new HashMap<>();
        Map<RandomVariable, RandomVariable> X1_to_X0 = new LinkedHashMap<>();
        Map<RandomVariable, RandomVariable> X0_to_X1 = new LinkedHashMap<>();

        RandVar prior5Var = new RandVar("N5_0", new BooleanDomain());
        FiniteNode prior5 = new FullCPTNode(prior5Var, new double[]{0.5, 0.5});
        vaNamesMap.put("N5_0", prior5Var);

        RandVar prior9Var = new RandVar("N9_0", new BooleanDomain());
        FiniteNode prior9 = new FullCPTNode(prior9Var, new double[]{0.5, 0.5});
        vaNamesMap.put("N9_0", prior9Var);

        RandVar prior4Var = new RandVar("N4_0", new BooleanDomain());
        FiniteNode prior4 = new FullCPTNode(prior4Var, new double[]{0.2, 0.8, 0.25, 0.75, 0.321, 0.679, 0.817, 0.183}, prior5, prior9);
        vaNamesMap.put("N4_0", prior4Var);

        RandVar prior8Var = new RandVar("N8_0", new BooleanDomain());
        FiniteNode prior8 = new FullCPTNode(prior8Var, new double[]{0.5, 0.5, 0.245, 0.755, 0.1, 0.9, 0.8, 0.2}, prior4, prior5);
        vaNamesMap.put("N8_0", prior8Var);

        RandVar prior0Var = new RandVar("N0_0", new BooleanDomain());
        FiniteNode prior0 = new FullCPTNode(prior0Var, new double[]{0.4, 0.6, 0.672, 0.328}, prior8);
        vaNamesMap.put("N0_0", prior0Var);

        RandVar prior6Var = new RandVar("N6_0", new BooleanDomain());
        FiniteNode prior6 = new FullCPTNode(prior6Var, new double[]{0.328, 0.672, 0.235, 0.765}, prior0);
        vaNamesMap.put("N6_0", prior6Var);

        RandVar prior3Var = new RandVar("N3_0", new BooleanDomain());
        FiniteNode prior3 = new FullCPTNode(prior3Var, new double[]{0.216, 0.784, 0.345, 0.655}, prior6);
        vaNamesMap.put("N3_0", prior3Var);

        BayesNet priorNetwork = new BayesNet(prior0, prior3, prior4, prior5, prior6, prior8, prior9);

        RandVar t5Var = new RandVar("N5_t", new BooleanDomain());
        FiniteNode t5 = new FullCPTNode(t5Var, new double[]{0.5, 0.5, 0.2, 0.8}, prior5);
        vaNamesMap.put("N5_t", t5Var);

        RandVar t9Var = new RandVar("N9_t", new BooleanDomain());
        FiniteNode t9 = new FullCPTNode(t9Var, new double[]{0.5, 0.5, 0.7, 0.3}, prior9);
        vaNamesMap.put("N9_t", prior9Var);

        RandVar t4Var = new RandVar("N4_0", new BooleanDomain());
        FiniteNode t4 = new FullCPTNode(t4Var, new double[]{0.2, 0.8, 0.25, 0.75, 0.321, 0.679, 0.817, 0.183}, t5, t9);
        vaNamesMap.put("N4_t", t4Var);

        RandVar t8Var = new RandVar("N8_0", new BooleanDomain());
        FiniteNode t8 = new FullCPTNode(t8Var, new double[]{0.5, 0.5, 0.245, 0.755, 0.1, 0.9, 0.8, 0.2}, t4, t5);
        vaNamesMap.put("N8_t", t8Var);

        RandVar t0Var = new RandVar("N0_0", new BooleanDomain());
        FiniteNode t0 = new FullCPTNode(t0Var, new double[]{0.4, 0.6, 0.672, 0.328}, t8);
        vaNamesMap.put("N0_t", t0Var);

        RandVar t6Var = new RandVar("N6_0", new BooleanDomain());
        FiniteNode t6 = new FullCPTNode(t6Var, new double[]{0.7, 0.3, 0.3, 0.7, 0.2, 0.8, 0.2, 0.8, 0.2, 0.8, 0.2, 0.8, 0.7, 0.3, 0.3, 0.7}, t0, prior6, prior8);
        vaNamesMap.put("N6_t", t6Var);

        RandVar t3Var = new RandVar("N3_0", new BooleanDomain());
        FiniteNode t3 = new FullCPTNode(t3Var, new double[]{0.216, 0.784, 0.345, 0.655}, t6);
        vaNamesMap.put("N3_t", t3Var);

        RandVar t1Var = new RandVar("N1_t", new BooleanDomain());
        FiniteNode t1 = new FullCPTNode(t1Var, new double[]{0.7, 0.3, 0.3, 0.7, 0.2, 0.8, 0.2, 0.8, 0.2, 0.8, 0.2, 0.8, 0.7, 0.3, 0.3, 0.7}, t5, t3, t0);
        vaNamesMap.put("N1_t", t1Var);

        RandVar t2Var = new RandVar("N2_t", new BooleanDomain());
        FiniteNode t2 = new FullCPTNode(t2Var, new double[]{0.1, 0.9, 0.1, 0.9}, t9);
        vaNamesMap.put("N2_t", t2Var);

        RandVar t7Var = new RandVar("N7_t", new BooleanDomain());
        FiniteNode t7 = new FullCPTNode(t7Var, new double[]{0.9, 0.1, 0.9, 0.1, 0.8, 0.2, 0.2, 0.8}, t6, t9);
        vaNamesMap.put("N7_t", t7Var);

        X1_to_X0.put(t0Var, prior0Var);
        X1_to_X0.put(t3Var, prior3Var);
        X1_to_X0.put(t4Var, prior4Var);
        X1_to_X0.put(t5Var, prior5Var);
        X1_to_X0.put(t8Var, prior8Var);
        X1_to_X0.put(t9Var, prior9Var);
        X1_to_X0.put(t6Var, prior6Var);

        X0_to_X1.put(prior0Var, t0Var);
        X0_to_X1.put(prior3Var, t3Var);
        X0_to_X1.put(prior4Var, t4Var);
        X0_to_X1.put(prior5Var, t5Var);
        X0_to_X1.put(prior8Var, t8Var);
        X0_to_X1.put(prior9Var, t9Var);
        X0_to_X1.put(prior6Var, t6Var);

        Set<RandomVariable> E_1 = new HashSet<>();
        E_1.add(t1Var);
        E_1.add(t2Var);
        E_1.add(t7Var);
        DynamicBayesNet dbn = new DynamicBayesNet(priorNetwork, X0_to_X1, E_1, prior5, prior9);

        return new WrapDynamicBayesNet(new FiniteNode[]{prior0, prior3, prior4, prior5, prior6, prior8, prior9},
                new FiniteNode[]{t0, t1, t2, t3, t4, t5, t6, t7, t8, t9}, vaNamesMap, X1_to_X0, dbn);
    }
}

