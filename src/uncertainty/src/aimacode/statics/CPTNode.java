package aimacode.statics;

import aima.core.probability.RandomVariable;
import aima.core.probability.bayes.ConditionalProbabilityDistribution;
import aima.core.probability.bayes.ConditionalProbabilityTable;
import aima.core.probability.bayes.FiniteNode;
import aima.core.probability.bayes.Node;
import aima.core.probability.bayes.impl.AbstractNode;
import aima.core.probability.bayes.impl.CPT;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * Aggiungiamo, all'implementazione canonica di FullCPTNode, i campi
 * distribution e parents, con i relativi metodi getter
 *
 * @author Ciaran O'Reilly
 * @author Roger Ferrod
 * @author Pio Raffaele Fina
 * @author Lorenzo Tabasso
 */
public class CPTNode extends AbstractNode implements FiniteNode {
    private final ConditionalProbabilityTable cpt;
    private double[] distribution;
    private final List<Node> parents;

    public CPTNode(RandomVariable var, double[] distribution) {
        this(var, distribution, (Node[]) null);
        this.distribution = distribution;
    }

    public CPTNode(RandomVariable var, double[] values, Node... parents) {
        super(var, parents);
        this.distribution = values;
        this.parents = parents != null ? Arrays.asList(parents) : new ArrayList<>();

        RandomVariable[] conditionedOn = new RandomVariable[getParents().size()];
        int i = 0;
        for (Node p : getParents()) {
            conditionedOn[i++] = p.getRandomVariable();
        }

        cpt = new CPT(var, values, conditionedOn);
    }

    public double[] getCPTDistribution() {
        return distribution;
    }

    public List<Node> getParentsList() {
        return parents;
    }

    //
    // START-Node
    @Override
    public ConditionalProbabilityDistribution getCPD() {
        return getCPT();
    }

    // END-Node
    //

    //
    // START-FiniteNode

    @Override
    public ConditionalProbabilityTable getCPT() {
        return cpt;
    }

    // END-FiniteNode
    //
}