package org.guha.rcdk.view.table;

import javax.swing.table.AbstractTableModel;

/**
 * @author Rajarshi Guha
 */

public class StructureTableModel extends AbstractTableModel {
    private Object[][] rows;
    private String[] columns;

    public StructureTableModel(Object[][] objs, String[] cols) {
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
        return true;
    }

    public Class getColumnClass(int column) {
        return getValueAt(0, column).getClass();
    }
}
