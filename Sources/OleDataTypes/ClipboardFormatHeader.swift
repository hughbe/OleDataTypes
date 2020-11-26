//
//  ClipboardFormatHeader.swift
//  
//
//  Created by Hugh Bellamy on 26/11/2020.
//

import DataStream

/// [MS-OLEDS] 2.2.3.1 ClipboardFormatHeader
/// The ClipboardFormatHeader structure specifies the header for the two types of GenericPresentationObject described as follows:
public struct ClipboardFormatHeader {
    public let header: PresentationObjectHeader
    public let clipboardFormat: UInt32
    
    public init(dataStream: inout DataStream) throws {
        /// Header (variable): This MUST be a PresentationObjectHeader (section 2.2.1). The FormatID field of the PresentationObjectHeader
        /// MUST NOT be set to 0x00000000 and the ClassName field of the Header MUST NOT be set to "METAFILEPICT", "DIB", or "BITMAP".
        self.header = try PresentationObjectHeader(dataStream: &dataStream)
        guard let className = self.header.className,
              className.string != "METAFILEPICT" &&
                className.string != "BITMAP" &&
                className.string != "DIB" else {
            throw OleError.corrupted
        }
        
        /// ClipboardFormat (4 bytes): If this is set to 0x0000000, the ClipboardFormatHeader structure MUST be contained by a
        /// RegisteredClipboardFormatPresentationObject (see section 2.2.3.3). Otherwise, the ClipboardFormatHeader structure MUST be
        /// contained by a StandardClipboardFormatPresentationObject (see section 2.2.3.2). A value other than 0x00000000 MUST identify
        /// a standard clipboard format (section 1.3.5.1)
        self.clipboardFormat = try dataStream.read(endianess: .littleEndian)
    }
}
