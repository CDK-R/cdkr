/**
 *
 */
package org.guha.rcdk.util;

import org.openscience.cdk.DefaultChemObjectBuilder;
import org.openscience.cdk.aromaticity.CDKHueckelAromaticityDetector;
import org.openscience.cdk.config.IsotopeFactory;
import org.openscience.cdk.exception.CDKException;
import org.openscience.cdk.interfaces.IAtomContainer;
import org.openscience.cdk.interfaces.IChemFile;
import org.openscience.cdk.interfaces.IMolecule;
import org.openscience.cdk.interfaces.IChemObjectBuilder;
import org.openscience.cdk.io.ISimpleChemObjectReader;
import org.openscience.cdk.io.ReaderFactory;
import org.openscience.cdk.io.SDFWriter;
import org.openscience.cdk.io.SMILESReader;
import org.openscience.cdk.io.listener.PropertiesListener;
import org.openscience.cdk.layout.StructureDiagramGenerator;
import org.openscience.cdk.smiles.SmilesGenerator;
import org.openscience.cdk.tools.manipulator.AtomContainerManipulator;
import org.openscience.cdk.tools.manipulator.ChemFileManipulator;

import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.List;
import java.util.Properties;
import java.util.Vector;

/**
 * @author Rajarshi Guha
 */

public class Misc {

    public static void writeMoleculesInOneFile(IAtomContainer[] molecules,
                                               String filename,
                                               int writeProps) throws Exception {
        SDFWriter writer = new SDFWriter(new FileWriter(new File(filename)));
        if (writeProps == 0) {
            Properties sdfWriterProps = new Properties();
            sdfWriterProps.put("writeProperties", "false");
            writer.addChemObjectIOListener(new PropertiesListener(sdfWriterProps));
            writer.customizeJob();
        }
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
            if (writeProps == 0) {
                Properties sdfWriterProps = new Properties();
                sdfWriterProps.put("writeProperties", "false");
                writer.addChemObjectIOListener(
                        new PropertiesListener(sdfWriterProps)
                );
                writer.customizeJob();
            }
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
    public static String getSmiles(IAtomContainer container) {
        SmilesGenerator sg = new SmilesGenerator();
        sg.setUseAromaticityFlag(true);
        return sg.createSMILES((IMolecule) container);
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
                IChemFile content = (IChemFile) reader.read(builder.newChemFile());
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

        if (doTyping) {
            for (int i = 0; i < retValues.length; i++) {
                try {
                    AtomContainerManipulator.percieveAtomTypesAndConfigureAtoms(retValues[i]);
                } catch (CDKException e) {
                    retValues[i] = null;
                }
            }
        }

        if (doIsotopes) {
            IsotopeFactory ifac = IsotopeFactory.getInstance(DefaultChemObjectBuilder.getInstance());
            for (IAtomContainer retValue : retValues) {
                ifac.configureAtoms(retValue);
            }
        }

        return retValues;
    }

    public static IAtomContainer getMoleculeWithCoordinates(IAtomContainer molecule) throws Exception {
        StructureDiagramGenerator sdg = new StructureDiagramGenerator();
        sdg.setMolecule((IMolecule) molecule);
        sdg.generateCoordinates();
        return sdg.getMolecule();
    }

}
