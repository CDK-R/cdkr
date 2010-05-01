package org.guha.rcdk.util;

import javax.swing.*;
import javax.swing.table.TableColumn;
import javax.swing.table.TableColumnModel;
import java.awt.*;

/**
 * MySwing: Advanced Swing Utilites
 * Copyright (C) 2005  Santhosh Kumar T
 * <p/>
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 * <p/>
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * @author Santhosh Kumar T
 */
public class TablePacker {
    public static final int VISIBLE_ROWS = 0;
    public static final int ALL_ROWS = 1;
    public static final int NO_ROWS = 2;

    private int rowsIncluded = VISIBLE_ROWS;
    private boolean distributeExtraArea = true;

    public TablePacker(int rowsIncluded, boolean distributeExtraArea) {
        this.rowsIncluded = rowsIncluded;
        this.distributeExtraArea = distributeExtraArea;
    }

    private int preferredWidth(JTable table, int col) {
        TableColumn tableColumn = table.getColumnModel().getColumn(col);
        int width = (int) table.getTableHeader().getDefaultRenderer()
                .getTableCellRendererComponent(table, tableColumn.getIdentifier()
                        , false, false, -1, col).getPreferredSize().getWidth();

        if (table.getRowCount() != 0) {
            int from = 0, to = 0;
            if (rowsIncluded == VISIBLE_ROWS) {
                Rectangle rect = table.getVisibleRect();
                from = table.rowAtPoint(rect.getLocation());
                to = table.rowAtPoint(new Point((int) rect.getMaxX(), (int) rect.getMaxY())) + 1;
            } else if (rowsIncluded == ALL_ROWS) {
                from = 0;
                to = table.getRowCount();
            }
            for (int row = from; row < to; row++) {
                int preferedWidth = (int) table.getCellRenderer(row, col).getTableCellRendererComponent(table,
                        table.getValueAt(row, col), false, false, row, col).getPreferredSize().getWidth();
                width = Math.max(width, preferedWidth);
            }
        }
        return width + table.getIntercellSpacing().width;
    }

    public void pack(JTable table) {
        if (!table.isShowing())
            throw new IllegalStateException("table must be showing to pack");

        if (table.getColumnCount() == 0)
            return;

        int width[] = new int[table.getColumnCount()];
        int total = 0;
        for (int col = 0; col < width.length; col++) {
            width[col] = preferredWidth(table, col);
            total += width[col];
        }

        int extra = table.getVisibleRect().width - total;
        if (extra > 0) {
            if (distributeExtraArea) {
                int bonus = extra / table.getColumnCount();
                for (int i = 0; i < width.length; i++)
                    width[i] += bonus;
                extra -= bonus * table.getColumnCount();
            }
            width[width.length - 1] += extra;
        }

        TableColumnModel columnModel = table.getColumnModel();
        for (int col = 0; col < width.length; col++) {
            TableColumn tableColumn = columnModel.getColumn(col);
            table.getTableHeader().setResizingColumn(tableColumn);
            tableColumn.setWidth(width[col]);
        }
    }
}
