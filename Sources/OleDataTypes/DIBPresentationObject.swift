//
//  DIBPresentationObject.swift
//
//
//  Created by Hugh Bellamy on 25/11/2020.
//

import DataStream
import WmfReader

/// [MS-OLEDS] 2.2.2.3 DIBPresentationObject
/// The DIBPresentationObject structure specifies a presentation data type that is used to display linked objects or embedded objects in container
/// applications. The presentation data is in the form of a DeviceIndependentBitmap object structure (as specified in [MS-WMF] section 2.2.2.9).
public struct DIBPresentationObject {
    public let header: StandardPresentationObject
    public let presentationDataSize: UInt32
    public let dib: DeviceIndependentBitmap?
    
    public init(dataStream: inout DataStream) throws {
        /// Header (variable): This MUST be a StandardPresentationObject (section 2.2.2). The ClassName field of the contained
        /// PresentationObjectHeader (section 2.2.1) MUST be set to the case-sensitive value "METAFILEPICT".
        self.header = try StandardPresentationObject(dataStream: &dataStream)
        guard let className = self.header.header.className, className.string == "METAFILEPICT" else {
            throw OleError.corrupted
        }
        
        /// PresentationDataSize (4 bytes): This MUST be an unsigned long integer set to the size, in bytes, of the DIB field. If this field has
        /// the value 0, the DIB field MUST NOT be present.
        self.presentationDataSize = try dataStream.read(endianess: .littleEndian)

        /// DIB (variable): This MUST be a DeviceIndependentBitmap Object structure as specified in [MSWMF] section 2.2.2.9.
        if self.presentationDataSize != 0 {
            self.dib = try DeviceIndependentBitmap(dataStream: &dataStream)
        } else {
            self.dib = nil
        }
    }
}
