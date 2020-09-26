package aimacode.dynamic;

import aima.core.probability.RandomVariable;
import aima.core.probability.bayes.FiniteNode;
import aima.core.probability.bayes.impl.FullCPTNode;
import aima.core.probability.domain.BooleanDomain;
import aima.core.probability.util.RandVar;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

public class NetworkFactory {
    public DynamicBayesNetwork umbrellaNetwork() {
        HashMap<String, RandomVariable> vaNamesMap = new HashMap<>();
        Map<RandomVariable, RandomVariable> X1_to_X0 = new LinkedHashMap<>();

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

        return new DynamicBayesNetwork(new FiniteNode[]{priorRain}, new FiniteNode[]{tRain, tUmbrella}, vaNamesMap, X1_to_X0);
    }

    public DynamicBayesNetwork windNetwork() {
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

        return new DynamicBayesNetwork(new FiniteNode[]{priorRain, priorWind}, new FiniteNode[]{tRain, tWind, tUmbrella}, vaNamesMap, X1_to_X0);
    }
}

