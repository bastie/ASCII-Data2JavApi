/*
 * SPDX-License-Identifier: Apache-2.0
 */

import JavApi

extension com.mitchtalmadge.asciidata.table {
  
  //import com.mitchtalmadge.asciidata.table.formats.TableFormatAbstract;
  //import com.mitchtalmadge.asciidata.table.formats.UTF8TableFormat;
  
  /**
   * A table created entirely from ASCII characters, such as pipes.
   * Printable to a console, chat server, or anywhere else where text-style tables are convenient.
   *
   * @author MitchTalmadge
   * @author JakeWharton
   * @author bitsofinfo
   */
  public class ASCIITable {
    
    private let headers : [String];
    private let data : [[String]];
    private let columnsCount : Int;
    private var columnWidths : [Int];
    private var aligns : [Align];
    private let emptyWidth : Int;
    private let emptyMessage = "(empty)";
    private var nullValue = "";
    
    /**
     * How the table will be displayed. Defines which characters to be used.
     * Defaults to {@link UTF8TableFormat}.
     */
    private var tableFormat : com.mitchtalmadge.asciidata.table.formats.TableFormatAbstract = com.mitchtalmadge.asciidata.table.formats.UTF8TableFormat();
    
    /**
     * Creates a new table using the given headers and data.
     *
     * @param headers The headers of the table. Each index is a new column, in order from left to right.
     * @param data    The data of the table, in the format String[row][column]. Newlines are allowed.
     * @return A new ASCIITable instance that can be printed using the {@link ASCIITable#toString()}.
     */
    public static func fromData(_ headers : [String], _ data : [[String]] = [[String]]()) throws -> ASCIITable {
      // Ensure we have headers.
      guard headers.length != 0 else {
        throw Throwable.IllegalArgumentException("No headers were supplied.");
      }
      // Create an ASCIITable instance.
      return try ASCIITable(headers, data);
    }
    
    /**
     * Constructs a new ASCIITable from the given headers and data.
     *
     * @param headers The headers of the table.
     * @param data    The data of the table.
     */
    private init(_ headers : [String], _ data : [[String]]) throws {
      self.headers = headers;
      self.data = data;
      
      // The number of columns in the table is equivalent to the number of headers.
      columnsCount = headers.count;
      
      // Calculate the max width of each column in the table.
      columnWidths = Array(repeating: 0, count: columnsCount);
      for row in 0..<(data.count + 1) {
        // The first row is for the headers.
        let rowData : [String] = row == 0 ? headers : data[row - 1];
        
        // Make sure we have enough columns.
        if (rowData.count != columnsCount) {
          throw Throwable.IllegalArgumentException("The number of columns in row \(row - 1)  (\(rowData.length)) do not match the number of headers (\(columnsCount))");
        }
        
        // Iterate over each column in the row to get its width, and compare it to the maximum.
        for column in 0..<columnsCount {
          // Check the length of each line in the cell.
          for rowDataLine in rowData[column].split("\n") {
            // Compare to the current max width.
            columnWidths[column] = Math.max(columnWidths[column], rowDataLine.count);
          }
        }
      }
      
      aligns = Array(repeating: Align.LEFT, count: columnsCount);
      
      // Determine the width of everything including borders.
      // This is to be used in case there is no data and we must write the empty message to the table.
      
      // Account for borders
      var emptyWidth : Int = 3 * (columnsCount - 1);
      // Add the width of each column.
      for columnWidth in columnWidths {
        emptyWidth += columnWidth;
      }
      self.emptyWidth = emptyWidth;
      
      // Make sure we have enough space for the empty message.
      if emptyWidth < emptyMessage.count {
        columnWidths[columnsCount - 1] += emptyMessage.count - emptyWidth;
      }
    }
    
    /**
     * Changes the format of the table (how it will be displayed; which characters to use) to the provided format.
     *
     * @param tableFormat The format to use. By default, the table will already use {@link UTF8TableFormat}.
     * @return This ASCIITable instance.
     */
    public func withTableFormat(_ tableFormat : TableFormatAbstract) -> ASCIITable{
      self.tableFormat = tableFormat;
      return self;
    }
    
    /**
     * Changes the value used for rendering <code>null</code> data.
     *
     * @param nullValue The nullValue to use. By default, the table will use an empty string (<code>""</code>).
     * @return This ASCIITable instance.
     */
    public func withNullValue(_ nullValue : String) -> ASCIITable{
      self.nullValue = nullValue;
      return self;
    }
    
    public func alignColumn(_ column : Int, _ align : Align) -> ASCIITable {
      self.aligns[column] = align;
      return self;
    }
    
    public func toString() -> String{
      var output = StringBuilder();
      
      // Append the table's top horizontal divider.
      appendHorizontalDivider(&output,
                              tableFormat.getTopLeftCorner(),
                              tableFormat.getHorizontalBorderFill(true, false),
                              tableFormat.getTopEdgeBorderDivider(),
                              tableFormat.getTopRightCorner());
      
      // Append the headers of the table.
      appendRow(&output, headers, true);
      
      // Check if the data is empty, in which case, we will only write the empty message into the table contents.
      if (data.length == 0) {
        // Horizontal divider below the headers
        appendHorizontalDivider(&output, tableFormat.getLeftEdgeBorderDivider(true),
                                tableFormat.getHorizontalBorderFill(false, true),
                                tableFormat.getCross(true, true),
                                tableFormat.getRightEdgeBorderDivider(true));
        
        // Empty message row
        output = output.append(tableFormat.getVerticalBorderFill(true))
          .append(com.mitchtalmadge.asciidata.table.ASCIITable.pad(emptyWidth, Align.LEFT, emptyMessage))
          .append(tableFormat.getVerticalBorderFill(true))
          .append("\n");
        
        // Horizontal divider at the bottom of the table.
        appendHorizontalDivider(&output,
                                tableFormat.getBottomLeftCorner(),
                                tableFormat.getHorizontalBorderFill(true, false),
                                tableFormat.getHorizontalBorderFill(true, false),
                                tableFormat.getBottomRightCorner());
        
        return output.toString();
      }
      
      // The data is not empty, so iterate over each row.
      for row in 0..<data.length {
        
        // The first row has a different style of border than the others.
        if (row == 0) {
          appendHorizontalDivider(&output,
                                  tableFormat.getLeftEdgeBorderDivider(true),
                                  tableFormat.getHorizontalBorderFill(false, true),
                                  tableFormat.getCross(true, false),
                                  tableFormat.getRightEdgeBorderDivider(true));
        }
        else {
          appendHorizontalDivider(&output,
                                  tableFormat.getLeftEdgeBorderDivider(false),
                                  tableFormat.getHorizontalBorderFill(false, false),
                                  tableFormat.getCross(false, false),
                                  tableFormat.getRightEdgeBorderDivider(false));
        }
        // Append the data for the current row.
        appendRow(&output, data[row], false);
      }
      
      // Horizontal divider at the bottom of the table.
      appendHorizontalDivider(&output,
                              tableFormat.getBottomLeftCorner(),
                              tableFormat.getHorizontalBorderFill(true, false),
                              tableFormat.getBottomEdgeBorderDivider(),
                              tableFormat.getBottomRightCorner());
      
      return output.toString();
    }
    
    /**
     * Appends the given data as a row to the output with appropriate borders.
     *
     * @param output The output to append to.
     * @param data   The data of the row to append. Each index corresponds to a column.
     */
    private func appendRow(_ output : inout StringBuilder, _ data : [String], _ isHeader : Bool) {
      // Step 1: Determine the row height from the maximum number of lines out of each cell.
      var rowHeight = 0;
      for column in 0..<columnsCount {
        // The height of this cell.
        let cellHeight : Int = data[column].split("\n").length;
        // Choose the greatest.
        rowHeight = Math.max(rowHeight, cellHeight);
      }
      
      // Step 2: Append the data to the output.
      // Iterate over each line of text, using the row height calculated earlier.
      for line in 0..<rowHeight {
        
        // For each column...
        for column in 0..<columnsCount {
          
          // Either add the left or the middle borders, depending on the location of the column.
          output = output.append(tableFormat.getVerticalBorderFill(column == 0));
          
          // Split the data on its newlines to determine the contents of each line in the column.
          let cellLines : [String] = data[column].split("\n")
          
          // Decide what to put into this column. Use empty data if there is no specific data for this column.
          let cellLine : String = line < cellLines.count ? cellLines[line] : "";
          
          // Pad and append the data.
          var align = Align.LEFT;
          if (!isHeader) {
            align = aligns[column];
          }
          output = output.append(com.mitchtalmadge.asciidata.table.ASCIITable.pad(columnWidths[column], align, cellLine));
        }
        
        // Add the right border.
        output = output.append(tableFormat.getVerticalBorderFill(true)).append("\n");
      }
    }
    
    private func nullSafeData(_ data : String) -> String{
      return data
    }
    private func nullSafeData(_ data : String?) -> String{
      return data == nil ? nullValue : data!;
    }

    /**
     * Appends a horizontal divider to the output using the given characters.
     * <p>
     * Example output: (L = Left, F = Fill, M = Middle, R = Right)
     * ╚════╧═══════╧════╧═══════╝
     * LFFFMFFFFFFMFFFMFFFFFFR
     *
     * @param output The output to append to.
     * @param left   The left border character.
     * @param fill   The fill border character.
     * @param middle The middle border character.
     * @param right  The right border character.
     */
    private func appendHorizontalDivider(_ output : inout StringBuilder, _ left : Character, _ fill : Character, _ middle : Character, _ right : Character) {
      
      // For each column...
      for column in 0..<columnsCount {
        // Either add the left or the middle borders, depending on the location of the column.
        output = output.append(column == 0 ? left : middle);
        
        // For the contents of the column, create a padding of the correct width and replace it with the fill border.
        var t = com.mitchtalmadge.asciidata.table.ASCIITable.pad(columnWidths[column], Align.LEFT, "")
        t = t.replace(" ", fill)
        output = output.append(t);
      }
      
      // Add the right border
      output = output.append(right).append("\n");
    }
    
    /**
     * Pads the given data to the specified width using spaces.
     *
     * @param width The width desired.
     * @param data  The data to pad.
     * @return The data, padded with spaces to the given width.
     */
    private static func pad(_ width : Int, _ align : Align, _ data : String) -> String{
      var result : String
      if align == Align.LEFT {
        result = " \(data.padding(toLength: width, withPad: " ", startingAt: 0)) "
        //return String.format(" %1$-" + width + "s ", data);
      } else {
        result = String(data.reversed()).padding(toLength: width, withPad: " ", startingAt: 0)
        result = String (result.reversed())
        result = " \(result) "
        //return String.format(" %1$" + width + "s ", data);
      }
      return result
    }
    
  }
}
