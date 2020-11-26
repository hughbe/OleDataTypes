//
//  CompObjStream.swift
//  
//
//  Created by Hugh Bellamy on 25/11/2020.
//

import DataStream

/// [MS-OLEDS] 2.3.8 CompObjStream
/// The CompObjStream structure is contained inside of an OLE Compound File Stream (as specified in [MS-CFB]). The OLE Compound File Stream
/// has the name "\1CompObj". The CompObjStream structure specifies the Clipboard Format and the display name of the linked object or embedded
/// object.
/// See also https://github.com/PubDom/Windows-Server-2003/blob/master/com/ole32/ole232/base/privstm.cpp
public struct CompObjStream {
    public let header: CompObjHeader
    public let ansiUserType: LengthPrefixedAnsiString
    public let ansiClipboardFormat: ClipboardFormatOrAnsiString
    /// Note: this is actually ansiProgID
    public let reserved1: LengthPrefixedAnsiString?
    public let unicodeMarker: UInt32?
    public let unicodeUserType: LengthPrefixedUnicodeString?
    public let unicodeClipboardFormat: ClipboardFormatOrUnicodeString?
    /// Note: this is actually unicodeProgID
    public let reserved2: LengthPrefixedUnicodeString?
    
    public init(dataStream: inout DataStream, count: Int) throws {
        let startPosition = dataStream.position
        
        /// Header (28 bytes): This MUST be a CompObjHeader structure (section 2.3.7).
        self.header = try CompObjHeader(dataStream: &dataStream)
        
        /// AnsiUserType (variable): This MUST be a LengthPrefixedAnsiString structure (section 2.1.4) that contains a display name of the linked
        /// object or embedded object.
        self.ansiUserType = try LengthPrefixedAnsiString(dataStream: &dataStream)
        
        /// AnsiClipboardFormat (variable): This MUST be a ClipboardFormatOrAnsiString structure (section 2.3.1) that contains the Clipboard
        /// Format of the linked object or embedded object. If the MarkerOrLength field of the ClipboardFormatOrAnsiString structure contains a
        /// value other than 0x00000000, 0xffffffff, or 0xfffffffe, the value MUST NOT be greater than 0x00000190. Otherwise the CompObjStream
        /// structure is invalid.<24>
        self.ansiClipboardFormat = try ClipboardFormatOrAnsiString(dataStream: &dataStream)
        
        // Subsequent fields may not be present in early versions of OLE.
        // See https://github.com/PubDom/Windows-Server-2003/tree/master/com/ole32/ole232/base/privstm.cpp
        if dataStream.position - startPosition == count {
            self.reserved1 = nil
            self.unicodeMarker = nil
            self.unicodeUserType = nil
            self.unicodeClipboardFormat = nil
            self.reserved2 = nil
            return
        }
        
        /// Reserved1 (variable): If present, this MUST be a LengthPrefixedAnsiString structure (section 2.1.4). If the Length field of the
        /// LengthPrefixedAnsiString contains a value of 0 or a value that is greater than 0x00000028 , the remaining fields of the structure starting
        /// with the String field of the LengthPrefixedAnsiString MUST be ignored on processing.
        /// If the String field of the LengthPrefixedAnsiString is not present, the remaining fields of the structure starting with the UnicodeMarker
        /// field MUST be ignored on processing.
        /// Otherwise, the String field of the LengthPrefixedAnsiString MUST be ignored on processing.
        let nextField = try dataStream.peek(endianess: .littleEndian) as UInt32
        guard nextField != 0 && nextField <= 0x00000028 else {
            self.reserved1 = nil
            self.unicodeMarker = nil
            self.unicodeUserType = nil
            self.unicodeClipboardFormat = nil
            self.reserved2 = nil
            return
        }
        
        self.reserved1 = try LengthPrefixedAnsiString(dataStream: &dataStream)
        
        /// UnicodeMarker (variable): If this field is present and is NOT set to 0x71B239F4, the remaining fields of the structure MUST be ignored on
        /// processing.
        self.unicodeMarker = try dataStream.read(endianess: .littleEndian)
        guard self.unicodeMarker == 0x71B239F4 else {
            self.unicodeUserType = nil
            self.unicodeClipboardFormat = nil
            self.reserved2 = nil
            return
        }
        
        /// UnicodeUserType (variable): This MUST be a LengthPrefixedUnicodeString structure (section 2.1.5) that contains a display name of the
        /// linked object or embedded object.
        self.unicodeUserType = try LengthPrefixedUnicodeString(dataStream: &dataStream)
        
        /// UnicodeClipboardFormat (variable): This MUST be a ClipboardFormatOrUnicodeString structure (section 2.3.2) that contains a
        /// Clipboard Format of the linked object or embedded object. If the MarkerOrLength field of the ClipboardFormatOrUnicodeString structure
        /// contains a value other than 0x00000000, 0xffffffff, or 0xfffffffe, the value MUST NOT be more than 0x00000190.
        /// Otherwise, the CompObjStream structure is invalid. <25>
        self.unicodeClipboardFormat = try ClipboardFormatOrUnicodeString(dataStream: &dataStream)
        
        /// Reserved2 (variable): This MUST be a LengthPrefixedUnicodeString (section 2.1.5). The String field of the LengthPrefixedUnicodeString
        /// can contain any arbitrary value and MUST be ignored on processing.
        self.reserved2 = try LengthPrefixedUnicodeString(dataStream: &dataStream)
    }
}
