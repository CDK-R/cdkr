package org.guha.rcdk.view;

import org.guha.rcdk.util.Misc;
import org.openscience.cdk.DefaultChemObjectBuilder;
import org.openscience.cdk.aromaticity.CDKHueckelAromaticityDetector;
import org.openscience.cdk.exception.CDKException;
import org.openscience.cdk.graph.ConnectivityChecker;
import org.openscience.cdk.interfaces.IAtomContainer;
import org.openscience.cdk.renderer.AtomContainerRenderer;
import org.openscience.cdk.renderer.font.AWTFontManager;
import org.openscience.cdk.renderer.generators.*;
import org.openscience.cdk.renderer.visitor.AWTDrawVisitor;
import org.openscience.cdk.smiles.SmilesParser;
import org.openscience.cdk.tools.manipulator.AtomContainerManipulator;

import java.awt.*;
import java.awt.datatransfer.DataFlavor;
import java.awt.datatransfer.Transferable;
import java.awt.datatransfer.UnsupportedFlavorException;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * A one line summary.
 *
 * @author Rajarshi Guha
 */
public class MoleculeImageToClipboard {

    public static void copyImageToClipboard(IAtomContainer molecule, int width, int height) throws Exception {
        if (!ConnectivityChecker.isConnected(molecule)) throw new CDKException("Molecule must be connected");
        molecule = AtomContainerManipulator.removeHydrogens(molecule);
        try {
            CDKHueckelAromaticityDetector.detectAromaticity(molecule);
        } catch (CDKException e) {
            throw new Exception("Error in aromatcity detection");
        }
        molecule = Misc.getMoleculeWithCoordinates(molecule);
        Image image = getImage(molecule, width, height);

        // now copy to clipboard
        ImageSelection.copyImageToClipboard(image);
    }

    private static Image getImage(IAtomContainer molecule, int width, int height) throws IOException {

        Rectangle drawArea = new Rectangle(width, height);
        Image image = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);

        List<IGenerator<IAtomContainer>> generators = new ArrayList<IGenerator<IAtomContainer>>();
        generators.add(new BasicSceneGenerator());
        generators.add(new BasicBondGenerator());
        generators.add(new BasicAtomGenerator());
        generators.add(new AtomMassGenerator());

        // the renderer needs to have a toolkit-specific font manager
        AtomContainerRenderer renderer = new AtomContainerRenderer(generators, new AWTFontManager());

        // the call to 'setup' only needs to be done on the first paint
        renderer.setup(molecule, drawArea);

        // paint the background
        Graphics2D g2 = (Graphics2D) image.getGraphics();
        g2.setColor(Color.WHITE);
        g2.fillRect(0, 0, width, height);

        // the paint method also needs a toolkit-specific renderer
        renderer.paint(molecule, new AWTDrawVisitor(g2), drawArea, true);

        return image;
    }

    public static void main(String[] args) throws Exception {
        SmilesParser sp = new SmilesParser(DefaultChemObjectBuilder.getInstance());
        IAtomContainer mol = sp.parseSmiles("c1ccccc1CC(=O)C1COCNC1");

        MoleculeImageToClipboard.copyImageToClipboard(mol, 300, 300);
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