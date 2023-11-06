/*
 * SPDX-License-Identifier: Apache-2.0
 */
extension com.mitchtalmadge.asciidata.table.formats {
  
  /**
   * The default, UTF-8 based table format for {@link com.mitchtalmadge.asciidata.table.ASCIITable}.
   * Uses double pipes in most cases.
   *
   * @author JakeWharton
   * @author MitchTalmadge
   */
  public class UTF8TableFormat : TableFormatAbstract {
    
    public func getTopLeftCorner() -> Character{
      return "╔";
    }
    
    public func getTopRightCorner() -> Character{
      return "╗";
    }
    
    public func getBottomLeftCorner() -> Character{
      return "╚";
    }
    
    public func getBottomRightCorner() -> Character{
      return "╝";
    }
    
    public func getTopEdgeBorderDivider() -> Character{
      return "╤";
    }
    
    public func getBottomEdgeBorderDivider() -> Character{
      return "╧";
    }
    
    public func getLeftEdgeBorderDivider(_ underHeaders : Bool) -> Character{
      if (underHeaders) {
        return "╠";
      }
      else {
        return "╟";
      }
    }
    
    public func getRightEdgeBorderDivider(_ underHeaders : Bool) -> Character{
      if (underHeaders) {
        return "╣";
      }
      else {
        return "╢";
      }
    }
    
    public func getHorizontalBorderFill(_ edge : Bool, _ underHeaders : Bool) -> Character{
      if (edge || underHeaders) {
        return "═";
      }
      else {
        return "─";
      }
    }
    
    public func getVerticalBorderFill(_ edge : Bool) -> Character{
      if (edge) {
        return "║";
      }
      else {
        return "│";
      }
    }
    
    public func getCross(_ underHeaders : Bool, _ emptyData : Bool) -> Character{
      if (underHeaders) {
        if (emptyData) {
          return "╧";
        }
        else {
          return "╪";
        }
      } else {
        return "┼";
      }
    }
  }
}
