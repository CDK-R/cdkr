package org.guha.rcdk.view;

import org.openscience.cdk.DefaultChemObjectBuilder;
import org.openscience.cdk.exception.CDKException;
import org.openscience.cdk.interfaces.IAtomContainer;
import org.openscience.cdk.smiles.SmilesParser;

import java.io.FileOutputStream;
import java.io.IOException;

/**
 * Generate a chemical structure depiction in a graphic image format.
 *
 * @author Rajarshi Guha
 */
public class MoleculeImage {
    private IAtomContainer molecule;
    private RcdkDepictor depictor;

    public MoleculeImage(IAtomContainer molecule, RcdkDepictor depictor) throws Exception {
        this.molecule = molecule;
        this.depictor = depictor;
    }

    /**
     * Get image as a byte array.
     *
     * @param width  output width
     * @param height output height
     * @param fmt    image format (png, jpeg, svg, pdf, gif)
     * @return
     * @throws IOException
     * @throws CDKException
     */
    public byte[] getBytes(int width, int height, String fmt) throws IOException, CDKException {

        depictor.setWidth(width);
        depictor.setHeight(height);
        return depictor.getFormat(molecule, fmt);
    }

    public static void main(String[] args) throws Exception {
        SmilesParser sp = new SmilesParser(DefaultChemObjectBuilder.getInstance());
        IAtomContainer mol = sp.parseSmiles("c1ccccc1CC(=O)C1COCNC1");

        RcdkDepictor depictor = new RcdkDepictor(300, 300, 1.3, "cow", "off", "reagents", true, false, 100, "", false);
        MoleculeImage mi = new MoleculeImage(mol, depictor);
        byte[] bytes = mi.getBytes(300, 300, "png");
        FileOutputStream fos = new FileOutputStream("test.png");
        fos.write(bytes);
    }
}
