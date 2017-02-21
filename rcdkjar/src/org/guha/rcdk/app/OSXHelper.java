package org.guha.rcdk.app;

import org.guha.rcdk.util.Misc;
import org.guha.rcdk.view.MoleculeImageToClipboard;
import org.guha.rcdk.view.ViewMolecule2D;
import org.guha.rcdk.view.ViewMolecule2DTable;
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

    public void viewMolecule2D(IAtomContainer molecule, int width, int height,
                               double zoom, String style, String annotate, String abbr,
                               boolean suppressh, boolean showTitle,
                               int smaLimit, String sma) throws Exception {
        ViewMolecule2D v = new ViewMolecule2D(molecule, width, height, zoom, style, annotate, abbr, suppressh, showTitle, smaLimit, sma);
        v.draw();
    }

    public void viewMoleculeTable(IAtomContainer[] mols, int ncol, int cellx, int celly) throws Exception {
        ViewMolecule2DTable v = new ViewMolecule2DTable(mols, ncol, cellx, celly);
    }

    public static void main(String[] args) throws Exception {


        String method = args[0];
        String smiles = args[1]; // if viewing mol table, this will be filename
        int width = Integer.parseInt(args[2]);
        int height = Integer.parseInt(args[3]);
        double zoom = Double.parseDouble(args[4]);
        String style = args[5];
        String annotate = args[6];
        String abbr = args[7];
        boolean suppressh = args[8].equals("TRUE") ? true : false;
        boolean showTitle = args[9].equals("TRUE") ? true : false;
        int smaLimit = Integer.parseInt(args[10]);
        String sma = args[11];

        int ncol = -1;
        if (args.length == 5)
            ncol = Integer.parseInt(args[4]);

        if (smiles != null && !smiles.equals("")) {
            OSXHelper helper = new OSXHelper();
            SmilesParser sp = new SmilesParser(DefaultChemObjectBuilder.getInstance());
            if (method.equals("copyToClipboard")) {
                IAtomContainer mol = sp.parseSmiles(smiles);
                helper.copyToClipboard(mol, width, height);
            } else if (method.equals("viewMolecule2D")) {
                IAtomContainer mol = sp.parseSmiles(smiles);
                helper.viewMolecule2D(mol, width, height,
                        zoom, style, annotate, abbr, suppressh, showTitle, smaLimit, sma);
            } else if (method.equals("viewMolecule2Dtable")) {
                IAtomContainer[] mols = Misc.loadMolecules(new String[]{smiles}, true, true, true);
                helper.viewMoleculeTable(mols, ncol, width, height);
            } else {
                System.out.println("Didn't recognize method to run");
            }
        } else {
            System.out.println("Didn't get a SMILES to process");
        }
    }
}
