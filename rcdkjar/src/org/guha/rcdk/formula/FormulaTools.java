package org.guha.rcdk.formula;

import org.openscience.cdk.formula.rules.IRule;

import java.util.ArrayList;
import java.util.List;

/**
 * @author Miguel rojas
 */
public class FormulaTools {

    /**
     * Initiate a List object
     *
     * @return A List with IRule object
     */
    public static List<IRule> createList() {
        List<IRule> rules = new ArrayList<IRule>();
        return rules;
    }

    /**
     * Add to a List a IRule object
     *
     * @param rules A List with IRule object
     * @param rule  A IRule object to add
     * @return A List with IRule object
     */
    public static List<IRule> addTo(List<IRule> rules, IRule rule) {
        rules.add(rule);
        return rules;
    }


}
