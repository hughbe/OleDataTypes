//
//  RegisteredClipboardFormatPresentationObject.swift
//
//
//  Created by Hugh Bellamy on 26/11/2020.
//

import DataStream

/// [MS-OLEDS] 2.2.3.3 RegisteredClipboardFormatPresentationObject
/// The RegisteredClipboardFormatPresentationObject structure specifies a presentation data type that is used to display linked objects or
/// embedded objects in container applications. The presentation data is identified using a registered Clipboard Format (section 1.7.1).
public struct RegisteredClipboardFormatPresentationObject {
    public let header: ClipboardFormatHeader
    public let stringFormatDataSize: UInt32
    public let stringFormatData: LengthPrefixedAnsiString
    public let presentationDataSize: UInt32
    public let presentationData: [UInt8]
    
    public init(dataStream: inout DataStream) throws {
        /// Header (variable): This MUST be a ClipboardFormatHeader (see section 2.2.3.1). The ClipboardFormat field MUST be set
        /// to 0x00000000.
        self.header = try ClipboardFormatHeader(dataStream: &dataStream)
        guard self.header.clipboardFormat == 0x00000000 else {
            throw OleError.corrupted
        }
        
        /// StringFormatDataSize (4 bytes): This MUST be set to the size, in bytes, of the StringFormatData field.
        self.stringFormatDataSize = try dataStream.read(endianess: .littleEndian)
        
        let startPosition1 = dataStream.position
        
        /// StringFormatData (variable): This MUST be a LengthPrefixedAnsiString (section 2.1.4) or a LengthPrefixedUnicodeString (section 2.1.5),
        /// either of which contain a registered clipboard format name (section 1.7.1).
        self.stringFormatData = try LengthPrefixedAnsiString(dataStream: &dataStream)
        
        guard dataStream.position - startPosition1 == self.stringFormatDataSize else {
            throw OleError.corrupted
        }
        
        /// PresentationDataSize (4 bytes): This MUST be set to the size in, bytes, of the PresentationData field.
        self.presentationDataSize = try dataStream.read(endianess: .littleEndian)
        
        let startPosition2 = dataStream.position

        /// PresentationData (variable): This MUST be an array of bytes that contains the presentation data that is supplied by an application
        /// or a higher-level protocol.
        self.presentationData = try dataStream.readBytes(count: Int(self.presentationDataSize))
        
        guard dataStream.position - startPosition2 == self.presentationDataSize else {
            throw OleError.corrupted
        }
    }
}
