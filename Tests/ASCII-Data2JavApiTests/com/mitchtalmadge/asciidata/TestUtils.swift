/*
 * SPDX-License-Identifier: Apache-2.0
 */

import JavApi
import ASCII_Data2JavApi

extension com.mitchtalmadge.asciidata {
  
  public class TestUtils {
    
    /**
     * Reads a test file to a String.
     *
     * @param filePath The path to the file, relative to the test resources directory.
     * @return The String contents of the file.
     * @throws IOException If the file could not be found or read.
     */
    public static func readFileToString(_ filePath : String) throws -> String {//IOException {
      //let file = java.io.File("src/test/resources/\(filePath)");
      let fileBytes : [byte] = try java.nio.file.Files.readAllBytes(java.nio.file.Paths.get(filePath.removingPercentEncoding!));
      return String(fileBytes);
    }
    
    /**
     * Replaces all CRLF endings with LF endings.
     * @param content The String content.
     * @return The String content with modified line endings.
     */
    public static func commonizeLineEndings(_ content : String) -> String {
      return content.replaceAll("\r", "\n").replaceAll("\n\n", "\n");
    }
  }
}
