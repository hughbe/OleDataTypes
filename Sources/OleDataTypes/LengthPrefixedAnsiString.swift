//
//  LengthPrefixedAnsiString.swift
//  
//
//  Created by Hugh Bellamy on 25/11/2020.
//

import DataStream

/// [MS-OLEDS] 2.1.4 LengthPrefixedAnsiString
/// This structure specifies a null-terminated American National Standards Institute (ANSI) character set string.
public struct LengthPrefixedAnsiString {
    public let length: UInt32
    public let string: String
    
    public init(dataStream: inout DataStream) throws {
        /// Length (4 bytes): This MUST be set to the number of ANSI characters in the String field, including the terminating null character. Length
        /// MUST be set to 0x00000000 to indicate an empty string.
        self.length = try dataStream.read(endianess: .littleEndian)
        
        /// String (variable): This MUST be a null-terminated ANSI string.
        if self.length > 0 {
            self.string = try dataStream.readString(count: Int(self.length) - 1, encoding: .ascii)!
            
            // Skip null terminator
            guard try dataStream.read() as UInt8 == 0x00 else {
                throw OleError.corrupted
            }
        } else {
            self.string = ""
        }
    }
}
