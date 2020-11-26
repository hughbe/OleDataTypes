//
//  LinkedObject.swift
//
//
//  Created by Hugh Bellamy on 26/11/2020.
//

import DataStream

/// [MS-OLEDS] 2.2.6 LinkedObject
/// The LinkedObject structure specifies how a linked object is laid out in a container document.
public struct LinkedObject {
    public let header: ObjectHeader
    public let networkName: LengthPrefixedAnsiString
    public let linkUpdateOption: UInt32
    public let presentation: PresentationObject
    
    public init(dataStream: inout DataStream) throws {
        /// Header (variable): This MUST be an ObjectHeader (section 2.2.4). The FormatID field of the Header MUST be set to 0x00000001.
        self.header = try ObjectHeader(dataStream: &dataStream)
        guard self.header.formatID == .linkedObject else {
            throw OleError.corrupted
        }
        
        /// NetworkName (variable): This MUST be a LengthPrefixedAnsiString (section 2.1.4).
        /// If the TopicName field of the ObjectHeader structure contains a path that starts with a drive letter and if the drive letter is for a
        /// remote drive, the NetworkName field MUST contain the path name of the linked file in the Universal Naming Convention (UNC) format.
        self.networkName = try LengthPrefixedAnsiString(dataStream: &dataStream)
        
        /// LinkUpdateOption (4 bytes): This field contains an implementation-specific hint supplied by the application or higher-level protocol
        /// responsible for creating the data structure. The hint MAY be ignored on processing of this data structure.<8>
        self.linkUpdateOption = try dataStream.read(endianess: .littleEndian)
        
        /// Presentation (variable): This MUST be a MetaFilePresentationObject (section 2.2.2.1), a BitmapPresentationObject (section 2.2.2.2),
        /// a DIBPresentationObject (section 2.2.2.3), a StandardClipboardFormatPresentationObject (section 2.2.3.2), or a
        /// RegisteredClipboardFormatPresentationObject (section 2.2.3.3).
        self.presentation = try PresentationObject(dataStream: &dataStream)
    }
}
