//
//  ObjectHeader.swift
//  
//
//  Created by Hugh Bellamy on 26/11/2020.
//

import DataStream

/// [MS-OLEDS] 2.2.4 ObjectHeader
/// The ObjectHeader structure specifies the headers for the LinkedObject (section 2.2.6) and EmbeddedObject (section 2.2.5) structures.
public struct ObjectHeader {
    public let oleVersion: UInt32
    public let formatID: FormatID
    public let className: LengthPrefixedAnsiString
    public let topicName: LengthPrefixedAnsiString
    public let itemName: LengthPrefixedAnsiString
    
    public init(dataStream: inout DataStream) throws {
        /// OLEVersion (4 bytes): This can be set to any arbitrary value and MUST be ignored on receipt.
        self.oleVersion = try dataStream.read(endianess: .littleEndian)
        
        /// FormatID (4 bytes): This MUST be set to 0x00000001 or 0x00000002. Otherwise, the ObjectHeader structure is invalid.<6>
        /// If this field is set to 0x00000001, the ObjectHeader structure MUST be contained by a LinkedObject structure (see section 2.2.6).
        /// If this field is set to 0x00000002, the ObjectHeader structure MUST be contained by an EmbeddedObject structure (see section 2.2.5).
        guard let formatID = FormatID(rawValue: try dataStream.read(endianess: .littleEndian)) else {
            throw OleError.corrupted
        }
        
        self.formatID = formatID

        /// ClassName (variable): This MUST be a LengthPrefixedAnsiString (section 2.1.4) that contains a value identifying the creating
        /// application. The value is mapped to the creating application in an implementation-specific manner.<7>
        self.className = try LengthPrefixedAnsiString(dataStream: &dataStream)
        
        /// TopicName (variable): This MUST be a LengthPrefixedAnsiString (section 2.1.4).
        /// If the ObjectHeader structure is contained by an EmbeddedObject structure (see section 2.2.5), the TopicName field SHOULD
        /// contain an empty string and MUST be ignored on processing.
        /// If the ObjectHeader structure is contained by a LinkedObject structure (see section 2.2.6), the TopicName field MUST contain the
        /// absolute path name of the linked file. The path name either MUST start with a drive letter or MUST be in the Universal Naming
        /// Convention (UNC) format.
        self.topicName = try LengthPrefixedAnsiString(dataStream: &dataStream)
        
        /// ItemName (variable): This MUST be a LengthPrefixedAnsiString (section 2.1.4).
        /// If the ObjectHeader structure is contained by an EmbeddedObject structure (see section 2.2.5), the ItemName field SHOULD
        /// contain an empty string and MUST be ignored on processing.
        /// If the ObjectHeader structure is contained by a LinkedObject structure (see section 2.2.6),the ItemName field MUST contain a
        /// string that is used by the application or higher-level protocol to identify the item within the file to which is being linked. The format
        /// and meaning of the ItemName string is specific to the creating application and MUST be treated by other parties as an opaque
        /// string when processing this data structure. An example of such an item is an individual cell within a spreadsheet application.
        self.itemName = try LengthPrefixedAnsiString(dataStream: &dataStream)
    }
    
    /// FormatID (4 bytes): This MUST be set to 0x00000001 or 0x00000002. Otherwise, the ObjectHeader structure is invalid.<6>
    /// If this field is set to 0x00000001, the ObjectHeader structure MUST be contained by a LinkedObject structure (see section 2.2.6).
    /// If this field is set to 0x00000002, the ObjectHeader structure MUST be contained by an EmbeddedObject structure (see section 2.2.5).
    public enum FormatID: UInt32 {
        /// 0x00000001 The ObjectHeader structure MUST be followed by a LinkedObject structure.
        case linkedObject = 0x00000001
        
        /// 0x00000002 The ObjectHeader structure MUST be followed by an EmbeddedObject structure.
        case embeddedObject = 0x00000002
    }
}
