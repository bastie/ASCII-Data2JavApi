/*
 * SPDX-License-Identifier: Apache-2.0
 */

import XCTest
import Foundation
import JavApi

@testable import ASCII_Data2JavApi

extension com.mitchtalmadge.asciidata.graph.util {
  
  public class SeriesUtilsTest : XCTestCase{
    
    public func testMinAndMaxValues() throws {
      let series : [Double] = [12.5, 11.4, 28.9, -2.3, -5.245, -7.8827, -7.8828, 0, 2.4];
      
      let expected : [Double] = [-7.8828, 28.9]
      let actually = try SeriesUtils.getMinAndMaxValues(series)
      XCTAssertEqual(expected.count, actually.count)
      for (i,_) in expected.enumerated() {
        XCTAssertEqual(expected[i], actually[i], accuracy: 0.0001);
      }
    }
    
    public func testMinAndMaxValuesWithSeriesLengthOne() throws {
      let series : [Double] = Array(repeating: 0, count: 1)
      
      let expected : [Double] = [Double(),Double()]
      let actually = try SeriesUtils.getMinAndMaxValues(series)
      let accuracy = 0.1
      
      XCTAssertEqual(expected.count, actually.count)
      for (i,_) in expected.enumerated() {
        XCTAssertEqual(expected[i], actually[i], accuracy: accuracy)
      }
      
    }
    
    //@Test(expected = IllegalArgumentException.class)
    public func testMinAndMaxValuesWithSeriesLengthZero() throws {
      do {
          let _ = try SeriesUtils.getMinAndMaxValues([Double]())
      }
      catch Throwable.IllegalArgumentException {
        XCTAssertTrue(true)
      }
      catch {
        XCTAssert(false,"Unexpected error \(error) at \"SeriesUtils.getMinAndMaxValues([Double]()\" call")
      }
    }
    
    /*
    //@Test(expected = IllegalArgumentException.class) - no Swift problem 😊
    public func testMinAndMaxValuesWithNullSeries() throws {
      SeriesUtils.getMinAndMaxValues(null);
    }
    */
  }
}
