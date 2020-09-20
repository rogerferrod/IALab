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
    public MyDynamicBayesNetwork umbrellaNetwork() {
        HashMap<String, RandomVariable> vaNamesMap = new HashMap<>(); // name : va
        Map<RandomVariable, RandomVariable> X1_to_X0 = new LinkedHashMap<>(); // equivalent states between X1 and X0

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

        return new MyDynamicBayesNetwork(new FiniteNode[]{priorRain}, new FiniteNode[]{tRain, tUmbrella}, vaNamesMap, X1_to_X0);
    }
}

