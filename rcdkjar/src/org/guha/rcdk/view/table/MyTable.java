package org.guha.rcdk.view.table;

import org.guha.rcdk.util.TablePacker;

import javax.swing.*;
import javax.swing.table.TableModel;


public class MyTable extends JTable {
    private TablePacker packer = null;

    /**
     * Constructs a <code>JTable</code> to display the values in the two dimensional array,
     * <code>rowData</code>, with column names, <code>columnNames</code>.
     * <code>rowData</code> is an array of rows, so the value of the cell at row 1,
     * column 5 can be obtained with the following code:
     * <p/>
     * <pre> rowData[1][5]; </pre>
     * <p/>
     * All rows must be of the same length as <code>columnNames</code>.
     * <p/>
     *
     * @param rowData     the data for the new table
     * @param columnNames names of each column
     */
    public MyTable(Object[][] rowData, Object[] columnNames) {
        super(rowData, columnNames);
    }

    /**
     * Constructs a <code>JTable</code> that is initialized with
     * <code>dm</code> as the data model, a default column model,
     * and a default selection model.
     *
     * @param dm the data model for the table
     * @see #createDefaultColumnModel
     * @see #createDefaultSelectionModel
     */
    public MyTable(TableModel dm) {
        super(dm);
    }


    public void pack(int rowsIncluded, boolean distributeExtraArea) {
        packer = new TablePacker(rowsIncluded, distributeExtraArea);
        if (isShowing()) {
            packer.pack(this);
            packer = null;
        }
    }

    public void addNotify() {
        super.addNotify();
        if (packer != null) {
            packer.pack(this);
            packer = null;
        }
    }

}
