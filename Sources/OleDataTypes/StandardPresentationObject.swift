//
//  StandardPresentationObject.swift
//  
//
//  Created by Hugh Bellamy on 25/11/2020.
//

import DataStream

/// [MS-OLEDS] 2.2.2 StandardPresentationObject
/// A StandardPresentationObject structure contains a PresentationObjectHeader structure (section 2.2.1). The ClassName field of the
/// PresentationObjectHeader MUST be set to the case-sensitive values "METAFILEPICT", "DIB", or "BITMAP".
public struct StandardPresentationObject {
    public let header: PresentationObjectHeader
    public let width: UInt32
    public let height: UInt32
    
    public init(dataStream: inout DataStream) throws {
        /// Header (variable): This MUST be a PresentationObjectHeader (section 2.2.1). The FormatID field of the Header MUST NOT be set
        /// to 0x00000000 and the ClassName field of the Header MUST be set to the case-sensitive values "METAFILEPICT", "BITMAP", or
        /// "DIB". The ClassName field identifies the type of the presentation data structure that follows the StandardPresentationObject.
        self.header = try PresentationObjectHeader(dataStream: &dataStream)
        guard let className = self.header.className,
              className.string == "METAFILEPICT" ||
                className.string == "BITMAP" ||
                className.string == "DIB" else {
            throw OleError.corrupted
        }
        
        /// Width (4 bytes): This MUST be set to the width of the presentation object. If the ClassName field of the Header is set to the
        /// case-sensitive value "METAFILEPICT", this MUST be a MetaFilePresentationDataWidth (section 2.1.8). If the ClassName field
        /// of the Header is set to either the case-sensitive value "BITMAP" or the case-sensitive value "DIB", this MUST be a
        /// DIBPresentationDataWidth (section 2.1.12).
        self.width = try dataStream.read(endianess: .littleEndian)
        
        /// Height (4 bytes): This MUST be set to the height of the presentation object multiplied by the LONG (as specified in [MS-DTYP]
        /// section 2.2.27) value -1. If the ClassName field of the Header is set to the case-sensitive value "METAFILEPICT", this MUST be a
        /// MetaFilePresentationDataHeight (section 2.1.9). If the ClassName field of the Header is set to either the case-sensitive value
        /// "BITMAP" or the case-sensitive value "DIB", this MUST be a DIBPresentationDataHeight (section 2.1.13).
        /// There are three types of StandardPresentationObject. These are specified as follows
        self.height = try dataStream.read(endianess: .littleEndian)
    }
}
