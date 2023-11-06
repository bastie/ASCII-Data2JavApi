/*
 * SPDX-License-Identifier: Apache-2.0
 */

import JavApi
extension com.mitchtalmadge.asciidata.graph.util {
  open class SeriesUtils {
    
    /**
     * From the series, determines the minimum and maximum values.
     *
     * @param series The series.
     * @return An array of size 2, containing the minimum value of the series at index 0, and the maximum at index 1.
     * @throws IllegalArgumentException If the series does not contain at least one value, or is null.
     */
    public static func getMinAndMaxValues(_ series : [Double]) throws -> [Double]{
      guard !series.isEmpty else {
        throw Throwable.IllegalArgumentException("The series must have at least one value.");
      }
      
      // Initialize results with the largest value in the minimum spot, and smallest value in the maximum spot.
      var results: [Double] = [Double.MAX_VALUE, Double.MIN_VALUE];
      
      /* // Find min and max. 
      java.util.Arrays.stream(series).forEach(value -> {
        // Compare value to the current min and max.
        results[0] = Math.min(results[0], value);
        results[1] = Math.max(results[1], value);
      });*/
      for value in series {
        results[0] = Math.min(results[0], value);
        results[1] = Math.max(results[1], value);
      }
      
      return results;
    }
  }
}
