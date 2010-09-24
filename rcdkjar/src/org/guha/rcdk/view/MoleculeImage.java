package org.guha.rcdk.view;

import com.objectplanet.image.PngEncoder;
import org.guha.rcdk.util.Misc;
import org.openscience.cdk.DefaultChemObjectBuilder;
import org.openscience.cdk.aromaticity.CDKHueckelAromaticityDetector;
import org.openscience.cdk.exception.CDKException;
import org.openscience.cdk.graph.ConnectivityChecker;
import org.openscience.cdk.interfaces.IAtomContainer;
import org.openscience.cdk.renderer.AtomContainerRenderer;
import org.openscience.cdk.renderer.font.AWTFontManager;
import org.openscience.cdk.renderer.generators.BasicAtomGenerator;
import org.openscience.cdk.renderer.generators.BasicBondGenerator;
import org.openscience.cdk.renderer.generators.BasicSceneGenerator;
import org.openscience.cdk.renderer.generators.IGenerator;
import org.openscience.cdk.renderer.visitor.AWTDrawVisitor;
import org.openscience.cdk.smiles.SmilesParser;
import org.openscience.cdk.tools.manipulator.AtomContainerManipulator;

import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.Rectangle;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * A one line summary.
 *
 * @author Rajarshi Guha
 */
public class MoleculeImage {
    private IAtomContainer molecule;

    public MoleculeImage(IAtomContainer molecule) throws Exception {
        if (!ConnectivityChecker.isConnected(molecule)) throw new CDKException("Molecule must be connected");
        molecule = AtomContainerManipulator.removeHydrogens(molecule);
        try {
            CDKHueckelAromaticityDetector.detectAromaticity(molecule);
        } catch (CDKException e) {
            throw new Exception("Error in aromatcity detection");
        }
        this.molecule = Misc.getMoleculeWithCoordinates(molecule);
    }

    public byte[] getBytes(int width, int height) throws IOException {

        Rectangle drawArea = new Rectangle(width, height);
        Image image = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
        
        List<IGenerator<IAtomContainer>> generators = new ArrayList<IGenerator<IAtomContainer>>();
        generators.add(new BasicSceneGenerator());
        generators.add(new BasicBondGenerator());
        generators.add(new BasicAtomGenerator());

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

        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        (new PngEncoder()).encode(image, baos);

        return baos.toByteArray();
    }

    public static void main(String[] args) throws Exception {
        SmilesParser sp = new SmilesParser(DefaultChemObjectBuilder.getInstance());
        IAtomContainer mol = sp.parseSmiles("c1ccccc1CC(=O)C1COCNC1");

        MoleculeImage mi = new MoleculeImage(mol);
        byte[] bytes = mi.getBytes(300, 300);
        FileOutputStream fos = new FileOutputStream("test.png");
        fos.write(bytes);
    }
}
