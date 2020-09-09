/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package exercises;

import aima.core.probability.CategoricalDistribution;
import aima.core.probability.proposition.AssignmentProposition;

import java.util.List;

/**
 * @author torta
 */
public interface PredictionStepInference {
    CategoricalDistribution predict(CategoricalDistribution f1_t);
}
