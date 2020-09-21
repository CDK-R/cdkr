package org.guha.rcdk.test;

import org.guha.rcdk.util.Misc;
import org.guha.rcdk.view.ViewMolecule2D;
import org.guha.rcdk.view.ViewMolecule2DTable;
import org.guha.rcdk.view.panels.MoleculeCell;
import org.openscience.cdk.DefaultChemObjectBuilder;
import org.openscience.cdk.exception.CDKException;
import org.openscience.cdk.interfaces.IAtomContainer;
import org.openscience.cdk.smiles.SmilesParser;

import javax.swing.*;
import java.io.IOException;

/**
 * Created by IntelliJ IDEA. User: rguha Date: Aug 28, 2006 Time: 2:58:26 PM To change this template use File | Settings
 * | File Templates.
 */
public class View2DTest {
    String home = "/Users/rguha/";


    public static void main(String[] args) throws Exception {
        View2DTest w = new View2DTest();
        w.testView2DFromSmiles();
    }

    public void testMoleculeCell() throws Exception {
        SmilesParser sp = new SmilesParser(DefaultChemObjectBuilder.getInstance());
        IAtomContainer container = sp.parseSmiles("C1CN2CCN(CCCN(CCN(C1)Cc1ccccn1)CC2)C");
        MoleculeCell mcell = new MoleculeCell(container, Misc.getDefaultDepictor());
        JFrame frame = new JFrame("Molecule Cell");
        frame.getContentPane().add(mcell);
        frame.pack();
        frame.setVisible(true);
    }

    public void testView2DFromSmiles() throws Exception {
        SmilesParser sp = new SmilesParser(DefaultChemObjectBuilder.getInstance());
        IAtomContainer container = sp.parseSmiles("C1CN2CCN(CCCN(CCN(C1)Cc1ccccn1)CC2)C");
        ViewMolecule2D v2d = new ViewMolecule2D(container);
        v2d.draw();
//        fail();
    }

    public void testView2D() throws Exception {
        String[] fname = {home + "src/R/trunk/rcdk/data/dan001.sdf",
                home + "src/R/trunk/rcdk/data/dan002.sdf",
                home + "src/R/trunk/rcdk/data/dan003.sdf"};
        IAtomContainer[] acs = null;
        try {
            acs = Misc.loadMolecules(fname, true, true, true);
        } catch (CDKException e) {
            e.printStackTrace();
        }

        ViewMolecule2D v2d = new ViewMolecule2D(acs[1]);
        v2d.draw();
//        fail();
    }

    public void testView2Dv2() throws Exception {
        String[] fname = {home + "src/R/trunk/rcdk/data/dan001.hin",
                home + "src/R/trunk/rcdk/data/dan002.hin",
                home + "src/R/trunk/rcdk/data/dan003.hin"};
        IAtomContainer[] acs = null;
        try {
            acs = Misc.loadMolecules(fname, true, true, true);
        } catch (CDKException e) {
            e.printStackTrace();
        }

        ViewMolecule2D v2d = new ViewMolecule2D(acs[1]);
//        fail();
    }

    public void testView2DT() throws IOException {
        String[] fname = {home + "src/R/trunk/rcdk/data/dan001.hin",
                home + "src/R/trunk/rcdk/data/dan002.hin",
                home + "src/R/trunk/rcdk/data/dan008.hin"};
        IAtomContainer[] acs = null;
        try {
            acs = Misc.loadMolecules(fname, true, true, true);
        } catch (CDKException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        }

        ViewMolecule2DTable v2dt = new ViewMolecule2DTable(acs, 3, 200, 200, Misc.getDefaultDepictor());
//        fail();
    }
}
