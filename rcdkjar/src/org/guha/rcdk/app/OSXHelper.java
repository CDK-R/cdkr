package org.guha.rcdk.app;

import org.guha.rcdk.view.MoleculeImageToClipboard;
import org.guha.rcdk.view.ViewMolecule2D;
import org.openscience.cdk.DefaultChemObjectBuilder;
import org.openscience.cdk.interfaces.IAtomContainer;
import org.openscience.cdk.smiles.SmilesParser;

/**
 * Provide command line support for AWT based functions.
 * <p/>
 * This is required on OS X since we can't run the AWT
 * from within R. So we get around this by shelling out
 * to the command line. Not great, but gets the job done.
 *
 * @author Rajarshi Guha
 */
public class OSXHelper {

    public void copyToClipboard(IAtomContainer molecule, int width, int height) throws Exception {
        MoleculeImageToClipboard.copyImageToClipboard(molecule, width, height);
    }

    public void viewMolecule2D(IAtomContainer molecule, int width, int height) throws Exception {
        ViewMolecule2D v = new ViewMolecule2D(molecule, width, height);
        v.draw();
    }

    public static void main(String[] args) throws Exception {
        if (args.length != 4) {
            System.out.println("Not enough argument");
        }

        String method = args[0];
        String smiles = args[1];
        int width = Integer.parseInt(args[2]);
        int height = Integer.parseInt(args[3]);

        if (smiles != null && !smiles.equals("")) {
            OSXHelper helper = new OSXHelper();
            SmilesParser sp = new SmilesParser(DefaultChemObjectBuilder.getInstance());
            IAtomContainer mol = sp.parseSmiles(smiles);
            if (method.equals("copyToClipboard")) {
                helper.copyToClipboard(mol, width, height);
            } else if (method.equals("viewMolecule2D")) {
                helper.viewMolecule2D(mol, width, height);
            } else {
                System.out.println("Didn't recognize method to run");
            }
        } else {
            System.out.println("Didn't get a SMILES to process");
        }
    }
}
