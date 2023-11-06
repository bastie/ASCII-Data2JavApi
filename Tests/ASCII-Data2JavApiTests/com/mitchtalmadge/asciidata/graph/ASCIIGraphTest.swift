/*
 * SPDX-License-Identifier: Apache-2.0
 */

import XCTest
import Foundation
import JavApi

@testable import ASCII_Data2JavApi

extension com.mitchtalmadge.asciidata.graph {
  
  public class ASCIIGraphTest : XCTestCase{
    
    private static var sinWaveSeries : [Double] = {
      // Compute Sin Wave Series
      var temp : [Double] = []
      for i in 0..<120 {
        temp.append(
          15 * Math.sin(Double(i) * ((Math.PI * 4) / Double(120)))
        )
      }
      return temp
    }()
    
    private static let randomWaveSeries : [Double] = [
      10, 16, 15, 14, 13, 7, 12, 16, 6, 8, 5, 18, 9, 13, 6, 16, 4, 5, 2, 8, 6, 15, 19, 10, 1,
      17, 2, 9, 19, 6, 10, 19, 13, 4, 10, 10, 14, 10, 10, 9, 8, 16, 14, 12, 14, 11, 3, 13, 18, 15,
      10, 18, 6, 2, 2, 19, 12, 11, 5, 7, 6, 11, 17, 3, 14, 3, 10, 12, 19, 5, 6, 16, 2, 8, 9,
      9, 12, 5, 2, 17, 12, 5, 1, 5, 7, 7, 15, 19, 5, 9]; // 90 Random numbers

    public func testSinWaveFullHeight() throws {//IOException {
      let resource = Bundle.module.url(forResource: "sinWaveFullHeight", withExtension: "txt")
      let expected = try com.mitchtalmadge.asciidata.TestUtils.readFileToString(resource!.path())

      XCTAssertEqual(
        com.mitchtalmadge.asciidata.TestUtils.commonizeLineEndings(expected),
        com.mitchtalmadge.asciidata.TestUtils.commonizeLineEndings(ASCIIGraph.fromSeries(com.mitchtalmadge.asciidata.graph.ASCIIGraphTest.sinWaveSeries).plot())
      );
    }
    
    public func testSinWaveHalfHeight() throws  {//IOException {
      let resource = Bundle.module.url(forResource: "sinWaveHalfHeight", withExtension: "txt")
      let expected = try com.mitchtalmadge.asciidata.TestUtils.readFileToString(resource!.path())
      XCTAssertEqual(
        com.mitchtalmadge.asciidata.TestUtils.commonizeLineEndings(expected),
        com.mitchtalmadge.asciidata.TestUtils.commonizeLineEndings(ASCIIGraph.fromSeries(com.mitchtalmadge.asciidata.graph.ASCIIGraphTest.sinWaveSeries).withNumRows(15).plot())
      );
    }
    
    public func testRandomWave() throws  {//IOException {
      let resource = Bundle.module.url(forResource: "randomWave", withExtension: "txt")
      let expected = try com.mitchtalmadge.asciidata.TestUtils.readFileToString(resource!.path())
      
      XCTAssertEqual(
        com.mitchtalmadge.asciidata.TestUtils.commonizeLineEndings(expected),
        com.mitchtalmadge.asciidata.TestUtils.commonizeLineEndings(ASCIIGraph.fromSeries(com.mitchtalmadge.asciidata.graph.ASCIIGraphTest.randomWaveSeries).plot())
      );
    }
    
  }
}
