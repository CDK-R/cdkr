package org.guha.rcdk.view.panels;

import org.openscience.cdk.DefaultChemObjectBuilder;
import org.openscience.cdk.exception.InvalidSmilesException;
import org.openscience.cdk.interfaces.IAtom;
import org.openscience.cdk.interfaces.IAtomContainer;
import org.openscience.cdk.layout.StructureDiagramGenerator;
import org.openscience.cdk.renderer.AtomContainerRenderer;
import org.openscience.cdk.renderer.RendererModel;
import org.openscience.cdk.renderer.font.AWTFontManager;
import org.openscience.cdk.renderer.generators.*;
import org.openscience.cdk.renderer.generators.AtomNumberGenerator.WillDrawAtomNumbers;
import org.openscience.cdk.renderer.visitor.AWTDrawVisitor;
import org.openscience.cdk.smiles.SmilesParser;

import javax.swing.*;
import java.awt.*;
import java.util.ArrayList;

/**
 * A one line summary.
 *
 * @author Rajarshi Guha
 */
public class MoleculeCell extends JPanel {

    private int preferredWidth;

    private int preferredHeight;

    private IAtomContainer atomContainer;

    private AtomContainerRenderer renderer;

    private boolean isNew;

    public MoleculeCell(IAtomContainer atomContainer, int w, int h) {

        for (IAtom atom : atomContainer.atoms()) {
            if (atom.getPoint2d() == null)
                throw new IllegalArgumentException("Molecule must have 2D coordinates");
        }

        this.atomContainer = atomContainer;
        this.preferredWidth = w;
        this.preferredHeight = h;

        this.setPreferredSize(new Dimension(w, h));
        this.setBackground(Color.WHITE);
        this.setBorder(BorderFactory.createEtchedBorder());

        java.util.List<IGenerator<IAtomContainer>> generators = new ArrayList<IGenerator<IAtomContainer>>();
        generators.add(new BasicSceneGenerator());
        generators.add(new RingGenerator());
        generators.add(new BasicBondGenerator());
        generators.add(new AtomNumberGenerator());
        generators.add(new ExtendedAtomGenerator());


        this.renderer = new AtomContainerRenderer(generators, new AWTFontManager());

        // disable atom number rendering
        RendererModel model = renderer.getRenderer2DModel();
        model.set(WillDrawAtomNumbers.class, Boolean.FALSE);

        isNew = true;
    }

    public void paint(Graphics g) {
        super.paint(g);

        if (this.isNew) {
            Rectangle drawArea = new Rectangle(0, 0, this.preferredWidth, this.preferredHeight);
            this.renderer.setup(atomContainer, drawArea);
            this.isNew = false;
            this.renderer.paint(this.atomContainer, new AWTDrawVisitor((Graphics2D) g), drawArea, isNew);
        } else {
            Rectangle drawArea = new Rectangle(0, 0, this.getWidth(), this.getHeight());
            this.renderer.setup(atomContainer, drawArea);
            this.renderer.paint(atomContainer, new AWTDrawVisitor((Graphics2D) g), drawArea, false);
        }

    }

    public static void main(String[] args) throws InvalidSmilesException {
        SmilesParser sp = new SmilesParser(DefaultChemObjectBuilder.getInstance());
//        IAtomContainer container = sp.parseSmiles("C1CN2CCN(CCCN(CCN(C1)Cc1ccccn1)CC2)C");
        IAtomContainer container = sp.parseSmiles("[CH2+]");

        StructureDiagramGenerator sdg = new StructureDiagramGenerator();
        sdg.setMolecule(container);
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

