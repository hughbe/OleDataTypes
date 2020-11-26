//
//  ClipboardFormatOrAnsiString.swift
//  
//
//  Created by Hugh Bellamy on 25/11/2020.
//

import DataStream

/// [MS-OLEDS] 2.3.1 ClipboardFormatOrAnsiString
/// The ClipboardFormatOrAnsiString structure specifies either a standard clipboard format (section 1.3.5.1) or a registered clipboard format as an
/// ANSI string.
public struct ClipboardFormatOrAnsiString {
    public let markerOrLength: UInt32
    public let formatOrAnsiString: FormatOrAnsiString
    
    public init(dataStream: inout DataStream) throws {
        /// MarkerOrLength (4 bytes): If this is set to 0x00000000, the FormatOrAnsiString field MUST NOT be present. If this field is set to
        /// 0xFFFFFFFF or 0xFFFFFFFE, the FormatOrAnsiString field MUST be 4 bytes in size and MUST contain a standard clipboard format
        /// identifier (section 2.1.1). If this set to a value other than 0x00000000, the FormatOrAnsiString field MUST be set to a
        /// null-terminated ANSI string containing the name of a registered clipboard format (section 2.1.1) and the MarkerOrLength field MUST be
        /// set to the number of ANSI characters in the FormatOrAnsiString field, including the terminating null character.
        /// Value Meaning
        /// 0x00000000 The FormatOrAnsiString field MUST NOT be present.
        /// 0xfffffffe The FormatOrAnsiString field MUST be 4 bytes in size and MUST contain a standard clipboard format (section 1.3.5.1).
        /// 0xffffffff The FormatOrAnsiString field MUST be 4 bytes in size and MUST contain a standard clipboard format (section 1.3.5.1).
        self.markerOrLength = try dataStream.read(endianess: .littleEndian)
        
        /// FormatOrAnsiString (variable): This MUST be set to a value as specified by the MarkerOrLength field.
        switch self.markerOrLength {
        case 0x00000000:
            self.formatOrAnsiString = .none
        case 0xFFFFFFFE, 0xFFFFFFFF:
            self.formatOrAnsiString = .standard(try dataStream.read(endianess: .littleEndian))
        default:
            self.formatOrAnsiString = .registered(try dataStream.readString(count: Int(self.markerOrLength) - 1, encoding: .ascii)!)
            
            // Skip null terminator
            guard try dataStream.read() as UInt8 == 0x00 else {
                throw OleError.corrupted
            }
        }
    }
    
    public enum FormatOrAnsiString {
        case none
        case standard(_: ClipboardFormat)
        case registered(_: String)
    }
}
