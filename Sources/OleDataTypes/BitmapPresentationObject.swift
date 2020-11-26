//
//  BitmapPresentationObject.swift
//
//
//  Created by Hugh Bellamy on 25/11/2020.
//

import DataStream
import MetafileReader

/// [MS-OLEDS] 2.2.2.2 BitmapPresentationObject
/// The BitmapPresentationObject structure specifies a presentation data type that is used to display linked objects or embedded objects in
/// container applications. The presentation data is in the form of a Bitmap16 Object structure (as specified in [MS-WMF] section 2.2.2.1).
public struct BitmapPresentationObject {
    public let header: StandardPresentationObject
    public let presentationDataSize: UInt64
    public let bitmap: Bitmap16?
    
    public init(dataStream: inout DataStream) throws {
        /// Header (variable): This MUST be a StandardPresentationObject (section 2.2.2). The ClassName field of the contained
        /// PresentationObjectHeader (section 2.2.1) MUST be set to the case-sensitive value "BITMAP".
        self.header = try StandardPresentationObject(dataStream: &dataStream)
        guard let className = self.header.header.className, className.string == "BITMAP" else {
            throw OleError.corrupted
        }
        
        /// PresentationDataSize (4 bytes): This MUST be an unsigned long integer set to the size, in bytes, of the Bitmap field. If this field
        /// has the value 0, the Bitmap field MUST NOT be present.
        self.presentationDataSize = try dataStream.read(endianess: .littleEndian)
        
        /// Bitmap (variable): This MUST be a Bitmap16 Object structure as specified in [MS-WMF] section 2.2.2.1.
        if self.presentationDataSize != 0 {
            self.bitmap = try Bitmap16(dataStream: &dataStream)
        } else {
            self.bitmap = nil
        }
    }
}
