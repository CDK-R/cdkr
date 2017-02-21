package org.guha.rcdk.view.panels;

import com.google.common.collect.ArrayListMultimap;
import com.google.common.collect.Multimap;
import org.openscience.cdk.AtomContainer;
import org.openscience.cdk.CDKConstants;
import org.openscience.cdk.DefaultChemObjectBuilder;
import org.openscience.cdk.depict.Abbreviations;
import org.openscience.cdk.depict.Depiction;
import org.openscience.cdk.depict.DepictionGenerator;
import org.openscience.cdk.exception.CDKException;
import org.openscience.cdk.interfaces.*;
import org.openscience.cdk.io.MDLV2000Reader;
import org.openscience.cdk.renderer.color.CDK2DAtomColors;
import org.openscience.cdk.renderer.color.IAtomColorer;
import org.openscience.cdk.renderer.color.UniColor;
import org.openscience.cdk.sgroup.Sgroup;
import org.openscience.cdk.sgroup.SgroupKey;
import org.openscience.cdk.sgroup.SgroupType;
import org.openscience.cdk.silent.SilentChemObjectBuilder;
import org.openscience.cdk.smiles.SmilesParser;
import org.openscience.cdk.smiles.smarts.SmartsPattern;
import org.openscience.cdk.tools.manipulator.AtomContainerManipulator;

import javax.swing.*;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.io.StringReader;
import java.util.*;
import java.util.List;

/**
 * A one line summary.
 *
 * @author Rajarshi Guha
 */
public class MoleculeCell extends JPanel {

    private int preferredWidth;
    private int preferredHeight;
    private IAtomContainer atomContainer;
    private boolean isNew;
    BufferedImage depictionImage;

    private final IChemObjectBuilder builder = SilentChemObjectBuilder.getInstance();
    private final DepictionGenerator generator = new DepictionGenerator();
    private SmilesParser smipar = new SmilesParser(builder);
    private final Abbreviations abbreviations = new Abbreviations();
    private final Abbreviations reagents = new Abbreviations();

    private void contractHydrates(IAtomContainer mol) {
        Set<IAtom> hydrate = new HashSet<>();
        for (IAtom atom : mol.atoms()) {
            if (atom.getAtomicNumber() == 8 &&
                    atom.getImplicitHydrogenCount() == 2 &&
                    mol.getConnectedAtomsList(atom).size() == 0)
                hydrate.add(atom);
        }
        if (hydrate.size() < 2)
            return;
        @SuppressWarnings("unchecked")
        List<Sgroup> sgroups = mol.getProperty(CDKConstants.CTAB_SGROUPS, List.class);

        if (sgroups == null)
            mol.setProperty(CDKConstants.CTAB_SGROUPS,
                    sgroups = new ArrayList<>());
        else
            sgroups = new ArrayList<>(sgroups);

        Sgroup sgrp = new Sgroup();
        for (IAtom atom : hydrate)
            sgrp.addAtom(atom);
        sgrp.putValue(SgroupKey.CtabParentAtomList,
                Collections.singleton(hydrate.iterator().next()));
        sgrp.setType(SgroupType.CtabMultipleGroup);
        sgrp.setSubscript(Integer.toString(hydrate.size()));

        sgroups.add(sgrp);
    }

    private boolean add(Set<IAtom> set, Set<IAtom> atomsToAdd) {
        boolean res = true;
        for (IAtom atom : atomsToAdd) {
            if (!set.add(atom))
                res = false;
        }
        return res;
    }

    private void abbreviate(IReaction rxn, String mode, String annotate) {
        Multimap<IAtomContainer, Sgroup> sgroupmap = ArrayListMultimap.create();
        switch (mode.toLowerCase()) {
            case "true":
            case "on":
            case "yes":
                for (IAtomContainer mol : rxn.getReactants().atomContainers()) {
                    contractHydrates(mol);
                    Set<IAtom> atoms = new HashSet<>();
                    List<Sgroup> newSgroups = new ArrayList<>();
                    for (Sgroup sgroup : abbreviations.generate(mol)) {
                        if (add(atoms, sgroup.getAtoms()))
                            newSgroups.add(sgroup);
                    }
                    sgroupmap.putAll(mol, newSgroups);
                }
                for (IAtomContainer mol : rxn.getProducts().atomContainers()) {
                    contractHydrates(mol);
                    Set<IAtom> atoms = new HashSet<>();
                    List<Sgroup> newSgroups = new ArrayList<>();
                    for (Sgroup sgroup : abbreviations.generate(mol)) {
                        if (add(atoms, sgroup.getAtoms()))
                            newSgroups.add(sgroup);
                    }
                    sgroupmap.putAll(mol, newSgroups);
                }
                for (IAtomContainer mol : rxn.getAgents().atomContainers()) {
                    contractHydrates(mol);
                    reagents.apply(mol);
                    abbreviations.apply(mol);
                }
                break;
            case "groups":
                for (IAtomContainer mol : rxn.getAgents().atomContainers()) {
                    contractHydrates(mol);
                    abbreviations.apply(mol);
                }
                break;
            case "reagents":
                for (IAtomContainer mol : rxn.getAgents().atomContainers()) {
                    contractHydrates(mol);
                    reagents.apply(mol);
                }
                break;
        }

        Set<String> include = new HashSet<>();
        for (Map.Entry<IAtomContainer, Sgroup> e : sgroupmap.entries()) {
            final IAtomContainer mol = e.getKey();
            final Sgroup abbrv = e.getValue();
            int numAtoms = mol.getAtomCount();
            if (abbrv.getBonds().isEmpty()) {
                include.add(abbrv.getSubscript());
            } else {
                int numAbbr = abbrv.getAtoms().size();
                double f = numAbbr / (double) numAtoms;
                if (numAtoms - numAbbr > 1 && f <= 0.4) {
                    include.add(abbrv.getSubscript());
                }
            }
        }

        for (Map.Entry<IAtomContainer, Collection<Sgroup>> e : sgroupmap.asMap().entrySet()) {
            final IAtomContainer mol = e.getKey();

            List<Sgroup> sgroups = mol.getProperty(CDKConstants.CTAB_SGROUPS);
            if (sgroups == null)
                sgroups = new ArrayList<>();
            else
                sgroups = new ArrayList<>(sgroups);
            mol.setProperty(CDKConstants.CTAB_SGROUPS, sgroups);

            for (Sgroup abbrv : e.getValue()) {
                if (include.contains(abbrv.getSubscript()))
                    sgroups.add(abbrv);
            }
        }
    }

    private void abbreviate(IAtomContainer mol, String mode, String annotate) {
        switch (mode.toLowerCase()) {
            case "true":
            case "on":
            case "yes":
            case "groups":
                contractHydrates(mol);
                abbreviations.apply(mol);
                break;
            case "reagents":
                contractHydrates(mol);
                break;
        }
        // remove abbreviations of mapped atoms
        if ("mapidx".equals(annotate)) {
            List<Sgroup> sgroups = mol.getProperty(CDKConstants.CTAB_SGROUPS);
            List<Sgroup> filtered = new ArrayList<>();
            if (sgroups != null) {
                for (Sgroup sgroup : sgroups) {
                    // turn off display short-cuts
                    if (sgroup.getType() == SgroupType.CtabAbbreviation ||
                            sgroup.getType() == SgroupType.CtabMultipleGroup) {
                        boolean okay = true;
                        for (IAtom atom : sgroup.getAtoms()) {
                            if (atom.getProperty(CDKConstants.ATOM_ATOM_MAPPING) != null) {
                                okay = false;
                                break;
                            }
                        }
                        if (okay) filtered.add(sgroup);
                    } else {
                        filtered.add(sgroup);
                    }
                }
                mol.setProperty(CDKConstants.CTAB_SGROUPS, filtered);
            }
        }
    }

    private boolean isRxnSmi(String smi) {
        return smi.split(" ")[0].contains(">");
    }

    private static DepictionGenerator withStyle(DepictionGenerator generator, String style) {
        switch (style) {
            case "cow":
                generator = generator.withAtomColors(new CDK2DAtomColors())
                        .withBackgroundColor(Color.WHITE)
                        .withOuterGlowHighlight();
                break;
            case "bow":
                generator = generator.withAtomColors(new UniColor(Color.BLACK))
                        .withBackgroundColor(Color.WHITE);
                break;
            case "wob":
                generator = generator.withAtomColors(new UniColor(Color.WHITE))
                        .withBackgroundColor(Color.BLACK);
                break;
            case "cob":
                generator = generator.withAtomColors(new CobColorer())
                        .withBackgroundColor(Color.BLACK)
                        .withOuterGlowHighlight();
                break;
            case "nob":
                generator = generator.withAtomColors(new NobColorer())
                        .withBackgroundColor(Color.BLACK)
                        .withOuterGlowHighlight();
                break;
        }
        return generator;
    }

    private static final class CobColorer implements IAtomColorer {
        private final CDK2DAtomColors colors = new CDK2DAtomColors();

        @Override
        public Color getAtomColor(IAtom atom) {
            Color res = colors.getAtomColor(atom);
            if (res.equals(Color.BLACK))
                return Color.WHITE;
            else
                return res;
        }

        @Override
        public Color getAtomColor(IAtom atom, Color color) {
            Color res = colors.getAtomColor(atom);
            if (res.equals(Color.BLACK))
                return Color.WHITE;
            else
                return res;
        }
    }

    /**
     * Neon-on-black atom colors.
     */
    private static final class NobColorer implements IAtomColorer {
        private final CDK2DAtomColors colors = new CDK2DAtomColors();
        private final Color NEON = new Color(0x00FF0E);

        @Override
        public Color getAtomColor(IAtom atom) {
            Color res = colors.getAtomColor(atom);
            if (res.equals(Color.BLACK))
                return NEON;
            else
                return res;
        }

        @Override
        public Color getAtomColor(IAtom atom, Color color) {
            Color res = colors.getAtomColor(atom, color);
            if (res.equals(Color.BLACK))
                return NEON;
            else
                return res;
        }
    }

    /**
     * Find matching atoms and bonds in the reaction or molecule.
     *
     * @param sma SMARTS pattern
     * @param rxn reaction
     * @param mol molecule
     * @return set of matched atoms and bonds
     */
    private Set<IChemObject> findHits(final String sma, final IReaction rxn, final IAtomContainer mol,
                                      final int limit) {


        Set<IChemObject> highlight = new HashSet<>();
        if (!sma.isEmpty()) {
            SmartsPattern smartsPattern;
            try {
                smartsPattern = SmartsPattern.create(sma, null);
            } catch (Exception | Error e) {
                return Collections.emptySet();
            }
            if (mol != null) {
                for (Map<IChemObject, IChemObject> m : smartsPattern.matchAll(mol)
                        .limit(limit)
                        .uniqueAtoms()
                        .toAtomBondMap()) {
                    for (Map.Entry<IChemObject, IChemObject> e : m.entrySet()) {
                        highlight.add(e.getValue());
                    }
                }
            } else if (rxn != null) {
                for (Map<IChemObject, IChemObject> m : smartsPattern.matchAll(rxn)
                        .limit(limit)
                        .uniqueAtoms()
                        .toAtomBondMap()) {
                    for (Map.Entry<IChemObject, IChemObject> e : m.entrySet()) {
                        highlight.add(e.getValue());
                    }
                }
            }
        }
        return highlight;

    }

    private IAtomContainer loadMol(String str) throws CDKException {
        if (str.contains("V2000")) {
            try (MDLV2000Reader mdlr = new MDLV2000Reader(new StringReader(str))) {
                return mdlr.read(new AtomContainer(0, 0, 0, 0));
            } catch (CDKException | IOException e3) {
                throw new CDKException("Could not parse input");
            }
        } else {
            return smipar.parseSmiles(str);
        }
    }

    public MoleculeCell(IAtomContainer atomContainer, int w, int h,
                        double zoom, String style, String annotate, String abbr,
                        boolean suppressh, boolean showTitle,
                        int smaLimit, String sma) throws IOException, CDKException {
        this.atomContainer = atomContainer;
        preferredHeight = h;
        preferredWidth = w;
        this.setPreferredSize(new Dimension(w, h));
        this.setBackground(Color.WHITE);
        this.setBorder(BorderFactory.createEtchedBorder());

        boolean alignRxnMap = true;
        String fmt = "PNG";

        this.abbreviations.loadFromFile("/org/openscience/cdk/app/abbreviations.smi");
        this.reagents.loadFromFile("/org/openscience/cdk/app/reagents.smi");
        DepictionGenerator myGenerator = generator.withSize(w, h).withZoom(zoom);
        myGenerator = withStyle(myGenerator, style);
        switch (annotate) {
            case "number":
                myGenerator = myGenerator.withAtomNumbers();
                abbr = "false";
                break;
            case "mapidx":
                myGenerator = myGenerator.withAtomMapNumbers();
                break;
            case "atomvalue":
                myGenerator = myGenerator.withAtomValues();
                break;
            case "colmap":
                myGenerator = myGenerator.withAtomMapHighlight(new Color[]{new Color(169, 199, 255),
                        new Color(185, 255, 180),
                        new Color(255, 162, 162),
                        new Color(253, 139, 255),
                        new Color(255, 206, 86),
                        new Color(227, 227, 227)})
                        .withOuterGlowHighlight(6d);
                break;
        }
        // myGenerator = myGenerator.withMappedRxnAlign(alignRxnMap);

        final boolean isRxn = false; //!smi.contains("V2000") && isRxnSmi(smi);
        final boolean isRgp = false; //smi.contains("RG:");
        IReaction rxn = null;
        IAtomContainer mol = atomContainer;
        List<IAtomContainer> mols = null;
        Set<IChemObject> highlight;

        if (isRxn) {
            //rxn = smipar.parseReactionSmiles(smi);
            if (suppressh) {
                for (IAtomContainer component : rxn.getReactants().atomContainers())
                    AtomContainerManipulator.suppressHydrogens(component);
                for (IAtomContainer component : rxn.getProducts().atomContainers())
                    AtomContainerManipulator.suppressHydrogens(component);
                for (IAtomContainer component : rxn.getAgents().atomContainers())
                    AtomContainerManipulator.suppressHydrogens(component);
            }


            highlight = findHits(sma, rxn, mol, smaLimit);
            abbreviate(rxn, abbr, annotate);
        } else {
            //mol = loadMol(smi);
            if (suppressh) {
                AtomContainerManipulator.suppressHydrogens(mol);
            }
            highlight = findHits(sma, rxn, mol, smaLimit);
            abbreviate(mol, abbr, annotate);
        }


        if (suppressh)
            AtomContainerManipulator.suppressHydrogens(atomContainer);
        highlight = findHits(sma, rxn, atomContainer, smaLimit);
        abbreviate(atomContainer, abbr, annotate);

        switch (style) {
            case "nob":
                myGenerator = myGenerator.withHighlight(highlight,
                        new Color(0xffaaaa));
                break;
            case "bow":
            case "wob":
                myGenerator = myGenerator.withHighlight(highlight,
                        new Color(0xff0000));
                break;
            default:
                myGenerator = myGenerator.withHighlight(highlight,
                        new Color(0xaaffaa));
                break;
        }

        if (showTitle) {
            if (isRxn)
                myGenerator = myGenerator.withRxnTitle();
            else
                myGenerator = myGenerator.withMolTitle();
        }

        final Depiction depiction = isRxn ? myGenerator.depict(rxn)
                : isRgp ? myGenerator.depict(mols, mols.size(), 1)
                : myGenerator.depict(atomContainer);
        depictionImage = depiction.toImg();

//        final String fmtlc = fmt.toLowerCase(Locale.ROOT);
//        switch (fmtlc) {
//            case Depiction.SVG_FMT:
//            case Depiction.PDF_FMT:
//            case Depiction.PNG_FMT:
//            case Depiction.JPG_FMT:
//            case Depiction.GIF_FMT:
//                ByteArrayOutputStream bao = new ByteArrayOutputStream();
//                ImageIO.write(depiction.toImg(), fmtlc, bao);
//        }

        isNew = true;
    }

    public void paint(Graphics g) {
        super.paint(g);
        if (isNew) {
            g.drawImage(depictionImage, 0, 0, this);
            isNew = false;
        } else
            try {
                g.drawImage(generator.withSize(getWidth(), getHeight()).withZoom(1.3).depict(atomContainer).toImg(), 0, 0, this);
            } catch (CDKException e) {
                e.printStackTrace();
            }
    }

    public static void main(String[] args) throws CDKException, IOException {
        SmilesParser sp = new SmilesParser(DefaultChemObjectBuilder.getInstance());
//        IAtomContainer container = sp.parseSmiles("C1CN2CCN(CCCN(CCN(C1)Cc1ccccn1)CC2)C");
        IAtomContainer container = sp.parseSmiles("[Na+].[Na+].[Na+].[Na+].[Na+].[Na+].[Na+].[Na+].[Na+].[Na+].[Na+].[Na+].[Na+].CCCCc1ccc(CO[C@H]2O[C@H](COS(=O)(=O)[O-])[C@@H](OS(=O)(=O)[O-])[C@H](OS(=O)(=O)[O-])[C@@H]2O[C@H]3O[C@H](COS(=O)(=O)[O-])[C@@H](OS(=O)(=O)[O-])[C@H](O[C@H]4O[C@H](COS(=O)(=O)[O-])[C@@H](OS(=O)(=O)[O-])[C@H](O[C@H]5O[C@H](COS(=O)(=O)[O-])[C@@H](OS(=O)(=O)[O-])[C@H](OS(=O)(=O)[O-])[C@@H]5OS(=O)(=O)[O-])[C@@H]4OS(=O)(=O)[O-])[C@@H]3OS(=O)(=O)[O-])cc1 ");
        MoleculeCell mcell = new MoleculeCell(container, 500, 500, 1.3, "cow", "off", "reagents",
                true, false, 100, "");
        JFrame frame = new JFrame("Molecule Cell");
        frame.getContentPane().add(mcell);
        frame.pack();
        frame.setVisible(true);
    }

}

