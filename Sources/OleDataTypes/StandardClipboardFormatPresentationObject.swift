//
//  StandardClipboardFormatPresentationObject.swift
//  
//
//  Created by Hugh Bellamy on 26/11/2020.
//

import DataStream

/// [MS-OLEDS] 2.2.3.2 StandardClipboardFormatPresentationObject
/// The StandardClipboardFormatPresentationObject structure specifies a presentation data type that is used to display linked objects or
/// embedded objects in container applications. The presentation data is identified using a standard clipboard format (section 1.3.5.1).
public struct StandardClipboardFormatPresentationObject {
    public let header: ClipboardFormatHeader
    public let presentationDataSize: UInt32
    public let presentationData: [UInt8]
    
    public init(dataStream: inout DataStream) throws {
        /// Header (variable): This MUST be a ClipboardFormatHeader (see section 2.2.3.1). The ClipboardFormat field MUST be set to a value
        /// other than 0x00000000.
        self.header = try ClipboardFormatHeader(dataStream: &dataStream)
        guard self.header.clipboardFormat != 0x00000000 else {
            throw OleError.corrupted
        }
        
        /// PresentationDataSize (4 bytes): This MUST be an unsigned long integer set to the size, in bytes, of the PresentationData field.
        self.presentationDataSize = try dataStream.read(endianess: .littleEndian)
        
        let startPosition = dataStream.position
        
        /// PresentationData (variable): This MUST be an array of bytes that contains the presentation data. The format of the data is
        /// identified by the Clipboard Format contained in the Header field.
        /// If the Clipboard Format contains CF_DIB (section 2.1.1), the Data field MUST contain a DeviceIndependentBitmap Object structure
        /// (as specified in [MS-WMF] section 2.2.2.9).
        /// If the Clipboard Format contains CF_METAFILEPICT (section 2.1.1), the Data field MUST contain a Windows metafile (as specified
        /// in [MS-WMF] section 1.3.1). If, after processing the Data field the end of the stream has not been reached, then the Reserved2
        /// field MUST be present.
        /// If the Clipboard Format contains CF_ENHMETAFILE (section 2.1.1), the Data field MUST contain an enhanced metafile
        /// (as specified in [MS-EMF] section 1.3.1).
        self.presentationData = try dataStream.readBytes(count: Int(self.presentationDataSize))
        
        guard dataStream.position - startPosition == self.presentationDataSize else {
            throw OleError.corrupted
        }
    }
}
