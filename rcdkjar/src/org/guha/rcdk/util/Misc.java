/**
 *
 */
package org.guha.rcdk.util;

import org.guha.rcdk.view.RcdkDepictor;
import org.openscience.cdk.DefaultChemObjectBuilder;
import org.openscience.cdk.aromaticity.CDKHueckelAromaticityDetector;
import org.openscience.cdk.config.Isotopes;
import org.openscience.cdk.exception.CDKException;
import org.openscience.cdk.inchi.InChIGenerator;
import org.openscience.cdk.inchi.InChIGeneratorFactory;
import org.openscience.cdk.interfaces.IAtom;
import org.openscience.cdk.interfaces.IAtomContainer;
import org.openscience.cdk.interfaces.IChemFile;
import org.openscience.cdk.interfaces.IChemObjectBuilder;
import org.openscience.cdk.io.ISimpleChemObjectReader;
import org.openscience.cdk.io.ReaderFactory;
import org.openscience.cdk.io.SDFWriter;
import org.openscience.cdk.io.SMILESReader;
import org.openscience.cdk.io.listener.PropertiesListener;
import org.openscience.cdk.isomorphism.UniversalIsomorphismTester;
import org.openscience.cdk.layout.StructureDiagramGenerator;
import org.openscience.cdk.smiles.SmilesGenerator;
import org.openscience.cdk.smiles.SmilesParser;
import org.openscience.cdk.smsd.Isomorphism;
import org.openscience.cdk.tools.manipulator.AtomContainerManipulator;
import org.openscience.cdk.tools.manipulator.ChemFileManipulator;

import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.*;

/**
 * @author Rajarshi Guha
 */

public class Misc {

    public static void writeMoleculesInOneFile(IAtomContainer[] molecules,
                                               String filename,
                                               int writeProps) throws Exception {
        SDFWriter writer = new SDFWriter(new FileWriter(new File(filename)));

        Properties props = new Properties();
        props.put("WriteAromaticBondTypes", "true");
        if (writeProps == 0) {
            props.put("writeProperties", "false");
        }
        PropertiesListener listener = new PropertiesListener(props);
        writer.addChemObjectIOListener(listener);
        writer.customizeJob();
        for (IAtomContainer molecule : molecules) {
            writer.write(molecule);
        }
        writer.close();
    }

    public static void writeMolecules(IAtomContainer[] molecules, String prefix, int writeProps) throws Exception {
        int counter = 1;
        for (IAtomContainer molecule : molecules) {
            String filename = prefix + counter + ".sdf";
            SDFWriter writer = new SDFWriter(new FileWriter(new File(filename)));

            Properties props = new Properties();
            props.put("WriteAromaticBondTypes", "true");
            if (writeProps == 0) {
                props.put("writeProperties", "false");
            }
            PropertiesListener listener = new PropertiesListener(props);
            writer.addChemObjectIOListener(listener);
            writer.customizeJob();

            writer.write(molecule);
            writer.close();
            counter += 1;
        }
    }


    public static void setProperty(IAtomContainer molecule, String key, Object value) {
        molecule.setProperty(key, value);
    }

    public static void setProperty(IAtomContainer molecule, String key, int value) {
        setProperty(molecule, key, new Integer(value));
    }

    public static void setProperty(IAtomContainer molecule, String key, double value) {
        setProperty(molecule, key, new Double(value));
    }

    public static Object getProperty(IAtomContainer molecule, String key) {
        return molecule.getProperty(key);
    }

    public static void removeProperty(IAtomContainer molecule, String key) {
        molecule.removeProperty(key);
    }

    /**
     * Generates a canonical SMILES string from an IAtomContainer.
     * <p/>
     * The SMILES output will include aromaticity
     *
     * @param container The molecule to convert
     * @return A SMILES string
     */
    public static String getSmiles(IAtomContainer container, String type, boolean aromatic, boolean atomClasses) throws CDKException {
        SmilesGenerator smigen;
        switch (type) {
            case "generic":
                smigen = SmilesGenerator.generic();
                break;
            case "unique":
                smigen = SmilesGenerator.unique();
                break;
            case "isomeric":
                smigen = SmilesGenerator.isomeric();
                break;
            default:
                smigen = SmilesGenerator.absolute();
                break;
        }
        if (aromatic) smigen = smigen.aromatic();
        if (atomClasses) smigen = smigen.withAtomClasses();
        return smigen.create(container);
    }

    /**
     * Loads one or more files into IAtomContainer objects.
     * <p/>
     * This method does not need knowledge of the format since it is autodetected.    Note that if aromaticity detection
     * or atom typing is specified and fails for a specific molecule, that molecule will be set to <i>null</i>
     *
     * @param filenames     An array of String's containing the filenames of the structures we want to load
     * @param doAromaticity If true, then aromaticity perception is performed
     * @param doTyping      If true, atom typing and configuration is performed. This will use the internal CDK atom
     *                      typing scheme
     * @return An array of AtoContainer's
     * @throws CDKException if there is an error when reading a file
     */
    public static IAtomContainer[] loadMolecules(String[] filenames,
                                                 boolean doAromaticity,
                                                 boolean doTyping,
                                                 boolean doIsotopes) throws CDKException, IOException {
        Vector<IAtomContainer> v = new Vector<IAtomContainer>();
        IChemObjectBuilder builder = DefaultChemObjectBuilder.getInstance();
        try {
            int i;
            int j;

            for (i = 0; i < filenames.length; i++) {
                File input = new File(filenames[i]);
                ReaderFactory readerFactory = new ReaderFactory();
                ISimpleChemObjectReader reader = readerFactory.createReader(new FileReader(input));

                if (reader == null) { // see if it's a SMI file
                    if (filenames[i].endsWith(".smi")) {
                        reader = new SMILESReader(new FileReader(input));
                    }
                }
                IChemFile content = (IChemFile) reader.read(builder.newInstance(IChemFile.class));
                if (content == null) continue;

                List<IAtomContainer> c = ChemFileManipulator.getAllAtomContainers(content);

                // we should do this loop in case we have files
                // that contain multiple molecules
                v.addAll(c);
            }

        } catch (Exception e) {
            e.printStackTrace();
            throw new CDKException(e.toString());
        }

        // convert the vector to a simple array
        IAtomContainer[] retValues = new IAtomContainer[v.size()];
        for (int i = 0; i < v.size(); i++) {
            retValues[i] = v.get(i);
        }

        if (doTyping) {
            for (int i = 0; i < retValues.length; i++) {
                try {
                    AtomContainerManipulator.percieveAtomTypesAndConfigureAtoms(retValues[i]);
                } catch (CDKException e) {
                    retValues[i] = null;
                }
            }
        }

        // before returning, lets make see if we
        // need to perceive aromaticity and atom typing
        if (doAromaticity) {
            for (int i = 0; i < retValues.length; i++) {
                try {
                    CDKHueckelAromaticityDetector.detectAromaticity(retValues[i]);
                } catch (CDKException e) {
                    retValues[i] = null;
                }
            }
        }

        if (doIsotopes) {
            Isotopes ifac = Isotopes.getInstance();
            for (IAtomContainer retValue : retValues) {
                ifac.configureAtoms(retValue);
            }
        }

        return retValues;
    }

    public static IAtomContainer getMoleculeWithCoordinates(IAtomContainer molecule) throws Exception {
        StructureDiagramGenerator sdg = new StructureDiagramGenerator();
        sdg.setMolecule(molecule);
        sdg.generateCoordinates();
        return sdg.getMolecule();
    }

    public static IAtomContainer getMcsAsNewContainerUIT(IAtomContainer mol1, IAtomContainer mol2) throws CDKException, CloneNotSupportedException {
        UniversalIsomorphismTester uit = new UniversalIsomorphismTester();
        List<IAtomContainer> overlaps = uit.getOverlaps(mol1, mol2);
        int maxmcss = -9999999;
        IAtomContainer maxac = null;
        for (IAtomContainer ac : overlaps) {
            if (ac.getAtomCount() > maxmcss) {
                maxmcss = ac.getAtomCount();
                maxac = ac;
            }
        }
        return maxac;
    }

    public static IAtomContainer getMcsAsNewContainer(IAtomContainer mol1, IAtomContainer mol2) throws CDKException, CloneNotSupportedException {
        Isomorphism mcs = new Isomorphism(org.openscience.cdk.smsd.interfaces.Algorithm.DEFAULT, true);
        mcs.init(mol1, mol2, true, true);
        mcs.setChemFilters(true, true, true);

        mol1 = mcs.getReactantMolecule();
        mol2 = mcs.getProductMolecule();

        IAtomContainer mcsmolecule = DefaultChemObjectBuilder.getInstance().newInstance(IAtomContainer.class, mol1);

        List<IAtom> atomsToBeRemoved = new ArrayList<IAtom>();
        for (IAtom atom : mcsmolecule.atoms()) {
            int index = mcsmolecule.getAtomNumber(atom);
            if (!mcs.getFirstMapping().containsKey(index)) {
                atomsToBeRemoved.add(atom);
            }
        }

        for (IAtom atom : atomsToBeRemoved) {
            mcsmolecule.removeAtomAndConnectedElectronContainers(atom);
        }

        return mcsmolecule;
    }

    public static int[][] getMcsAsAtomIndexMapping(IAtomContainer mol1, IAtomContainer mol2) throws CDKException {
        Isomorphism mcs = new Isomorphism(org.openscience.cdk.smsd.interfaces.Algorithm.DEFAULT, true);
        mcs.init(mol1, mol2, true, true);
        mcs.setChemFilters(true, true, true);
        int mcsSize = mcs.getFirstMapping().size();
        int[][] mapping = new int[mcsSize][2];
        int i = 0;
        for (Map.Entry map : mcs.getFirstMapping().entrySet()) {
            mapping[i][0] = (Integer) map.getKey();
            mapping[i][1] = (Integer) map.getValue();
            i++;
        }
        return mapping;
    }

    public static String getInChi(IAtomContainer mol) throws CDKException {
        InChIGeneratorFactory factory = InChIGeneratorFactory.getInstance();
        factory.setIgnoreAromaticBonds(true);
        InChIGenerator gen = factory.getInChIGenerator(mol);
        return gen.getInchi();
    }

    public static String getInChiKey(IAtomContainer mol) throws CDKException {
        InChIGeneratorFactory factory = InChIGeneratorFactory.getInstance();
        factory.setIgnoreAromaticBonds(true);
        InChIGenerator gen = factory.getInChIGenerator(mol);
        return gen.getInchiKey();
    }

    /**
     * Returns a depictor with default settings.
     *
     * @return A {@link RcdkDepictor} object with default values.
     * @throws IOException
     */
    public RcdkDepictor getDefaultDepictor() throws IOException {
        return new RcdkDepictor(300, 300, 1.3, "cow", "off", "on", true, false, 100, "");
    }

    public static void main(String[] args) throws Exception, CloneNotSupportedException, IOException {
        IAtomContainer[] mols = Misc.loadMolecules(new String[]{"/Users/guhar/Downloads/Benzene.sdf"}, true, true, true);

        SmilesParser sp = new SmilesParser(DefaultChemObjectBuilder.getInstance());

        IAtomContainer mol1 = sp.parseSmiles("c1cccc(COC(=O)NC(CC(C)C)C(=O)NC(CCc2ccccc2)C(=O)COC)c1");
        IAtomContainer mol2 = sp.parseSmiles("c1cccc(COC(=O)NC(CC(C)C)C(=O)NCC#N)c1");
        CDKHueckelAromaticityDetector.detectAromaticity(mol1);
        CDKHueckelAromaticityDetector.detectAromaticity(mol2);
        AtomContainerManipulator.percieveAtomTypesAndConfigureAtoms(mol2);
        AtomContainerManipulator.percieveAtomTypesAndConfigureAtoms(mol1);
        int[][] map = getMcsAsAtomIndexMapping(mol1, mol2);
        for (int i = 0; i < map.length; i++) {
            System.out.println(map[i][0] + " <-> " + map[i][1]);
        }
    }
}
