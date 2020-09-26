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

    private WrapDynamicBayesNet umbrellaNetwork() {
        HashMap<String, RandomVariable> vaNamesMap = new HashMap<>();
        Map<RandomVariable, RandomVariable> X1_to_X0 = new LinkedHashMap<>();
        Map<RandomVariable, RandomVariable> X0_to_X1 = new LinkedHashMap<>();

        RandVar priorRainVar = new RandVar("Rain_0", new BooleanDomain());
        FiniteNode priorRain = new FullCPTNode(priorRainVar, new double[]{0.5, 0.5});
        vaNamesMap.put("Rain_0", priorRainVar);

        RandVar tRainVar = new RandVar("Rain_t", new BooleanDomain());
        FiniteNode tRain = new FullCPTNode(tRainVar, new double[]{0.7, 0.3, 0.3, 0.7}, priorRain);
        vaNamesMap.put("Rain_t", tRainVar);

        RandVar tUmbrellaVar = new RandVar("Umbrella_t", new BooleanDomain());
        FiniteNode tUmbrella = new FullCPTNode(tUmbrellaVar, new double[]{0.9, 0.1, 0.2, 0.8}, tRain);
        vaNamesMap.put("Umbrella_t", tUmbrellaVar);

        X1_to_X0.put(tRainVar, priorRainVar);
        X0_to_X1.put(priorRainVar, tRainVar);

        BayesNet priorNetwork = new BayesNet(priorRain);
        Set<RandomVariable> E_1 = new HashSet<>();
        E_1.add(tUmbrellaVar);
        DynamicBayesNet dbn = new DynamicBayesNet(priorNetwork, X0_to_X1, E_1, priorRain);

        return new WrapDynamicBayesNet(new FiniteNode[]{priorRain}, new FiniteNode[]{tRain, tUmbrella}, vaNamesMap, X1_to_X0, dbn);
    }

    private WrapDynamicBayesNet windNetwork() {
        HashMap<String, RandomVariable> vaNamesMap = new HashMap<>();
        Map<RandomVariable, RandomVariable> X1_to_X0 = new LinkedHashMap<>();

        RandVar priorRainVar = new RandVar("Rain_0", new BooleanDomain());
        FiniteNode priorRain = new FullCPTNode(priorRainVar, new double[]{0.5, 0.5});
        vaNamesMap.put("Rain_0", priorRainVar);

        RandVar priorWindVar = new RandVar("Wind_0", new BooleanDomain());
        FiniteNode priorWind = new FullCPTNode(priorWindVar, new double[]{0.5, 0.5});
        vaNamesMap.put("Wind_0", priorWindVar);

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

        return new WrapDynamicBayesNet(new FiniteNode[]{priorRain, priorWind}, new FiniteNode[]{tRain, tWind, tUmbrella}, vaNamesMap, X1_to_X0, null);
    }

    private WrapDynamicBayesNet twoFactors() {
        HashMap<String, RandomVariable> vaNamesMap = new HashMap<>();
        Map<RandomVariable, RandomVariable> X1_to_X0 = new LinkedHashMap<>();

        RandVar priorZVar = new RandVar("Z_0", new BooleanDomain());
        FiniteNode priorZ = new FullCPTNode(priorZVar, new double[]{0.5, 0.5});
        vaNamesMap.put("Z_0", priorZVar);

        RandVar tZVar = new RandVar("Z_t", new BooleanDomain());
        FiniteNode tZ = new FullCPTNode(tZVar, new double[]{0.7, 0.3, 0.3, 0.7}, priorZ);
        vaNamesMap.put("Z_t", tZVar);

        RandVar tGVar = new RandVar("G_t", new BooleanDomain());
        FiniteNode tG = new FullCPTNode(tGVar, new double[]{0.9, 0.1, 0.2, 0.8}, tZ);
        vaNamesMap.put("G_t", tGVar);

        RandVar priorXVar = new RandVar("X_0", new BooleanDomain());
        FiniteNode priorX = new FullCPTNode(priorXVar, new double[]{0.5, 0.5});
        vaNamesMap.put("X_0", priorXVar);

        RandVar priorYVar = new RandVar("Y_0", new BooleanDomain());
        FiniteNode priorY = new FullCPTNode(priorYVar, new double[]{0.5, 0.5});
        vaNamesMap.put("Y_0", priorYVar);

        RandVar tXVar = new RandVar("X_t", new BooleanDomain());
        FiniteNode tX = new FullCPTNode(tXVar, new double[]{0.6, 0.4, 0.8, 0.2, 0.4, 0.6, 0.2, 0.8}, priorX, priorY);
        vaNamesMap.put("X_t", tXVar);

        RandVar tYVar = new RandVar("Y_t", new BooleanDomain());
        FiniteNode tY = new FullCPTNode(tYVar, new double[]{0.7, 0.3, 0.3, 0.7}, priorY);
        vaNamesMap.put("Y_t", tYVar);

        RandVar tEVar = new RandVar("E_t", new BooleanDomain());
        FiniteNode tE = new FullCPTNode(tEVar, new double[]{0.9, 0.1, 0.2, 0.8}, tX);
        vaNamesMap.put("E_t", tEVar);

        X1_to_X0.put(tXVar, priorXVar);
        X1_to_X0.put(tYVar, priorYVar);
        X1_to_X0.put(tZVar, priorZVar);

        return new WrapDynamicBayesNet(new FiniteNode[]{priorX, priorY, priorZ}, new FiniteNode[]{tX, tY, tZ, tE, tG}, vaNamesMap, X1_to_X0, null);
    }
}

