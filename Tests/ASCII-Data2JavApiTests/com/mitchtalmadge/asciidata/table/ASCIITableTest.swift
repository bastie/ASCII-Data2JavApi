/*
 * SPDX-License-Identifier: Apache-2.0
 */

import XCTest
import Foundation
import JavApi

@testable import ASCII_Data2JavApi

extension com.mitchtalmadge.asciidata.table {
  
  public class ASCIITableTest : XCTestCase{
    
    /**
     * Tests a simple table with example data.
     */
    public func testSimpleTable() throws {//IOException {
      
      let headers = ["ID", "Name", "Email"];
      let data : [[String]] = [
        ["123", "Alfred Alan", "aalan@gmail.com"],
        ["223", "Alison Smart", "asmart@gmail.com"],
        ["256", "Ben Bessel", "benb@outlook.com"],
        ["374", "John Roberts", "johnrob@company.com"],
      ];
      
      var resource = Bundle.module.url(forResource: "simpleTable.ansi", withExtension: "txt")
      var expected = try com.mitchtalmadge.asciidata.TestUtils.readFileToString(resource!.path())
      var actually =
      com.mitchtalmadge.asciidata.TestUtils.commonizeLineEndings(try ASCIITable.fromData(headers, data).toString())
      
      XCTAssertEqual(expected, actually)
      
      // ASCII Table Format
      
      resource = Bundle.module.url(forResource: "simpleTable.ascii", withExtension: "txt")
      expected = try com.mitchtalmadge.asciidata.TestUtils.readFileToString(resource!.path())
      actually = com.mitchtalmadge.asciidata.TestUtils.commonizeLineEndings(try ASCIITable.fromData(headers, data).withTableFormat(com.mitchtalmadge.asciidata.table.formats.ASCIITableFormat()).toString())
      XCTAssertEqual(expected,actually)
      
    }
    
    /**
     * Tests a simple table with example data and a right-aligned column.
     */
    public func testSimpleTableRightAlign() throws {//IOException {
      
      let headers = ["ID", "Name", "Email"];
      let data : [[String]] = [
        ["123", "Alfred Alan", "aalan@gmail.com"],
        ["223", "Alison Smart", "asmart@gmail.com"],
        ["256", "Ben Bessel", "benb@outlook.com"],
        ["374", "John Roberts", "johnrob@company.com"],
      ];

      var resource = Bundle.module.url(forResource: "simpleTableRight.ansi", withExtension: "txt")
      var expected = try com.mitchtalmadge.asciidata.TestUtils.readFileToString(resource!.path())
      var actually = com.mitchtalmadge.asciidata.TestUtils.commonizeLineEndings(try ASCIITable.fromData(headers, data).alignColumn(2, Align.RIGHT).toString())
      XCTAssertEqual(expected, actually);
      // ASCII Table Format
      resource = Bundle.module.url(forResource: "simpleTableRight.ascii", withExtension: "txt")
      expected = try com.mitchtalmadge.asciidata.TestUtils.readFileToString(resource!.path())
      actually = com.mitchtalmadge.asciidata.TestUtils.commonizeLineEndings(try ASCIITable.fromData(headers, data).alignColumn(2, Align.RIGHT).withTableFormat(com.mitchtalmadge.asciidata.table.formats.ASCIITableFormat()).toString())
      XCTAssertEqual(expected, actually);
      
    }
    
    /**
     * Tests tables with no data.
     */
    public func testEmptyTables() throws {//IOException {
      let headers = ["ID", "Name", "Email"];
      let emptyData : [[String]] = [[String]]()
      
      // Not null data, but empty
      var resource = Bundle.module.url(forResource: "emptyTable.ansi", withExtension: "txt")
      var expected = try com.mitchtalmadge.asciidata.TestUtils.readFileToString(resource!.path())
      var actually = com.mitchtalmadge.asciidata.TestUtils.commonizeLineEndings(try ASCIITable.fromData(headers, emptyData).toString())
      XCTAssertEqual(expected, actually);

      // ASCII Table Format
      resource = Bundle.module.url(forResource: "emptyTable.ascii", withExtension: "txt")
      expected = try com.mitchtalmadge.asciidata.TestUtils.readFileToString(resource!.path())
      actually = com.mitchtalmadge.asciidata.TestUtils.commonizeLineEndings(try ASCIITable.fromData(headers, emptyData).withTableFormat(com.mitchtalmadge.asciidata.table.formats.ASCIITableFormat()).toString())
      XCTAssertEqual(expected, actually);
      
      // Null data -  - no Swift problem 😊
      /*
      XCTAssertEqual(
        com.mitchtalmadge.asciidata.TestUtils.commonizeLineEndings(com.mitchtalmadge.asciidata.TestUtils.readFileToString("tables/utf8/emptyTable.ansi.txt")),
        com.mitchtalmadge.asciidata.TestUtils.commonizeLineEndings(ASCIITable.fromData(headers, null).toString())
      );
      // ASCII Table Format
      XCTAssertEqual(
        com.mitchtalmadge.asciidata.TestUtils.commonizeLineEndings(com.mitchtalmadge.asciidata.TestUtils.readFileToString("tables/ascii/emptyTable.ascii.txt")),
        com.mitchtalmadge.asciidata.TestUtils.commonizeLineEndings(ASCIITable.fromData(headers, null).withTableFormat(com.mitchtalmadge.asciidata.table.formats.ASCIITableFormat()).toString())
      );
       */
    }
    
    /**
     * Tests a table with too few columns in the data array.
     */
    //@Test(expected = IllegalArgumentException.class)
    public func testNotEnoughColumns() throws {//IOException {
      let headers = ["ID", "Name", "Email"];
      let badData : [[String]] = [
        ["123", "Alfred Alan", "aalan@gmail.com"],
        ["223", "Alison Smart", "asmart@gmail.com"],
        ["256", "Ben Bessel"], // Missing column
        ["374", "John Roberts", "johnrob@company.com"],
      ];
      
      do {
        let _ = try ASCIITable.fromData(headers, badData);
        XCTAssertFalse(true,"Unexpected not throwed exception")
      }
      catch Throwable.IllegalArgumentException {
        XCTAssertTrue(true)
      }
      catch {
        XCTAssert(false,"Unexpected error \(error) at \"ASCIITable.fromData(headers, badData)\" call")
      }
    }
    
    /**
     * Tests a table with newlines in the data.
     */
    public func testMultipleLines() throws {//IOException {
      
      let headers = ["ID", "Name", "Email"];
      let data : [[String]] = [
        ["123", "Alfred\nAlan", "aalan@gmail.com"],
        ["223", "Alison\nSmart", "asmart@gmail.com"],
        ["256", "Ben\nBessel", "benb@outlook.com"],
        ["374", "John\nRoberts", "johnrob@company.com"],
      ];
      
      let resourceANSI = Bundle.module.url(forResource: "multiLineTable.ansi", withExtension: "txt")
      let expectedANSI = try com.mitchtalmadge.asciidata.TestUtils.readFileToString(resourceANSI!.path())
      XCTAssertEqual(
        com.mitchtalmadge.asciidata.TestUtils.commonizeLineEndings(expectedANSI),
        com.mitchtalmadge.asciidata.TestUtils.commonizeLineEndings(try ASCIITable.fromData(headers, data).toString())
      );
      // ASCII Table Format
      let resourceASCII = Bundle.module.url(forResource: "multiLineTable.ascii", withExtension: "txt")
      let expectedASCII = try com.mitchtalmadge.asciidata.TestUtils.readFileToString(resourceASCII!.path())
      XCTAssertEqual(
        com.mitchtalmadge.asciidata.TestUtils.commonizeLineEndings(expectedASCII),
        com.mitchtalmadge.asciidata.TestUtils.commonizeLineEndings(try ASCIITable.fromData(headers, data).withTableFormat(com.mitchtalmadge.asciidata.table.formats.ASCIITableFormat()).toString())
      );
    }
    
    /**
     * Tests a table which has other tables nested within it.
     */
    public func testNestedTables() throws {//IOException {
      
      // Construction
      let nestedHeaders : [String] = ["First", "Last"];
      let names : [String] = ["Alfred Alan", "Alison Smart", "Ben Bessel", "John Roberts"]
      var nestedTables : [ASCIITable] = []
      var nestedTablesASCIIFormat : [ASCIITable] = []
      for (i, _) in names.enumerated(){
        let splittedNames = [names[i].split(" ")]
        nestedTables.append(try ASCIITable.fromData(nestedHeaders, splittedNames));
        nestedTablesASCIIFormat.append (try ASCIITable.fromData(nestedHeaders, splittedNames)
          .withTableFormat(com.mitchtalmadge.asciidata.table.formats.ASCIITableFormat()));
      }
      
      // Insertion
      let headers : [String] = ["ID", "Name", "Email"]
      let data : [[String]] = [
        ["123", nestedTables[0].toString(), "aalan@gmail.com"],
        ["223", nestedTables[1].toString(), "asmart@gmail.com"],
        ["256", nestedTables[2].toString(), "benb@outlook.com"],
        ["374", nestedTables[3].toString(), "johnrob@company.com"],
      ];
      let dataASCIIFormat = [
        ["123", nestedTablesASCIIFormat[0].toString(), "aalan@gmail.com"],
        ["223", nestedTablesASCIIFormat[1].toString(), "asmart@gmail.com"],
        ["256", nestedTablesASCIIFormat[2].toString(), "benb@outlook.com"],
        ["374", nestedTablesASCIIFormat[3].toString(), "johnrob@company.com"],
      ]
      
      // Testing
      let resourceANSI = Bundle.module.url(forResource: "nestedTable.ansi", withExtension: "txt")
      let expectedANSI = try com.mitchtalmadge.asciidata.TestUtils.readFileToString(resourceANSI!.path())
      XCTAssertEqual(
        com.mitchtalmadge.asciidata.TestUtils.commonizeLineEndings(expectedANSI),
        com.mitchtalmadge.asciidata.TestUtils.commonizeLineEndings(try ASCIITable.fromData(headers, data).toString())
      );
      // ASCII Table Format
      let resourceASCII = Bundle.module.url(forResource: "nestedTable.ascii", withExtension: "txt")
      let expectedASCII = try com.mitchtalmadge.asciidata.TestUtils.readFileToString(resourceASCII!.path())
      XCTAssertEqual(
        com.mitchtalmadge.asciidata.TestUtils.commonizeLineEndings(expectedASCII),
        com.mitchtalmadge.asciidata.TestUtils.commonizeLineEndings(try ASCIITable.fromData(headers, dataASCIIFormat).withTableFormat(com.mitchtalmadge.asciidata.table.formats.ASCIITableFormat()).toString())
      );
      
    }
    
    /*
    /**
     * Tests a table with custom null data - no Swift problem 😊
     */
    public func testNullDataTablesWithCustomNullValue() throws {//IOException {
      
    }
    
    /**
     * Tests a table with default null data - no Swift problem 😊
     */
    public func testNullDataTablesWithDefaultNullValue() throws {//IOException {
    }
    */
  }
}
