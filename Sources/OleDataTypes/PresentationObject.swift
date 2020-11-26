//
//  PresentationObject.swift
//  
//
//  Created by Hugh Bellamy on 26/11/2020.
//

import DataStream

public enum PresentationObject {
    case metafile(_: MetaFilePresentationObject)
    case bitmap(_: BitmapPresentationObject)
    case dib(_: DIBPresentationObject)
    case standardClipboardFormat(_: StandardClipboardFormatPresentationObject)
    case registeredClipboardFormat(_: RegisteredClipboardFormatPresentationObject)
    
    public init(dataStream: inout DataStream) throws {
        let position = dataStream.position
        let header = try PresentationObjectHeader(dataStream: &dataStream)
        dataStream.position = position
        
        switch header.className?.string {
        case "METAFILEPICT":
            self = .metafile(try MetaFilePresentationObject(dataStream: &dataStream))
        case "BITMAP":
            self = .bitmap(try BitmapPresentationObject(dataStream: &dataStream))
        case "DIB":
            self = .dib(try DIBPresentationObject(dataStream: &dataStream))
        default:
            let position = dataStream.position
            let header = try ClipboardFormatHeader(dataStream: &dataStream)
            dataStream.position = position
            
            switch header.clipboardFormat {
            case 0x00000000:
                self = .standardClipboardFormat(try StandardClipboardFormatPresentationObject(dataStream: &dataStream))
            default:
                self = .registeredClipboardFormat(try RegisteredClipboardFormatPresentationObject(dataStream: &dataStream))
            }
        }
    }
}
