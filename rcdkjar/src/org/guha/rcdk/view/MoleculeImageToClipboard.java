package org.guha.rcdk.view;

import org.guha.rcdk.util.Misc;
import org.openscience.cdk.DefaultChemObjectBuilder;
import org.openscience.cdk.interfaces.IAtomContainer;
import org.openscience.cdk.smiles.SmilesParser;

import java.awt.*;
import java.awt.datatransfer.DataFlavor;
import java.awt.datatransfer.Transferable;
import java.awt.datatransfer.UnsupportedFlavorException;

/**
 * A one line summary.
 *
 * @author Rajarshi Guha
 */
public class MoleculeImageToClipboard {

    public static void copyImageToClipboard(IAtomContainer molecule, RcdkDepictor depictor) throws Exception {
        Image image = depictor.getImage(molecule);
        // now copy to clipboard
        ImageSelection.copyImageToClipboard(image);
    }

    public static void main(String[] args) throws Exception {
        SmilesParser sp = new SmilesParser(DefaultChemObjectBuilder.getInstance());
        IAtomContainer mol = sp.parseSmiles("c1ccccc1CC(=O)C1COCNC1");

        MoleculeImageToClipboard.copyImageToClipboard(mol, Misc.getDefaultDepictor());
    }


}


// http://elliotth.blogspot.com/2005/09/copying-images-to-clipboard-with-java.html
class ImageSelection implements Transferable {
    private Image image;

    public static void copyImageToClipboard(Image image) {
        ImageSelection imageSelection = new ImageSelection(image);
        Toolkit toolkit = Toolkit.getDefaultToolkit();
        toolkit.getSystemClipboard().setContents(imageSelection, null);
    }

    public ImageSelection(Image image) {
        this.image = image;
    }

    public Object getTransferData(DataFlavor flavor) throws UnsupportedFlavorException {
        if (flavor.equals(DataFlavor.imageFlavor) == false) {
            throw new UnsupportedFlavorException(flavor);
        }
        return image;
    }

    public boolean isDataFlavorSupported(DataFlavor flavor) {
        return flavor.equals(DataFlavor.imageFlavor);
    }

    public DataFlavor[] getTransferDataFlavors() {
        return new DataFlavor[]{
                DataFlavor.imageFlavor
        };
    }
}