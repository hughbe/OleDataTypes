//
//  GenericPresentationObject.swift
//
//
//  Created by Hugh Bellamy on 25/11/2020.
//

import DataStream

/// [MS-OLEDS] 2.2.3 GenericPresentationObject
/// A GenericPresentationObject structure contains a PresentationObjectHeader structure (section 2.2.1).
/// The ClassName field of the PresentationObjectHeader MUST NOT be set to "METAFILEPICT", "DIB", or "BITMAP".
/// There are two types of GenericPresentationObject: the StandardClipboardFormatPresentationObject (section 2.2.3.2) and the
/// RegisteredClipboardFormatPresentationObject (section 2.2.3.3).
public enum GenericPresentationObject {
    case standard(_: StandardClipboardFormatPresentationObject)
    case registered(_: RegisteredClipboardFormatPresentationObject)
    
    public init(dataStream: inout DataStream) throws {
        let position = dataStream.position
        let header = try ClipboardFormatHeader(dataStream: &dataStream)
        guard let className = header.header.className,
              className.string != "METAFILEPICT" &&
                className.string != "BITMAP" &&
                className.string != "DIB" else {
            throw OleError.corrupted
        }
        dataStream.position = position
        
        if header.clipboardFormat == 0x00000000 {
            self = .standard(try StandardClipboardFormatPresentationObject(dataStream: &dataStream))
        } else {
            self = .registered(try RegisteredClipboardFormatPresentationObject(dataStream: &dataStream))
        }
    }
}
