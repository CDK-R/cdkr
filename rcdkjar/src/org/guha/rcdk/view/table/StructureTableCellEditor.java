package org.guha.rcdk.view.table;

import javax.swing.*;
import javax.swing.table.TableCellEditor;

/**
 * @author Rajarshi Guha
 */

public abstract class StructureTableCellEditor extends AbstractCellEditor implements TableCellEditor {

    public Object getCellEditorValue() {
        return new Object();
    }

    public boolean isCellEditable(int row, int column) {
        return false;
    }

    public boolean stopCellEditing() {
        return true;
    }
}
