/*
 * SPDX-License-Identifier: Apache-2.0
 */
//import com.mitchtalmadge.asciidata.graph.util.SeriesUtils;
//import java.text.DecimalFormat;

import JavApi

extension com.mitchtalmadge.asciidata.graph {
  
  /**
   * A two-axis graph created entirely from ASCII characters.
   * Printable to a console, chat server, or anywhere else where text-style graphs are convenient.
   *
   * @author MitchTalmadge
   * @author kroitor
   */
  public class ASCIIGraph {
    
    /**
     * The data series, with index being the x-axis and value being the y-axis.
     */
    private var series : [Double];
    
    /**
     * The minimum value in the series.
     */
    private var min : Double = 0;
    
    /**
     * The maximum value in the series.
     */
    private var max : Double = 0;
    
    /**
     * The range of the data in the series.
     */
    private var range : Double = 0;
    
    /**
     * The number of rows in the graph.
     */
    private var numRows : Int = 0;
    
    /**
     * The number of columns in the graph, including the axis and ticks.
     */
    private var numCols : Int = 0;
    
    /**
     * How wide the ticks are. Ticks are left-padded with spaces to be this length.
     */
    private var tickWidth : Int = 8;
    
    /**
     * How the ticks should be formatted.
     */
    private var tickFormat = "%1.2f"//: DecimalFormat = DecimalFormat("###0.00");

    /**
     * The index at which the axis starts.
     */
    private var axisIndex : Int = 0;
    
    /**
     * Ths index at which the line starts.
     */
    private var lineIndex : Int = 0;
    
    private init (_ series : [Double]) {
      self.series = series;
    }
    
    /**
     * Calculates the instance fields used for plotting.
     */
    private func calculateFields() {
      // Get minimum and maximum from series.
      let minMax : [Double] =  try!com.mitchtalmadge.asciidata.graph.util.SeriesUtils.getMinAndMaxValues(self.series);
      self.min = minMax[0];
      self.max = minMax[1];
      self.range = max - min;
      
      axisIndex = tickWidth + 1;
      lineIndex = axisIndex + 1;
      
      // Since the graph is made of ASCII characters, it needs whole-number counts of rows and columns.
      self.numRows = numRows == 0 ? Int(Math.round(max - min) + 1) : numRows;
      // For columns, add the width of the tick marks, the width of the axis, and the length of the series.
      self.numCols = tickWidth + (axisIndex - tickWidth) + series.length;
    }
    
    /**
     * Creates an ASCIIGraph instance from the given series.
     *
     * @param series The series of data, where index is the x-axis and value is the y-axis.
     * @return A new ASCIIGraph instance.
     */
    public static func fromSeries(_ series : [Double]) -> ASCIIGraph {
      return ASCIIGraph(series);
    }
    
    /**
     * Determines the number of rows in the graph.
     * By default, the number of rows will be equal to the range of the series + 1.
     *
     * @param numRows The number of rows desired. If 0, uses the default.
     * @return This instance.
     */
    public func withNumRows(_ numRows : Int) -> ASCIIGraph {
      self.numRows = numRows;
      return self;
    }
    
    /**
     * Determines the minimum width of the ticks on the axis.
     * Ticks will be left-padded with spaces if they are not already this length.
     * Defaults to 8.
     *
     * @param tickWidth The width of the ticks on the axis.
     * @return This instance.
     */
    public func withTickWidth(_ tickWidth : Int) -> ASCIIGraph {
      self.tickWidth = tickWidth;
      return self;
    }
    
    /**
     * Determines how the ticks will be formatted.
     * Defaults to "###0.00".
     *
     * @param tickFormat The format of the ticks.
     * @return This instance.
     */
    public func withTickFormat(_ tickFormat : String /*DecimalFormat*/) -> ASCIIGraph { // e.g. "%1.2f" == "#.##"
      self.tickFormat = tickFormat;
      return self;
    }
    
    /**
     * Plots the graph and returns it as a String.
     *
     * @return The string representation of the graph, using new lines.
     */
    public func plot() -> String{
      calculateFields();
      
      // ---- PLOTTING ---- //
      
      // The graph is initially stored in a 2D array, later turned into Strings.
      var graph = [[Character]]()
      for row in 0..<numRows {
        graph.append([Character]())
        for _ in 0..<numCols {
          graph[row].append(" ")
        }
      }

      // Fill the graph with space characters.
      for row in 0..<numRows {
        for col in 0..<(graph[row].length) {
          graph[row][col] = " ";
        }
      }
      
      // Draw the ticks and graph.
      drawTicksAndAxis(&graph);
      
      // Draw the line.
      drawLine(&graph);
      
      // Convert the 2D char array graph to a String using newlines.
      return convertGraphToString(graph);
    }
    
    /**
     * Adds the tick marks and axis to the graph.
     *
     * @param graph The graph.
     */
    private func drawTicksAndAxis(_ graph : inout [[Character]]) {
      // Add the labels and the axis.
      for row in 0..<graph.length{
        
        let y : Double = determineYValueAtRow(row);
        
        // Compute and Format Tick
        let tick : [Character] = formatTick(y).toCharArray();
        
        // Insert Tick
        System.arraycopy(tick, 0, &graph[row], 0, tick.length);
        
        // Insert Axis line. '┼' is used at the origin.
        graph[row][axisIndex] = (y == 0) ? "┼" : "┤";
      }
    }
    
    /**
     * Adds the line to the graph.
     *
     * @param graph The graph.
     */
    private func drawLine(_ graph : inout [[Character]]) {
      // The row closest to y when x = 0.
      let initialRow : Int = determineRowAtYValue(series[0]);
      // Modify the axis to show the start.
      graph[initialRow][axisIndex] = "┼";
      
      for x in 0..<(series.length - 1) {
        // The start and end locations of the line.
        let startRow : Int = determineRowAtYValue(series[x]);
        let endRow : Int = determineRowAtYValue(series[x + 1]);
        
        if (startRow == endRow) { // The line is horizontal.
          graph[startRow][lineIndex + x] = "─";
        } else { // The line has slope.
                 // Draw the curved lines.
          graph[startRow][lineIndex + x] = (startRow < endRow) ? "╮" : "╯";
          graph[endRow][lineIndex + x] = (startRow < endRow) ? "╰" : "╭";
          
          // If the rows are more than 1 row apart, we need to fill in the gap with vertical lines.
          let lowerRow : Int = java.lang.Math.min(startRow, endRow);
          let upperRow : Int = java.lang.Math.max(startRow, endRow);
          for row in (lowerRow + 1)..<upperRow {
            graph[row][lineIndex + x] = "│";
          }
        }
      }
    }
    
    /**
     * Determines the row closest to the given y-axis value.
     *
     * @param yValue The value of y.
     * @return The closest row to the given y-axis value.
     */
    private func determineRowAtYValue(_ yValue : Double) -> Int {
      // ((yValue - min) / range) creates a ratio -- how deep the y-value is into the range.
      // Multiply that by the number of rows to determine how deep the y-value is into the number of rows.
      // Then invert it buy subtracting it from the number of rows, since 0 is actually the top.
      
      // 1 is subtracted from numRows since it is a length, and we start at 0.
      return (numRows - 1) - Int (Math.round(((yValue - min) / range) * Double((numRows - 1))));
    }
    
    /**
     * Determines the y-axis value corresponding to the given row.
     *
     * @param row The row.
     * @return The y-axis value at the given row.
     */
    private func determineYValueAtRow(_ row : Int) -> Double {
      // Compute the current y value by starting with the maximum and subtracting how far down we are in rows.
      // Splitting the range into chunks based on the number of rows gives us how much to subtract per row.
      // (-1 from the number of rows because it is a length, and the last row index is actually numRows - 1).
      return max - (Double(row) * (range / Double((numRows - 1))));
    }
    
    /**
     * Formats the given value as a tick mark on the graph.
     * Pads the tick mark with the correct number of spaces
     * in order to be {@link ASCIIGraph#tickWidth} characters long.
     *
     * @param value The value of the tick mark.
     * @return The formatted tick mark.
     */
    private func formatTick(_ value : Double) -> String {
      var paddedTick = StringBuilder();
      
      let formattedValue : String = String(format: tickFormat, value) //tickFormat.format(value);
      for _ in 0..<(tickWidth - formattedValue.count) {
        paddedTick = paddedTick.append(" ");
      }
      
      return paddedTick.append(formattedValue).toString();
    }
    
    /**
     * Converts the 2D char array representation of the graph into a String representation.
     *
     * @param graph The 2D char array representation of the graph.
     * @return The String representation of the graph.
     */
    private func convertGraphToString(_ graph : [[Character]]) -> String{
      var stringGraph = StringBuilder();
      
      for row in graph {
        stringGraph = stringGraph.append(row).append("\n");
      }
      
      return stringGraph.toString();
    }
    
  }
}
