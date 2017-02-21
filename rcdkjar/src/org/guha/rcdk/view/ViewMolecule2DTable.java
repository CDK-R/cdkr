package org.guha.rcdk.view;

import org.guha.rcdk.util.Misc;
import org.guha.rcdk.view.table.StructureTableCellEditor2D;
import org.guha.rcdk.view.table.StructureTableCellRenderer2D;
import org.guha.rcdk.view.table.StructureTableModel;
import org.guha.rcdk.view.panels.MoleculeCell;
import org.openscience.cdk.aromaticity.CDKHueckelAromaticityDetector;
import org.openscience.cdk.exception.CDKException;
import org.openscience.cdk.interfaces.IAtomContainer;
import org.openscience.cdk.tools.manipulator.AtomContainerManipulator;

import javax.swing.*;
import javax.swing.table.DefaultTableCellRenderer;
import javax.swing.table.TableColumn;
import java.awt.*;
import java.io.IOException;


class RowLabelRenderer extends DefaultTableCellRenderer {
    public RowLabelRenderer() {
        super();
        setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
    }
}

class StructureTable2D {

    private IAtomContainer[] v;
    boolean withHydrogen = true;
    private int cellx = 200;
    private int celly = 200;
    private int ncol = 4; // excludes the 1st column for row numbers

    public StructureTable2D(IAtomContainer[] structs) {
        this.v = structs;
    }

    public StructureTable2D(IAtomContainer[] structs, int ncol, boolean withHydrogen) {
        this.v = structs;
        this.ncol = ncol;
        this.withHydrogen = withHydrogen;
    }

    public StructureTable2D(IAtomContainer[] structs, int ncol, int cellx, int celly, boolean withHydrogen) {
        this.v = structs;
        this.ncol = ncol;
        this.cellx = cellx;
        this.celly = celly;
        this.withHydrogen = withHydrogen;
    }

    public void display() throws IOException, CDKException {

        int i = 0;
        int j = 0;
        int pad = 10;

        Object[][] ndata;
        String[] nm = new String[this.ncol + 1];

        int extra = v.length % this.ncol;
        int block = v.length - extra;
        int nrow = block / this.ncol;

        if (extra == 0) {
            ndata = new Object[nrow][this.ncol + 1];
        } else {
            ndata = new Object[nrow + 1][this.ncol + 1];
        }

        int cnt = 0;
        for (i = 0; i < nrow; i++) {
            for (j = 1; j < this.ncol + 1; j++) {
                ndata[i][j] = new MoleculeCell(v[cnt], this.cellx, this.celly, 1.3, "cow", "off", "reagents",
                                true, false, 100, "");
                cnt += 1;
            }
        }
        j = 1;
        while (cnt < v.length) {
            ndata[nrow][j] = new MoleculeCell(v[cnt], this.cellx, this.celly, 1.3, "cow", "off", "reagents",
                            true, false, 100, "");
            cnt += 1;
            j += 1;
        }

        if (extra != 0) nrow += 1;

        for (i = 0; i < nrow; i++) {
            ndata[i][0] = i * this.ncol + 1;
        }

        JFrame frame = new JFrame("2D Structure Grid");
        frame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);

        JTable mtable = new JTable(new StructureTableModel(ndata, nm));
        mtable.setShowGrid(true);

        // set row heights
        for (i = 0; i < nrow; i++) {
            mtable.setRowHeight(i, this.celly);
        }

        // disallow cell selections
        mtable.setColumnSelectionAllowed(false);
        mtable.setRowSelectionAllowed(false);

        // set the TableCellRenderer for the all columns
        // we also set up a TableCellEditor so that events on a render2dPanel
        // cell get forwarded to the actual render2dPanel. Right now this does nothing
        TableColumn col = mtable.getColumnModel().getColumn(0);
        col.setCellRenderer(new RowLabelRenderer());
        for (i = 1; i < this.ncol + 1; i++) {
            col = mtable.getColumnModel().getColumn(i);
            col.setCellRenderer(new StructureTableCellRenderer2D());
            col.setCellEditor(new StructureTableCellEditor2D());
        }

        // set up scroll bars
        JScrollPane scrollpane = new JScrollPane(mtable, JScrollPane.VERTICAL_SCROLLBAR_AS_NEEDED, JScrollPane.HORIZONTAL_SCROLLBAR_AS_NEEDED);
        if (nrow > 3) {
            mtable.setPreferredScrollableViewportSize(new Dimension(this.ncol * this.cellx + pad, 3 * this.celly + pad));
        } else {
            mtable.setPreferredScrollableViewportSize(new Dimension(this.ncol * this.cellx + pad, nrow * this.celly + pad));
        }
        frame.getContentPane().add(scrollpane);

        // start the show!
        frame.pack();
        if (nrow > 3) {
            frame.setSize(this.ncol * this.cellx + pad, 3 * this.celly + pad);
        } else {
            frame.setSize(this.ncol * this.cellx + pad, nrow * this.celly + pad);
        }

        frame.setVisible(true);
    }
}

public class ViewMolecule2DTable {
    public ViewMolecule2DTable(IAtomContainer[] molecules, int ncol, int cellx, int celly) {

        // set some default values
        boolean showH = false;

        try {
            IAtomContainer[] v = new IAtomContainer[molecules.length];
            for (int i = 0; i < v.length; i++) {
                CDKHueckelAromaticityDetector.detectAromaticity(molecules[i]);
                v[i] = AtomContainerManipulator.removeHydrogens(molecules[i]);
                v[i] = Misc.getMoleculeWithCoordinates(v[i]);
            }

            // some checks for visual niceness
            if (v.length < ncol) {
                StructureTable2D st = new StructureTable2D(v, v.length, cellx, celly, showH);
                st.display();
            } else {
                StructureTable2D st = new StructureTable2D(v, ncol, cellx, celly, showH);
                st.display();
            }

        } catch (Exception e) {
            System.out.println(e);
        }
    }

    public static void main(String[] args) {
        String home = "/Users/rguha/";
        String[] fname = {home + "src/R/trunk/rcdk/data/dan001.sdf",
                home + "src/R/trunk/rcdk/data/dan002.sdf",
                home + "src/R/trunk/rcdk/data/dan003.sdf"};
        IAtomContainer[] acs = null;
        try {
            acs = Misc.loadMolecules(fname, true, true, true);
        } catch (CDKException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        }

        try {
            acs = Misc.loadMolecules(fname, true, false, true);
        } catch (CDKException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        }
        ViewMolecule2DTable v2dt = new ViewMolecule2DTable(acs, 3, 200, 200);

    }
}
