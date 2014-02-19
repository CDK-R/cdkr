package org.guha.rcdk.view;

import org.guha.rcdk.util.Misc;
import org.guha.rcdk.view.panels.MoleculeCell;
import org.openscience.cdk.DefaultChemObjectBuilder;
import org.openscience.cdk.exception.CDKException;
import org.openscience.cdk.graph.ConnectivityChecker;
import org.openscience.cdk.interfaces.IAtomContainer;
import org.openscience.cdk.smiles.SmilesParser;
import org.openscience.cdk.tools.manipulator.AtomContainerManipulator;

import javax.swing.*;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;


public class ViewMolecule2D extends JFrame {
    IAtomContainer molecule;

    MoleculeCell panel;

    int width = 300;
    int height = 300;
    double scale = 0.9;

    class ApplicationCloser extends WindowAdapter {
        public void windowClosing(WindowEvent e) {
            dispose();
        }
    }

    public ViewMolecule2D(IAtomContainer molecule) throws Exception {
        this(molecule, 300, 300);
    }

    public ViewMolecule2D(IAtomContainer molecule, int width, int height) throws Exception {
        this.width = width;
        this.height = height;

        if (!ConnectivityChecker.isConnected(molecule)) throw new CDKException("Molecule must be connected");
        molecule = AtomContainerManipulator.removeHydrogens(molecule);
        molecule = Misc.getMoleculeWithCoordinates(molecule);
        panel = new MoleculeCell(molecule, width, height);
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
