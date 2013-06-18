package org.guha.rcdk.descriptors;

import org.openscience.cdk.qsar.DescriptorEngine;
import org.openscience.cdk.silent.SilentChemObjectBuilder;

import java.util.ArrayList;
import java.util.List;

/**
 * @cdk.author Rajarshi Guha
 * @cdk.svnrev $Revision: 9162 $
 */
public class DescriptorUtilities {

    public static String[] getDescriptorNamesByCategory(String category) {
        category += "Descriptor";
        List<String> ret = new ArrayList<String>();
        DescriptorEngine engine = new DescriptorEngine(DescriptorEngine.MOLECULAR, SilentChemObjectBuilder.getInstance());
        List<String> classNames = engine.getDescriptorClassNames();
        for (String className : classNames) {
            String[] dictClasses = engine.getDictionaryClass(className);
            if (dictClasses == null) {
                if (className.indexOf("AcidicGroupCountDescriptor") >= 0)
                    dictClasses = new String[]{"constitutionalDescriptor"};
            }
            for (String dictClass : dictClasses) {
                if (category.equals(dictClass)) {
                    ret.add(className);
                    break;
                }
            }
        }

        String[] validClassNames = new String[ret.size()];
        for (int i = 0; i < ret.size(); i++) validClassNames[i] = ret.get(i);
        return validClassNames;
    }

    public static String[] getDescriptorCategories() {
        DescriptorEngine engine = new DescriptorEngine(DescriptorEngine.MOLECULAR, SilentChemObjectBuilder.getInstance());
        return engine.getAvailableDictionaryClasses();
    }

    public static void main(String[] args) {
        String category = "geometrical";
        DescriptorUtilities.getDescriptorNamesByCategory(category);
    }
}
