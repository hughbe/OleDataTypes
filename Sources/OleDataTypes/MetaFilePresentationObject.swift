//
//  MetaFilePresentationObject.swift
//
//
//  Created by Hugh Bellamy on 25/11/2020.
//

import DataStream

/// [MS-OLEDS] 2.2.2.1 MetaFilePresentationObject
/// The MetaFilePresentationObject structure specifies a presentation data type that is used to display linked objects or embedded objects in
/// container applications. The presentation data is in the form of a Windows metafile (as specified in [MS-WMF] section 1.3.1).
public struct MetaFilePresentationObject {
    public let header: StandardPresentationObject
    public let presentationDataSize: UInt32
    public let reserved1: UInt16
    public let reserved2: UInt16
    public let reserved3: UInt16
    public let reserved4: UInt16
    public let presentationData: [UInt8]?
    
    public init(dataStream: inout DataStream) throws {
        /// Header (variable): This MUST be a StandardPresentationObject (section 2.2.2). The ClassName field of the contained
        /// PresentationObjectHeader (section 2.2.1) MUST be set to the case-sensitive value "METAFILEPICT".
        self.header = try StandardPresentationObject(dataStream: &dataStream)
        guard let className = self.header.header.className, className.string == "METAFILEPICT" else {
            throw OleError.corrupted
        }
        
        /// PresentationDataSize (4 bytes): This MUST be an unsigned long integer set to the sum of the size, in bytes, of the PresentationData
        /// field and the number 8. If this field contains the value 8, the PresentationData field MUST NOT be present.
        self.presentationDataSize = try dataStream.read(endianess: .littleEndian)
        guard self.presentationDataSize >= 8 else {
            throw OleError.corrupted
        }
        
        /// Reserved1 (2 bytes): Reserved. This can be set to any arbitrary value and MUST be ignored on processing.
        self.reserved1 = try dataStream.read(endianess: .littleEndian)
        
        /// Reserved2 (2 bytes): Reserved. This can be set to any arbitrary value and MUST be ignored on processing.
        self.reserved2 = try dataStream.read(endianess: .littleEndian)
        
        /// Reserved3 (2 bytes): Reserved. This can be set to any arbitrary value and MUST be ignored on processing.
        self.reserved3 = try dataStream.read(endianess: .littleEndian)
        
        /// Reserved4 (2 bytes): Reserved. This can be set to any arbitrary value and MUST be ignored on processing.
        self.reserved4 = try dataStream.read(endianess: .littleEndian)
        
        /// PresentationData (variable): This MUST be an array of bytes that contain a metafile (as specified in [MS-WMF] section 1.3.1).
        if self.presentationDataSize != 8 {
            self.presentationData = try dataStream.readBytes(count: Int(self.presentationDataSize) - 8)
        } else {
            self.presentationData = nil
        }
    }
}
