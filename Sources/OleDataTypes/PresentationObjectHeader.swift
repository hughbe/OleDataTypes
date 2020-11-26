//
//  PresentationObjectHeader.swift
//  
//
//  Created by Hugh Bellamy on 25/11/2020.
//

import DataStream

/// [MS-OLEDS] 2.2.1 PresentationObjectHeader
/// The PresentationObjectHeader structure specifies the header for different types of presentation data structures.
public struct PresentationObjectHeader {
    public let oleVersion: UInt32
    public let formatID: FormatID
    public let className: LengthPrefixedAnsiString?
    
    public init(dataStream: inout DataStream) throws {
        /// OLEVersion (4 bytes): This can be set to any arbitrary value and MUST be ignored on processing.
        self.oleVersion = try dataStream.read(endianess: .littleEndian)
        
        /// FormatID (4 bytes): This MUST be set to 0x00000000 or 0x00000005. If this is set to 0x00000000, the ClassName field MUST
        /// NOT be present and this structure MUST NOT be contained by another structure. If this is a value other than 0x00000000 or
        /// 0x00000005, the PresentationObjectHeader structure is invalid.<5>
        guard let formatID = FormatID(rawValue: try dataStream.read(endianess: .littleEndian)) else {
            throw OleError.corrupted
        }
        
        self.formatID = formatID
        
        /// ClassName (variable): This MUST be a LengthPrefixedAnsiString (section 2.1.4) that identifies the type of the presentation data
        /// structure that follows the PresentationObjectHeader.
        /// There are two types of presentation objects. These are specified in sections 2.2.2 and 2.2.3.
        if self.formatID == .classNamePresent {
            self.className = try LengthPrefixedAnsiString(dataStream: &dataStream)
        } else {
            self.className = nil
        }
    }
    
    /// FormatID (4 bytes): This MUST be set to 0x00000000 or 0x00000005. If this is set to 0x00000000, the ClassName field MUST
    /// NOT be present and this structure MUST NOT be contained by another structure. If this is a value other than 0x00000000 or
    /// 0x00000005, the PresentationObjectHeader structure is invalid.<5>
    /// Value Meaning
    public enum FormatID: UInt32 {
        /// 0x00000000 The ClassName field MUST NOT be present.
        case classNameNotPresent = 0x00000000
        
        /// 0x00000005 The ClassName field is present.
        case classNamePresent = 0x00000005
    }
}
