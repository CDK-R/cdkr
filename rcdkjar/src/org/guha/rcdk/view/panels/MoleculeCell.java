package org.guha.rcdk.view.panels;

import org.guha.rcdk.view.RcdkDepictor;
import org.openscience.cdk.DefaultChemObjectBuilder;
import org.openscience.cdk.exception.CDKException;
import org.openscience.cdk.interfaces.IAtomContainer;
import org.openscience.cdk.smiles.SmilesParser;

import javax.swing.*;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.IOException;

/**
 * A <code>JPanel</code> to display 2D chemical structure depictions.
 *
 * @author Rajarshi Guha
 */
public class MoleculeCell extends JPanel {

    private int preferredWidth;
    private int preferredHeight;
    private boolean isNew;
    IAtomContainer atomContainer;
    RcdkDepictor depictor;
    BufferedImage bufferedImage;

    public MoleculeCell(IAtomContainer atomContainer, RcdkDepictor depictor) throws IOException, CDKException {
        preferredHeight = depictor.getHeight();
        preferredWidth = depictor.getWidth();
        this.depictor = depictor;
        this.atomContainer = atomContainer;
        this.setPreferredSize(new Dimension(preferredWidth, preferredHeight));
        this.setBackground(Color.WHITE);
        this.setBorder(BorderFactory.createEtchedBorder());
        bufferedImage = depictor.getImage(atomContainer);
        isNew = true;
    }

    public void paint(Graphics g) {
        super.paint(g);
        if (isNew) {
            g.drawImage(bufferedImage, 0, 0, this);
            isNew = false;
        } else
            try {
                depictor.setWidth(getWidth());
                depictor.setHeight(getHeight());
                g.drawImage(depictor.getImage(atomContainer), 0, 0, this);
            } catch (CDKException e) {
                e.printStackTrace();
            }
    }

    public static void main(String[] args) throws CDKException, IOException {
        SmilesParser sp = new SmilesParser(DefaultChemObjectBuilder.getInstance());
//        IAtomContainer container = sp.parseSmiles("C1CN2CCN(CCCN(CCN(C1)Cc1ccccn1)CC2)C");
        IAtomContainer container = sp.parseSmiles("[Na+].[Na+].[Na+].[Na+].[Na+].[Na+].[Na+].[Na+].[Na+].[Na+].[Na+].[Na+].[Na+].CCCCc1ccc(CO[C@H]2O[C@H](COS(=O)(=O)[O-])[C@@H](OS(=O)(=O)[O-])[C@H](OS(=O)(=O)[O-])[C@@H]2O[C@H]3O[C@H](COS(=O)(=O)[O-])[C@@H](OS(=O)(=O)[O-])[C@H](O[C@H]4O[C@H](COS(=O)(=O)[O-])[C@@H](OS(=O)(=O)[O-])[C@H](O[C@H]5O[C@H](COS(=O)(=O)[O-])[C@@H](OS(=O)(=O)[O-])[C@H](OS(=O)(=O)[O-])[C@@H]5OS(=O)(=O)[O-])[C@@H]4OS(=O)(=O)[O-])[C@@H]3OS(=O)(=O)[O-])cc1 ");
        RcdkDepictor depictor = new RcdkDepictor(300, 300, 1.3, "cow", "off", "reagents", true, false, 100, "", false);
        MoleculeCell mcell = new MoleculeCell(container, depictor);
        JFrame frame = new JFrame("Molecule Cell");
        frame.getContentPane().add(mcell);
        frame.pack();
        frame.setVisible(true);
    }

}

