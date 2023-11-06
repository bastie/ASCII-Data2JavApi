/*
 * SPDX-License-Identifier: Apache-2.0
 */
extension com.mitchtalmadge.asciidata.table.formats {
  public typealias TableFormatAbstract = ASCII_Data2JavApi.TableFormatAbstract

}


/**
 * Determines the characters that make up an ASCIITable.
 * Default is {@link UTF8TableFormat}.
 * @author MitchTalmadge
 */
public protocol TableFormatAbstract {
  
  // ============ Corners
  
  /**
   * @return The top left corner of the table. Ex: ╔
   */
  func getTopLeftCorner() -> Character;
  
  /**
   * @return The top right corner of the table. Ex: ╗
   */
  func getTopRightCorner() -> Character;
  
  /**
   * @return The bottom left corner of the table. Ex: ╚
   */
  func getBottomLeftCorner() -> Character;
  
  /**
   * @return The bottom right corner of the table. Ex: ╝
   */
  func getBottomRightCorner() -> Character;
  
  // ============ Top and Bottom Edges
  
  /**
   * @return The character used when dividing columns on the top edge of the table. Ex: ╤
   */
  func getTopEdgeBorderDivider() -> Character;
  
  /**
   * @return The character used when dividing columns on the bottom edge of the table. Ex: ╧
   */
  func getBottomEdgeBorderDivider() -> Character;
  
  // ============ Left and Right Edges
  
  /**
   * @param underHeaders True if the border is directly between the headers of the table and the first row.
   * @return The character used when dividing rows on the left edge of the table. Ex: ╠ under the headers, and ╟ everywhere else.
   */
  func getLeftEdgeBorderDivider(_ underHeaders : Bool) -> Character;
  
  /**
   * @param underHeaders True if the border is directly between the headers of the table and the first row.
   * @return The character used when dividing rows on the right edge of the table. Ex: ╣ under the headers, and ╢ everywhere else.
   */
  func getRightEdgeBorderDivider(_ underHeaders : Bool) -> Character;
  
  // ============ Fills
  
  /**
   * @param edge         True if the border is on the top or bottom edge of the table.
   * @param underHeaders True if the border is directly between the headers of the table and the first row.
   * @return The character used for horizontal stretches in the table. Ex: ═ for edges and under the headers, and ─ everywhere else.
   */
  func getHorizontalBorderFill(_ edge : Bool, _ underHeaders : Bool) -> Character;
  
  /**
   * @param edge True if the border is on the left or right edge of the table.
   * @return The character used for vertical stretches in the table. Ex: ║ for edges, and │ everywhere else.
   */
  func getVerticalBorderFill(_ edge : Bool) -> Character;
  
  // ============ Crosses
  
  /**
   * @param underHeaders True if the border is directly between the headers of the table and the first row.
   * @param emptyData    True if the table has no data. In this case it can be more aesthetically pleasing to use a
   *                     bottom edge divider to provide a flat surface for the bottom of the border.
   *                     (The cross will only appear under the headers at this point, so underHeaders is true when emptyData is true).
   * @return The character used where horizontal and vertical borders intersect. Ex: ╪ under the headers, ╧ when table has no data, and ┼ everywhere else.
   */
  func getCross(_ underHeaders : Bool, _ emptyData : Bool) -> Character;
  
}
