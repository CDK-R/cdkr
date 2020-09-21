package org.guha.rcdk.test;

import junit.framework.Assert;
import junit.framework.TestCase;
import org.guha.rcdk.draw.Get2DStructureFromJCP;
import org.openscience.cdk.interfaces.IAtomContainer;
import org.openscience.cdk.interfaces.IChemModel;

public class TestGet2DStructureFromJCP extends TestCase {

    /*
      * Test method for 'org.guha.rcdk.draw.Get2DStructureFromJCP.getChemModel()'
      */
    public void testEditor() {
        Get2DStructureFromJCP editor = new Get2DStructureFromJCP();
        editor.showWindow();
        IChemModel chemModel = editor.getChemModel();
        Assert.assertNotNull(chemModel);
        IAtomContainer[] molecules = editor.getMolecules();
        Assert.assertNotNull(molecules);
    }

}
