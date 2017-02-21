package org.guha.rcdk.view;

import org.guha.rcdk.util.Misc;
import org.guha.rcdk.view.panels.MoleculeCell;
import org.guha.rcdk.view.table.MyTable;
import org.guha.rcdk.view.table.StructureTableCellEditor2D;
import org.guha.rcdk.view.table.StructureTableCellRenderer2D;
import org.openscience.cdk.aromaticity.CDKHueckelAromaticityDetector;
import org.openscience.cdk.exception.CDKException;
import org.openscience.cdk.interfaces.IAtomContainer;
import org.openscience.cdk.tools.manipulator.AtomContainerManipulator;

import javax.swing.*;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ListSelectionEvent;
import javax.swing.event.TableColumnModelEvent;
import javax.swing.event.TableColumnModelListener;
import javax.swing.table.AbstractTableModel;
import javax.swing.table.DefaultTableCellRenderer;
import javax.swing.table.TableCellRenderer;
import javax.swing.table.TableColumn;
import java.awt.*;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.io.IOException;

public class ViewMolecule2DDataTable {

    private static int STRUCTURE_COL = 0;

    private IAtomContainer[] molecules;
    private String[] cnames;
    private Object[][] tabledata;

    private int fontSize = 14;
    private int cellx = 200;
    private int celly = 200;
    private int ncol;
    private int nrow;

    private JFrame frame;

    class ApplicationCloser extends WindowAdapter {
        public void windowClosing(WindowEvent e) {
            frame.dispose();
        }
    }

    class RowLabelRenderer extends DefaultTableCellRenderer {
        public RowLabelRenderer() {
            super();
            setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
            setVerticalAlignment(javax.swing.SwingConstants.VERTICAL);
        }
    }

    public ViewMolecule2DDataTable(String[] fnames, String[] cnames,
                                   Object[][] tabledata) {
        try {
            molecules = Misc.loadMolecules(fnames, true, true, true);
        } catch (CDKException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        }
        frame = new JFrame("Table of Molecules");
        frame.addWindowListener(new ApplicationCloser());
        this.cnames = cnames;
        this.tabledata = tabledata;
    }

    public ViewMolecule2DDataTable(IAtomContainer[] molecules, String[] cnames,
                                   Object[][] tabledata) {
        frame = new JFrame("Table of Molecules");
        frame.addWindowListener(new ApplicationCloser());
        this.cnames = cnames;
        this.tabledata = tabledata;
        this.molecules = molecules;
    }

    public void setCellX(int cellx) {
        this.cellx = cellx;
    }

    public void setCellY(int celly) {
        this.celly = celly;
    }

    public void setFontSize(int f) {
        fontSize = f;
    }

    public void display() throws IOException, CDKException {

        ncol = cnames.length;
        nrow = molecules.length;

        Object[][] data = new Object[molecules.length][cnames.length];

        for (int i = 0; i < molecules.length; i++) {
            try {
                CDKHueckelAromaticityDetector.detectAromaticity(molecules[i]);
                molecules[i] = Misc.getMoleculeWithCoordinates(molecules[i]);
                molecules[i] = AtomContainerManipulator.removeHydrogens(molecules[i]);
            } catch (CDKException e) {
                e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
            } catch (Exception e) {
                e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
            }
            data[i][0] = new MoleculeCell(molecules[i], this.cellx, this.celly);
        }
        // set the data
        for (int i = 0; i < molecules.length; i++) {
            for (int j = 1; j < cnames.length; j++) {
                data[i][j] = tabledata[i][j - 1];
            }
        }

        MyTable mtable = new MyTable(new Render2DPanelJTableModel(data, cnames));
        mtable.setShowGrid(true);
        mtable.getTableHeader().setFont(new Font("Lucida", Font.BOLD, fontSize));

        // disable movement of columns. This is needed since we
        // set the CellRenderer and CellEditor for a specific column
        mtable.getTableHeader().setReorderingAllowed(false);

        // set row heights
        for (int i = 0; i < molecules.length; i++) {
            mtable.setRowHeight(i, celly);
        }
        mtable.getColumnModel().getColumn(STRUCTURE_COL).setPreferredWidth(cellx);

        // add a TableolumnModelListener so we can catch column
        // resizes and change row heights accordingly
        mtable.getColumnModel().addColumnModelListener(new Render2DColumnModelListener(mtable));

        // allow cell selections
        mtable.setColumnSelectionAllowed(true);
        mtable.setRowSelectionAllowed(true);

        // set up scroll bars
        JScrollPane scrollpane = new JScrollPane(mtable);
        scrollpane.setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_ALWAYS);
        mtable.setPreferredScrollableViewportSize(new Dimension(ncol * cellx, nrow));
        frame.getContentPane().add(scrollpane);

        // set the cell renderer for the structure column
        // we also set up a TableCellEditor so that events on a JmolPanel
        // cell get forwarded to the actual JmolPanel
        TableColumn col = mtable.getColumnModel().getColumn(0);
        col.setCellRenderer(new StructureTableCellRenderer2D());
        col.setCellEditor(new StructureTableCellEditor2D());

        RowLabelRenderer myRowRenderer = new RowLabelRenderer();
        for (int i = 1; i < ncol; i++) {
            col = mtable.getColumnModel().getColumn(i);
            col.setCellRenderer(myRowRenderer);
        }

        // start the show!
        frame.pack();
        frame.setSize(cellx * (ncol > 3 ? 3 : ncol), celly);
        frame.setVisible(true);

        //mtable.pack(TablePacker.VISIBLE_ROWS, true);
    }

    static class Render2DColumnModelListener implements TableColumnModelListener {
        JTable table;

        public Render2DColumnModelListener(JTable t) {
            this.table = t;
        }

        public void columnAdded(TableColumnModelEvent e) {
        }

        public void columnRemoved(TableColumnModelEvent e) {
        }

        public void columnMoved(TableColumnModelEvent e) {
        }

        public void columnMarginChanged(ChangeEvent e) {
//            int colwidth = this.table.getColumnModel().getColumn(STRUCTURE_COL).getWidth();
//            for (int i = 0; i < this.table.getRowCount(); i++) {
//                this.table.setRowHeight(i, colwidth);
//            }

        }

        public void columnSelectionChanged(ListSelectionEvent e) {
        }
    }

    static class Render2DPanelJTableModel extends AbstractTableModel {

        private static final long serialVersionUID = -1029080447213047474L;

        private Object[][] rows;

        private String[] columns;

        public Render2DPanelJTableModel(Object[][] objs, String[] cols) {
            rows = objs;
            columns = cols;
        }

        public String getColumnName(int column) {
            return columns[column];
        }

        public int getRowCount() {
            return rows.length;
        }

        public int getColumnCount() {
            return columns.length;
        }

        public Object getValueAt(int row, int column) {
            return rows[row][column];
        }

        public boolean isCellEditable(int row, int column) {
            return column == STRUCTURE_COL;
        }

        public Class getColumnClass(int column) {
            return getValueAt(0, column).getClass();
        }
    }

    static class Render2DPanelCellRenderer extends JPanel implements
            TableCellRenderer {

        private static final long serialVersionUID = 3990689120717795379L;

        public Component getTableCellRendererComponent(JTable table,
                                                       Object value, boolean isSelected, boolean hasFocus,
                                                       int rowIndex, int vColIndex) {
            // return plist[rowIndex];
            return (MoleculeCell) value;
        }

        // The following methods override the defaults for performance reasons
        public void validate() {
        }

        public void revalidate() {
        }

        protected void firePropertyChange(String propertyName, Object oldValue,
                                          Object newValue) {
        }

        public void firePropertyChange(String propertyName, boolean oldValue,
                                       boolean newValue) {
        }
    }


    public static void main(String[] args) throws IOException, CDKException {
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

        String[] cnames = {"X", "Y", "Z", "A", "B", "C"};
        Object[][] dat = new Object[3][5];
        for (int i = 0; i < 3; i++) {
            dat[i][0] = new Integer(i);
            dat[i][1] = new Double(i) / 3.4;
            dat[i][2] = "Hello " + i;
            dat[i][3] = "By " + i;
            dat[i][4] = 3;
        }
        ViewMolecule2DDataTable d = new ViewMolecule2DDataTable(acs, cnames, dat);
        d.display();
    }
}