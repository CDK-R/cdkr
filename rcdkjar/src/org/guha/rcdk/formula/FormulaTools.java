package org.guha.rcdk.formula;

import org.openscience.cdk.DefaultChemObjectBuilder;
import org.openscience.cdk.formula.rules.IRule;
import org.openscience.cdk.interfaces.IAtomContainer;
import org.openscience.cdk.interfaces.IChemModel;
import org.openscience.cdk.interfaces.IMolecule;
import org.openscience.cdk.interfaces.IMoleculeSet;

import javax.swing.*;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
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
	 * 
	 */
    public static List<IRule> createList() {
    	List<IRule> rules = new ArrayList<IRule>();
        return rules; 
    }

	/**
	 * Add to a List a IRule object
	 * 
	 * 
	 * @param  rules A List with IRule object
	 * @param  rule  A IRule object to add
	 * @return A List with IRule object
	 * 
	 */
    public static List<IRule> addTo(List<IRule> rules,IRule rule){
    	rules.add(rule);
        return rules; 
    }


}
