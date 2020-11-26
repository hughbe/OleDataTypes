//
//  LengthPrefixedUnicodeString.swift
//
//
//  Created by Hugh Bellamy on 25/11/2020.
//

import DataStream

/// [MS-OLEDS] 2.1.5 LengthPrefixedUnicodeString
/// This structure specifies a Unicode string.
public struct LengthPrefixedUnicodeString {
    public let length: UInt32
    public let string: String
    
    public init(dataStream: inout DataStream) throws {
        /// Length (4 bytes): This MUST be set to the number of bytes in the String field, including the terminating null character. Length MUST be
        /// set to 0x00000000 to indicate an empty string.
        self.length = try dataStream.read(endianess: .littleEndian)
        guard (self.length % 2) == 0 else {
            throw OleError.corrupted
        }
        
        /// String (variable): (Optional.) This MUST be a Unicode string.
        if self.length > 0 {
            self.string = try dataStream.readString(count: Int(self.length) - 2, encoding: .utf16LittleEndian)!
            
            // Skip null terminator
            guard try dataStream.read(endianess: .littleEndian) as UInt16 == 0x0000 else {
                throw OleError.corrupted
            }
        } else {
            self.string = ""
        }
    }
}
