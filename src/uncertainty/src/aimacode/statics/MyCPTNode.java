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
 * Default implementation of the FiniteNode interface that uses a fully
 * specified Conditional Probability Table to represent the Node's conditional
 * distribution.
 *
 * @author Ciaran O'Reilly
 * @author Roger Ferrod
 * @author Pio Raffaele Fina
 * @author Lorenzo Tabasso
 */
public class MyCPTNode extends AbstractNode implements FiniteNode {
    private ConditionalProbabilityTable cpt = null;
    private double[] distribution;
    private List<Node> parents;

    public MyCPTNode(RandomVariable var, double[] distribution) {
        this(var, distribution, (Node[]) null);
        this.distribution = distribution;
    }

    public MyCPTNode(RandomVariable var, double[] values, Node... parents) {
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