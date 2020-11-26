//
//  ClipboardFormatOrUnicodeString.swift
//
//
//  Created by Hugh Bellamy on 25/11/2020.
//

import DataStream

/// [MS-OLEDS] 2.3.2 ClipboardFormatOrUnicodeString
/// The ClipboardFormatOrUnicodeString structure specifies either a standard clipboard format identifier (section 2.1.1) or a registered clipboard format
/// as a Unicode string.
public struct ClipboardFormatOrUnicodeString {
    public let markerOrLength: UInt32
    public let formatOrUnicodeString: FormatOrUnicodeString
    
    public init(dataStream: inout DataStream) throws {
        /// MarkerOrLength (4 bytes): If this is set to 0x00000000, the FormatOrUnicodeString field MUST NOT be present. If this is set to 0xffffffff
        /// or 0xfffffffe, the FormatOrUnicodeString field MUST be 4 bytes in size and MUST contain a standard clipboard format identifier (section 2.1.1).
        /// Otherwise, the FormatOrUnicodeString field MUST be set to a Unicode string containing the name of a registered clipboard format
        /// (section 2.1.1) and the MarkerOrLength field MUST be set to the number of Unicode characters in the FormatOrUnicodeString field,
        /// including the terminating null character.
        /// Value Meaning
        /// 0xFFFFFFFE Indicates a standard clipboard format.
        /// 0xFFFFFFFF Indicates a standard clipboard format.
        /// 0x00000001 — 0xfffffffd Indicates a registered clipboard format
        self.markerOrLength = try dataStream.read(endianess: .littleEndian)
        
        /// FormatOrUnicodeString (variable): This MUST be set to a value as specified by the MarkerOrLength field.
        switch self.markerOrLength {
        case 0x00000000:
            self.formatOrUnicodeString = .none
        case 0xFFFFFFFE, 0xFFFFFFFF:
            self.formatOrUnicodeString = .standard(format: try dataStream.read(endianess: .littleEndian))
        default:
            self.formatOrUnicodeString = .registered(format: try dataStream.readString(count: Int(self.markerOrLength) - 2, encoding: .utf16LittleEndian)!)
            
            // Skip null terminator
            guard try dataStream.read() as UInt16 == 0x00 else {
                throw OleError.corrupted
            }
        }
    }
    
    public enum FormatOrUnicodeString {
        case none
        case standard(format: ClipboardFormat)
        case registered(format: String)
    }
}
