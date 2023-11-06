/*
 * SPDX-License-Identifier: Apache-2.0
 */
extension com.mitchtalmadge.asciidata.table.formats {
  
  /**
   * An ASCIITable Format using only ASCII characters.
   *
   * @author bitsofinfo
   * @author MitchTalmadge
   */
  open class ASCIITableFormat : TableFormatAbstract {
    
    public func getTopLeftCorner() -> Character{
      return "+";
    }
    
    public func getTopRightCorner() -> Character{
      return "+";
    }
    
    public func getBottomLeftCorner() -> Character{
      return "+";
    }
    
    public func getBottomRightCorner() -> Character{
      return "+";
    }
    
    public func getTopEdgeBorderDivider() -> Character{
      return "+";
    }
    
    public func getBottomEdgeBorderDivider() -> Character{
      return "+";
    }
    
    public func getLeftEdgeBorderDivider(_ underHeaders : Bool) -> Character{
      return "|";
    }
    
    public func getRightEdgeBorderDivider(_ underHeaders : Bool) -> Character{
      return "|";
    }
    
    public func getHorizontalBorderFill(_ edge : Bool, _ underHeaders : Bool) -> Character{
      if (edge || underHeaders) {
        return "=";
      }
      else {
        return "-";
      }
    }
    
    public func getVerticalBorderFill(_ edge : Bool) -> Character{
      return "|";
    }
    
    public func getCross(_ underHeaders : Bool, _ emptyData : Bool) -> Character{
      if (emptyData) {
        return "=";
      }
      else {
        return "|";
      }
    }
  }
}
