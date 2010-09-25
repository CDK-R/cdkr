package org.guha.rcdk.draw;

import org.openscience.cdk.DefaultChemObjectBuilder;
import org.openscience.cdk.interfaces.IAtomContainer;
import org.openscience.cdk.interfaces.IChemModel;
import org.openscience.cdk.interfaces.IMolecule;
import org.openscience.cdk.interfaces.IMoleculeSet;
import org.openscience.cdk.layout.StructureDiagramGenerator;

import javax.swing.JDialog;
import javax.swing.JFrame;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;

public class Get2DStructureFromJCP {
    private static IChemModel chemModel;

    public Get2DStructureFromJCP() {
    }

    public Get2DStructureFromJCP(IAtomContainer molecule) {
        IMolecule localMolecule = null;
        // we should make 2D coords
        try {
            StructureDiagramGenerator sdg = new StructureDiagramGenerator();
            sdg.setMolecule((IMolecule) molecule);
            sdg.generateCoordinates();
            localMolecule = sdg.getMolecule();
        }
        catch (Exception exc) {
            exc.printStackTrace();
        }

        IMoleculeSet som = DefaultChemObjectBuilder.getInstance().newInstance(IMoleculeSet.class);
        som.addMolecule(localMolecule);
        chemModel = DefaultChemObjectBuilder.getInstance().newInstance(IChemModel.class);
        chemModel.setMoleculeSet(som);
    }

    public void showWindow() {

        JFrame frame = new JFrame();
        JDialog dlg = new JDialog(frame, true);

        dlg.setTitle("Molecule Editor");
        dlg.setDefaultCloseOperation(JDialog.DO_NOTHING_ON_CLOSE);
        dlg.addWindowListener(new MyAppCloser());

//        JChemPaintEditorPanel editPanel = new JChemPaintEditorPanel();
//        JChemPaintModel model = new JChemPaintModel();
//        editPanel.registerModel(model);
//        editPanel.setJChemPaintModel(model);
//
//        dlg.add(editPanel);
//        dlg.pack();
//        dlg.setVisible(true);
    }

    private final static class MyAppCloser extends WindowAdapter {

        /**
         * closing Event. Shows a warning if this window has unsaved data and
         * terminates jvm, if last window.
         *
         * @param e Description of the Parameter
         */
        public void windowClosing(WindowEvent e) {
//            JDialog dlg = (JDialog) e.getSource();
//            JChemPaintEditorPanel editPanel = (JChemPaintEditorPanel) dlg
//                    .getContentPane().getComponent(0);
//
//            chemModel = editPanel.getChemModel();
//            ((JDialog) e.getSource()).setVisible(false);
//            ((JDialog) e.getSource()).dispose();
        }
    }

    public IChemModel getChemModel() {
        return chemModel;
    }

    public IAtomContainer[] getMolecules() {
        IMoleculeSet som = chemModel.getMoleculeSet();
        if (som == null) return null;
        else {
            IAtomContainer[] ret = new IAtomContainer[som.getMoleculeCount()];
            int c = 0;
            for (IAtomContainer molecule : som.molecules()) {
                ret[c++] = molecule;
            }

            return ret;
        }
    }

    public static void main(String[] args) {
        Get2DStructureFromJCP e = new Get2DStructureFromJCP();
        e.showWindow();
        System.exit(0);
    }
}

// public class JCPReturn {
//
// public static void main(String[] args) {
// Get2DStructureFromJCP jcp = new Get2DStructureFromJCP();
// ChemModel model = jcp.showWindow();
// System.out.println("From main: " + model);
//
// Molecule[] molecules = jcp.getMolecules();
// System.out.println(molecules.length + " structures drawn");
//
// }
//
// }
