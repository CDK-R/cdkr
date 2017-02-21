package org.guha.rcdk.view;

import org.guha.rcdk.view.panels.MoleculeCell;
import org.openscience.cdk.DefaultChemObjectBuilder;
import org.openscience.cdk.interfaces.IAtomContainer;
import org.openscience.cdk.smiles.SmilesParser;

import javax.swing.*;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;


public class ViewMolecule2D extends JFrame {
    MoleculeCell panel;

    class ApplicationCloser extends WindowAdapter {
        public void windowClosing(WindowEvent e) {
            dispose();
        }
    }

    public ViewMolecule2D(IAtomContainer molecule) throws Exception {
        this(molecule, 300, 300);
    }

    public ViewMolecule2D(IAtomContainer molecule, int width, int height) throws Exception {
        this(molecule, width, height,
                1.3, "cow", "off", "reagents",
                true, false, 100, "");
    }

    public ViewMolecule2D(IAtomContainer molecule, int width, int height,
                          double zoom, String style, String annotate, String abbr,
                          boolean suppressh, boolean showTitle,
                          int smaLimit, String sma) throws Exception {
        panel = new MoleculeCell(molecule, width, height,
                zoom, style, annotate, abbr, suppressh, showTitle, smaLimit, sma);
        setTitle("2D Viewer");
        addWindowListener(new ApplicationCloser());
        setSize(width, height);

    }

    public void draw() {
        getContentPane().add(panel);
        pack();
        setVisible(true);
    }

    public static void main(String[] arg) throws Exception {
        String home = "/Users/guhar/";
        String[] fname = {home + "src/cdkr/data/dan001.sdf",
                home + "src/cdkr/data/dan002.sdf",
                home + "src/cdkr/data/dan003.sdf"};
//        IAtomContainer[] acs = null;
//        try {
//            acs = Misc.loadMolecules(fname, true, true, true);
//        } catch (CDKException e) {
//            e.printStackTrace();
//        }
        SmilesParser sp = new SmilesParser(DefaultChemObjectBuilder.getInstance());
        sp.kekulise(false);
        IAtomContainer mol = sp.parseSmiles("c1ccccc1");

        ViewMolecule2D v2d = new ViewMolecule2D(mol);

        v2d.draw();
    }
}
