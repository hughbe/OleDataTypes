//
//  EmbeddedObject.swift
//  
//
//  Created by Hugh Bellamy on 26/11/2020.
//

import DataStream

/// [MS-OLEDS] 2.2.5 EmbeddedObject
/// The EmbeddedObject structure specifies how an embedded object is laid out in a container document.
public struct EmbeddedObject {
    public let header: ObjectHeader
    public let nativeDataSize: UInt32
    public let nativeData: [UInt8]
    public let presentation: PresentationObject
    
    public init(dataStream: inout DataStream) throws {
        /// Header (variable): This MUST be an ObjectHeader (section 2.2.4). The FormatID field of the Header MUST be set to 0x00000002.
        self.header = try ObjectHeader(dataStream: &dataStream)
        guard self.header.formatID == .embeddedObject else {
            throw OleError.corrupted
        }
        
        /// NativeDataSize (4 bytes): This MUST be set to the size of the NativeData field, in bytes.
        self.nativeDataSize = try dataStream.read(endianess: .littleEndian)
        
        /// NativeData (variable): This must be an array of bytes that contains the native data.
        self.nativeData = try dataStream.readBytes(count: Int(self.nativeDataSize))
        
        /// Presentation (variable): This MUST be a MetaFilePresentationObject (section 2.2.2.1), a BitmapPresentationObject (section 2.2.2.2),
        /// a DIBPresentationObject (section 2.2.2.3), a StandardClipboardFormatPresentationObject (section 2.2.3.2), or a
        /// RegisteredClipboardFormatPresentationObject (section 2.2.3.3).
        self.presentation = try PresentationObject(dataStream: &dataStream)
    }
}
