/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package aimacode.exercises;

import aima.core.probability.CategoricalDistribution;
import aima.core.probability.hmm.HiddenMarkovModel;
import aima.core.util.math.Matrix;

/**
 * @author torta
 */
public class HMMPredict implements PredictionStepInference {
    protected HiddenMarkovModel hmm = null;

    public HMMPredict(HiddenMarkovModel hmm) {
        this.hmm = hmm;
    }

    public CategoricalDistribution predict(CategoricalDistribution f1_t) {
        return hmm.convert(predict(hmm.convert(f1_t)));
    }

    public Matrix predict(Matrix f1_t) {
        return hmm.normalize(hmm.getTransitionModel().transpose().times(f1_t));
    }
}
