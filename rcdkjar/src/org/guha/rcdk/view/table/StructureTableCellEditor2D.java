package org.guha.rcdk.view.table;

import org.guha.rcdk.view.panels.MoleculeCell;

import javax.swing.*;
import java.awt.*;

/**
 * @author Rajarshi Guha
 */
public class StructureTableCellEditor2D extends StructureTableCellEditor {
      public Component getTableCellEditorComponent(JTable table, Object value, boolean isSelected, int row, int column) {
        if (column != 0) {
            return (MoleculeCell) value;
        }
        return (MoleculeCell) value;
    }
}
