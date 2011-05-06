package org.guha.rcdk.test;

import junit.framework.Assert;
import junit.framework.TestCase;
import org.guha.rcdk.util.Misc;
import org.openscience.cdk.CDKConstants;
import org.openscience.cdk.ChemFile;
import org.openscience.cdk.DefaultChemObjectBuilder;
import org.openscience.cdk.exception.CDKException;
import org.openscience.cdk.exception.InvalidSmilesException;
import org.openscience.cdk.interfaces.IAtomContainer;
import org.openscience.cdk.io.MDLV2000Reader;
import org.openscience.cdk.io.SDFWriter;
import org.openscience.cdk.isomorphism.UniversalIsomorphismTester;
import org.openscience.cdk.isomorphism.mcss.RMap;
import org.openscience.cdk.smiles.SmilesParser;
import org.openscience.cdk.tools.manipulator.AtomContainerManipulator;
import org.openscience.cdk.tools.manipulator.ChemFileManipulator;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.StringWriter;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Vector;

public class MiscTest extends TestCase {
    String home = "/Users/guhar/";

    public void testLoadMolecules() {
        String[] fname = {home + "src/cdkr/rcdk/data/dan001.hin",
                home + "src/cdkr/rcdk/data/dan007.xyz",
                home + "src/cdkr/rcdk/data/dan008.hin"};
        IAtomContainer[] acs = null;
        try {
            acs = Misc.loadMolecules(fname, true, true, true);
        } catch (CDKException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        }

        Assert.assertEquals(3, acs.length);

    }

    public void testTotalCharge() throws InvalidSmilesException {
        String smi = "[H]C(COC(=O)CCCCCCCCCCC)(COP(O)(=O)OCC[N+](C)(C)C)OC(=O)CCCCCCCCCCCC";
        SmilesParser sp = new SmilesParser(DefaultChemObjectBuilder.getInstance());
        IAtomContainer mol = sp.parseSmiles(smi);
        double tc = AtomContainerManipulator.getTotalCharge(mol);
        System.out.println("tc = " + tc);
    }

    public void testLoadMolsFromSmi() {
        IAtomContainer[] acs = null;
        try {
            acs = Misc.loadMolecules(new String[]{"/Users/rguha/src/R/trunk/rcdk/data/big.smi"}, true, true, true);
        } catch (CDKException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        }

        assert acs != null;
        Assert.assertEquals(277, acs.length);

    }

    public void testWriteMoleculesDirectly() throws InvalidSmilesException, CDKException, IOException {
        SmilesParser sp = new SmilesParser(DefaultChemObjectBuilder.getInstance());
        IAtomContainer mol = sp.parseSmiles("CCCCCCC");
        mol.setProperty(CDKConstants.TITLE, "FooMolecule");
        mol.setProperty("foo", "bar");


        StringWriter sw = new StringWriter();
        SDFWriter writer = new SDFWriter(sw);
        writer.write(mol);
        writer.close();
        Assert.assertNotNull(sw.toString());
        Assert.assertFalse(sw.toString().equals(""));
        Assert.assertTrue(sw.toString().indexOf("FooMolecule") == 0);
        Assert.assertTrue(sw.toString().indexOf("<foo>") > 0);
    }

    public void testWriteMolecules() throws Exception {
        SmilesParser sp = new SmilesParser(DefaultChemObjectBuilder.getInstance());
        IAtomContainer mol = sp.parseSmiles("CCCCCCC");
        mol.setProperty(CDKConstants.TITLE, "FooMolecule");
        mol.setProperty("foo", "bar");

        Misc.writeMoleculesInOneFile(new IAtomContainer[]{mol}, "/Users/rguha/foo.sdf", 0);
    }

//    public void testjunk() throws FileNotFoundException, CDKException, CloneNotSupportedException {
//        ISimpleChemObjectReader reader = new MDLV2000Reader(new FileReader("/Users/rguha/tmp/frog.sdf"));
//        IChemFile content = (IChemFile) reader.read(DefaultChemObjectBuilder.getInstance().newChemFile();
//        List<IAtomContainer> c = ChemFileManipulator.getAllAtomContainers(content);
//
//        IAtomContainer m1 = c.get(0);
//        IAtomContainer m2 = c.get(1);
//
//        m1 = AtomContainerManipulator.removeHydrogens(m1);
//        m2 = AtomContainerManipulator.removeHydrogens(m2);
//
//        List<IAtomContainer> maps = UniversalIsomorphismTester.getOverlaps(m1, m2);
//        System.out.println("maps.size() = " + maps.size());
//        IAtomContainer mcss = null;
//        int natom = -1;
//        for (IAtomContainer map : maps) {
//            if (map.getAtomCount() > natom) {
//                natom = map.getAtomCount();
//                mcss = (IAtomContainer) map.clone();
//            }
//        }
//        System.out.println("mcss.getAtomCount() = " + mcss.getAtomCount());
////        KabschAlignment ka = new KabschAlignment();
//    }

    public static IAtomContainer getneedle(IAtomContainer a, IAtomContainer q) throws CDKException {
//        IAtomContainer needle = DefaultChemObjectBuilder.getInstance().newInstance(IAtomContainer.class);
        IAtomContainer needle = DefaultChemObjectBuilder.getInstance().newInstance(IAtomContainer.class);
        Vector idlist = new Vector();

        List l = UniversalIsomorphismTester.getSubgraphMaps(a, q);
        List maplist = (List) l.get(0);
        for (Iterator i = maplist.iterator(); i.hasNext();) {
            RMap rmap = (RMap) i.next();
            idlist.add(new Integer(rmap.getId1()));
        }

        HashSet hs = new HashSet(idlist);
        for (Iterator i = hs.iterator(); i.hasNext();) {
            needle.addBond(a.getBond(((Integer) i.next()).intValue()));
        }
        return needle;
    }

    public void testExactMass() throws InvalidSmilesException {
        SmilesParser sp = new SmilesParser(DefaultChemObjectBuilder.getInstance());
        IAtomContainer mol = sp.parseSmiles("CCCCCCC");
        double d = AtomContainerManipulator.getTotalExactMass(mol);
        System.out.println("d = " + d);
    }

    public void testGetProps() throws FileNotFoundException, CDKException {
        String[] fname = {home + "src/cdkr/data/kegg.sdf"};
        IAtomContainer[] acs = null;
        try {
            acs = Misc.loadMolecules(fname, true, true, true);
        } catch (CDKException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        }

        Assert.assertEquals(10, acs.length);

        MDLV2000Reader reader = new MDLV2000Reader(new FileReader(fname[0]));
        ChemFile o = reader.read(DefaultChemObjectBuilder.getInstance().newInstance(ChemFile.class));
        List<IAtomContainer> mols = ChemFileManipulator.getAllAtomContainers(o);
        Map<Object, Object> props = mols.get(0).getProperties();
        for (Map.Entry entry : props.entrySet()) {
            System.out.println(entry.getKey() + " " + entry.getValue());
        }
    }


}
