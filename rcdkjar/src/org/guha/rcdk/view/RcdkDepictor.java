package org.guha.rcdk.view;

import org.openscience.cdk.CDKConstants;
import org.openscience.cdk.depict.Abbreviations;
import org.openscience.cdk.depict.Depiction;
import org.openscience.cdk.depict.DepictionGenerator;
import org.openscience.cdk.exception.CDKException;
import org.openscience.cdk.interfaces.*;
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

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.*;

/**
 * Wrapper around CDK depiction workflow, independent of how it will be displayed.
 *
 * @author Rajarshi Guha
 */
public class RcdkDepictor {
    int width = 300;
    int height = 300;

    double zoom = 1.3;
    String style = "cow";
    String annotate = "off";
    String abbr = "on";
    boolean suppressh = true;
    boolean showTitle = false;
    int smaLimit = 100;
    String sma = "";

    private final IChemObjectBuilder builder = SilentChemObjectBuilder.getInstance();
    private final DepictionGenerator generator = new DepictionGenerator();
    private SmilesParser smipar = new SmilesParser(builder);
    private final Abbreviations abbreviations = new Abbreviations();
    private final Abbreviations reagents = new Abbreviations();


    public RcdkDepictor(int width, int height) throws IOException {
        this(width, height, 1.3, "cow", "off", "on", true, false, 100, "");
    }

    public RcdkDepictor(int width, int height, double zoom, String style, String annotate, String abbr,
                        boolean suppressh, boolean showTitle, int smaLimit, String sma) throws IOException {
        this.width = width;
        this.height = height;
        this.zoom = zoom;
        this.style = style;
        this.annotate = annotate;
        this.abbr = abbr;
        this.suppressh = suppressh;
        this.showTitle = showTitle;
        this.smaLimit = smaLimit;
        this.sma = sma;

        boolean alignRxnMap = true;
        String fmt = "PNG";

        this.abbreviations.loadFromFile("/org/openscience/cdk/app/abbreviations.smi");
        this.reagents.loadFromFile("/org/openscience/cdk/app/reagents.smi");
        DepictionGenerator myGenerator = generator.withSize(width, height).withZoom(zoom);
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
    }

    public int getWidth() {
        return width;
    }

    public void setWidth(int width) {
        this.width = width;
    }

    public int getHeight() {
        return height;
    }

    public void setHeight(int height) {
        this.height = height;
    }

    public double getZoom() {
        return zoom;
    }

    public void setZoom(double zoom) {
        this.zoom = zoom;
    }

    public String getStyle() {
        return style;
    }

    public void setStyle(String style) {
        this.style = style;
    }

    public String getAnnotate() {
        return annotate;
    }

    public void setAnnotate(String annotate) {
        this.annotate = annotate;
    }

    public String getAbbr() {
        return abbr;
    }

    public void setAbbr(String abbr) {
        this.abbr = abbr;
    }

    public boolean isSuppressh() {
        return suppressh;
    }

    public void setSuppressh(boolean suppressh) {
        this.suppressh = suppressh;
    }

    public boolean isShowTitle() {
        return showTitle;
    }

    public void setShowTitle(boolean showTitle) {
        this.showTitle = showTitle;
    }

    public int getSmaLimit() {
        return smaLimit;
    }

    public void setSmaLimit(int smaLimit) {
        this.smaLimit = smaLimit;
    }

    public String getSma() {
        return sma;
    }

    public void setSma(String sma) {
        this.sma = sma;
    }

    public BufferedImage getImage(IAtomContainer atomContainer) throws CDKException {
        return generate(atomContainer).toImg();
    }

    public byte[] getFormat(IAtomContainer atomContainer, String fmt) throws CDKException, IOException {
        final String fmtlc = fmt.toLowerCase(Locale.ROOT);
        Depiction depiction = generate(atomContainer);
        switch (fmtlc) {
            case Depiction.SVG_FMT:
                return depiction.toSvgStr().getBytes();
            case Depiction.PDF_FMT:
                return depiction.toPdfStr().getBytes();
            case Depiction.PNG_FMT:
            case Depiction.JPG_FMT:
            case Depiction.GIF_FMT:
                ByteArrayOutputStream bao = new ByteArrayOutputStream();
                ImageIO.write(depiction.toImg(), fmtlc, bao);
                return bao.toByteArray();
        }
        throw new IllegalArgumentException("Unsupported format.");
    }

    private Depiction generate(IAtomContainer atomContainer) throws CDKException {
        DepictionGenerator myGenerator = generator.withSize(width, height).withZoom(zoom);
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
        java.util.List<IAtomContainer> mols = null;
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
        return depiction;
    }

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
        java.util.List<Sgroup> sgroups = mol.getProperty(CDKConstants.CTAB_SGROUPS, java.util.List.class);

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
        // Multimap<IAtomContainer, Sgroup> sgroupmap = ArrayListMultimap.create();
        Map<IAtomContainer, ArrayList<Sgroup>> sgroupmap = new HashMap<>();;
        
        switch (mode.toLowerCase()) {
            case "true":
            case "on":
            case "yes":
                for (IAtomContainer mol : rxn.getReactants().atomContainers()) {
                    contractHydrates(mol);
                    Set<IAtom> atoms = new HashSet<>();
                    // java.util.List<Sgroup> newSgroups = new ArrayList<>();
                    for (Sgroup sgroup : abbreviations.generate(mol)) {
                        if (add(atoms, sgroup.getAtoms()))
                            // newSgroups.add(sgroup);
                            sgroupmap.computeIfAbsent(mol, k -> new ArrayList<Sgroup>()).add(sgroup);
                    }
                    
                    
                }
                for (IAtomContainer mol : rxn.getProducts().atomContainers()) {
                    contractHydrates(mol);
                    Set<IAtom> atoms = new HashSet<>();
                    // java.util.List<Sgroup> newSgroups = new ArrayList<>();
                    for (Sgroup sgroup : abbreviations.generate(mol)) {
                        if (add(atoms, sgroup.getAtoms()))
                            sgroupmap.computeIfAbsent(mol, k -> new ArrayList<Sgroup>()).add(sgroup);
                            // newSgroups.add(sgroup);
                    }
                    // sgroupmap.putAll(mol, newSgroups);
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
        
        sgroupmap.forEach( (mol, valcoll) -> {
          
          valcoll.forEach( (abbrv) -> {
            
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
          });
        });
          

        for (Map.Entry<IAtomContainer, ArrayList<Sgroup>> e : sgroupmap.entrySet()) {
            final IAtomContainer mol = e.getKey();

            java.util.List<Sgroup> sgroups = mol.getProperty(CDKConstants.CTAB_SGROUPS);
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
            java.util.List<Sgroup> sgroups = mol.getProperty(CDKConstants.CTAB_SGROUPS);
            java.util.List<Sgroup> filtered = new ArrayList<>();
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
                generator = generator.withAtomColors(new RcdkDepictor.CobColorer())
                        .withBackgroundColor(Color.BLACK)
                        .withOuterGlowHighlight();
                break;
            case "nob":
                generator = generator.withAtomColors(new RcdkDepictor.NobColorer())
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

}
