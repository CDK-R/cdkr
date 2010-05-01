package org.guha.rcdk.view.panels;

import org.openscience.cdk.interfaces.IAtomContainer;
import org.openscience.cdk.interfaces.IMolecule;
import org.openscience.cdk.smiles.SmilesParser;
import org.openscience.cdk.DefaultChemObjectBuilder;
import org.openscience.cdk.renderer.Renderer;
import org.openscience.cdk.renderer.visitor.AWTDrawVisitor;
import org.openscience.cdk.renderer.font.AWTFontManager;
import org.openscience.cdk.renderer.generators.IGenerator;
import org.openscience.cdk.renderer.generators.RingGenerator;
import org.openscience.cdk.renderer.generators.BasicAtomGenerator;
import org.openscience.cdk.layout.StructureDiagramGenerator;
import org.openscience.cdk.exception.InvalidSmilesException;

import javax.swing.JPanel;
import javax.swing.BorderFactory;
import javax.swing.JFrame;
import java.util.ArrayList;
import java.awt.Dimension;
import java.awt.Color;
import java.awt.Graphics;
import java.awt.Rectangle;
import java.awt.Graphics2D;

/**
 * A one line summary.
 *
 * @author Rajarshi Guha
 */
public class MoleculeCell extends JPanel {

    private int preferredWidth;

    private int preferredHeight;

    private IAtomContainer atomContainer;

    private Renderer renderer;

    private boolean isNew;

    public MoleculeCell(IAtomContainer atomContainer, int w, int h) {
        this.atomContainer = atomContainer;
        this.preferredWidth = w;
        this.preferredHeight = h;

        this.setPreferredSize(new Dimension(w, h));
        this.setBackground(Color.WHITE);
        this.setBorder(BorderFactory.createEtchedBorder());

        java.util.List<IGenerator> generators = new ArrayList<IGenerator>();
        generators.add(new RingGenerator());
        generators.add(new BasicAtomGenerator());

        this.renderer = new Renderer(generators, new AWTFontManager());
        isNew = true;
    }

    public void paint(Graphics g) {
        super.paint(g);

        if (this.isNew) {
            Rectangle drawArea = new Rectangle(0, 0, this.preferredWidth, this.preferredHeight);
            this.renderer.setup(atomContainer, drawArea);
            this.isNew = false;
            this.renderer.paintMolecule(this.atomContainer, new AWTDrawVisitor((Graphics2D) g), drawArea, isNew);
        } else {
            Rectangle drawArea = new Rectangle(0, 0, this.getWidth(), this.getHeight());
            this.renderer.setup(atomContainer, drawArea);
            this.renderer.paintMolecule(this.atomContainer, new AWTDrawVisitor((Graphics2D) g), drawArea, false);
        }

    }

    public static void main(String[] args) throws InvalidSmilesException {
        SmilesParser sp = new SmilesParser(DefaultChemObjectBuilder.getInstance());
        IAtomContainer container = sp.parseSmiles("C1CN2CCN(CCCN(CCN(C1)Cc1ccccn1)CC2)C");

        StructureDiagramGenerator sdg = new StructureDiagramGenerator();
        sdg.setMolecule((IMolecule) container);
        try {
            sdg.generateCoordinates();
        } catch (Exception e) {
        }
        container = sdg.getMolecule();


        MoleculeCell mcell = new MoleculeCell(container, 200, 200);
        JFrame frame = new JFrame("Molecule Cell");
        frame.getContentPane().add(mcell);
        frame.pack();
        frame.setVisible(true);
    }

}

