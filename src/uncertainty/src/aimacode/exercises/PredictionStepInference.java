/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package aimacode.exercises;

import aima.core.probability.CategoricalDistribution;

/**
 * @author torta
 */
public interface PredictionStepInference {
    CategoricalDistribution predict(CategoricalDistribution f1_t);
}
