//
//  OLEPresentationStream.swift
//  
//
//  Created by Hugh Bellamy on 26/11/2020.
//

import DataStream

/// [MS-OLEDS] 2.3.4 OLEPresentationStream
/// The OLEPresentationStream structure is contained inside an OLE Compound File Stream object ([MSCFB] section 1.3) within the OLE
/// Compound File Storage object ([MS-CFB] section 1.3) that corresponds to the linked object or embedded object (see section 1.3.3).
/// There MUST be no more than 999 presentation streams in the storage object. The name of the stream is a concatenation of the
/// prefix "\2OlePres" followed by three numeric characters, each of which is in the range of numbers from '0'-'9'. Some examples of stream
/// names are "\2OlePres000", "\2OlePres123", and "\2OlePres999". The OLEPresentationStream structure specifies the presentation data for
/// linked and embedded objects.
public struct OLEPresentationStream {
    public let ansiClipboardFormat: ClipboardFormatOrAnsiString
    public let targetDeviceSize: UInt32
    public let targetDevice: DVTARGETDEVICE?
    public let aspect: UInt32
    public let lindex: UInt32
    public let advf: UInt32
    public let reserved1: UInt32
    public let width: UInt32
    public let height: UInt32
    public let size: UInt32
    public let data: [UInt8]
    public let reserved2: [UInt8]?
    public let tocSignature: UInt32
    public let tocCount: UInt32
    public let tocEntry: [TOCENTRY]
    
    public init(dataStream: inout DataStream) throws {
        /// AnsiClipboardFormat (variable): This MUST be a ClipboardFormatOrAnsiString structure (section 2.3.1) that contains the
        /// Clipboard Format of the presentation data. If the MarkerOrLength field of the ClipboardFormatOrAnsiString structure contains
        /// 0x0000000, the OLEPresentationStream structure is invalid.<15>
        /// If the MarkerOrLength field contains a value other than 0xFFFFFFFF or 0xFFFFFFFE, the value MUST NOT be greater than
        /// 0x00000201. Otherwise, the OLEPresentationStream structure is invalid.<16>
        /// If the FormatOrAnsiString field of the ClipboardFormatOrAnsiString structure contains the value CF_BITMAP (section 1.3.5.1),
        /// the OLEPresentationStream structure is invalid.<17>
        self.ansiClipboardFormat = try ClipboardFormatOrAnsiString(dataStream: &dataStream)
        switch self.ansiClipboardFormat.formatOrAnsiString {
        case .registered(format: let registeredFormat):
            guard registeredFormat.count <= 0x00000201 else {
                throw OleError.corrupted
            }
        case .standard(format: let standardFormat):
            guard standardFormat != CF_BITMAP else {
                throw OleError.corrupted
            }
        case .none:
            throw OleError.corrupted
        }
        
        /// TargetDeviceSize (4 bytes): This MUST be set to a value greater than or equal to 0x00000004. If this is set to 0x00000004, the
        /// TargetDevice field MUST NOT be present. Otherwise, this MUST contain the size of the TargetDevice field in bytes.
        /// 0x00000004 The TargetDevice field MUST NOT be present.
        /// 0x0000005 — 0xFFFFFFFF MUST be the size of the TargetDevice field in bytes.
        self.targetDeviceSize = try dataStream.read(endianess: .littleEndian)
        guard self.targetDeviceSize >= 0x00000004 else {
            throw OleError.corrupted
        }
        
        let startPosition = dataStream.position
        
        /// TargetDevice (variable): This field MUST contain a DVTARGETDEVICE structure (as specified in section 2.1.7).
        if self.targetDeviceSize >= 0x0000005 {
            self.targetDevice = try DVTARGETDEVICE(dataStream: &dataStream, count: Int(self.targetDeviceSize) - 4)
        } else {
            self.targetDevice = nil
        }
        
        guard dataStream.position - startPosition == self.targetDeviceSize - 4 else {
            throw OleError.corrupted
        }
        
        /// Aspect (4 bytes): This field contains an implementation-specific hint on how to render the presentation data on the screen.
        /// It MAY be ignored on processing.<18>
        self.aspect = try dataStream.read(endianess: .littleEndian)
        
        /// Lindex (4 bytes): This field contains an implementation-specific hint on how to render the presentation data on the screen.
        /// It MAY be ignored on processing. <19>
        self.lindex = try dataStream.read(endianess: .littleEndian)
        
        /// Advf (4 bytes): This field contains an implementation-specific hint on how to render the presentation data on the screen.
        /// It MAY be ignored on processing.<20>
        self.advf = try dataStream.read(endianess: .littleEndian)
        
        /// Reserved1 (4 bytes): This can contain any arbitrary value and MUST be ignored on processing.
        self.reserved1 = try dataStream.read(endianess: .littleEndian)
        
        /// Width (4 bytes): This MUST contain the width in pixels of the presentation data.
        /// If the FormatOrAnsiString field of AnsiClipboardFormat contains CF_DIB (section 2.1.1), this MUST be a DIBPresentationWidth
        /// (section 2.1.12).
        /// If the FormatOrAnsiString field of AnsiClipboardFormat contains CF_METAFILEPICT (section 2.1.1), this MUST be a
        /// MetaFilePresentationDataWidth (section 2.1.8).
        /// If the FormatOrAnsiString field of AnsiClipboardFormat contains CF_ENHMETAFILE (section 2.1.1), this MUST be a
        /// EnhancedMetaFilePresentationDataWidth (section 2.1.10).
        self.width = try dataStream.read(endianess: .littleEndian)
        
        /// Height (4 bytes): This MUST contain the height in pixels of the presentation data.
        /// If the FormatOrAnsiString field of AnsiClipboardFormat contains CF_DIB (section 2.1.1), this MUST be a DIBPresentationDataHeight
        /// (section 2.1.13).
        /// If the FormatOrAnsiString field of AnsiClipboardFormat contains CF_METAFILEPICT (section 2.1.1), this MUST be a
        /// MetaFilePresentationDataHeight (section 2.1.9).
        /// If the FormatOrAnsiString field of AnsiClipboardFormat contains CF_ENHMETAFILE (section 2.1.1), this MUST be a
        /// EnhancedMetaFilePresentationDataHeight (section 2.1.11).
        self.height = try dataStream.read(endianess: .littleEndian)
        
        /// Size (4 bytes): This MUST contain the size, in bytes, of the Data field.
        self.size = try dataStream.read(endianess: .littleEndian)
        
        /// Data (variable): This MUST contain the presentation data.
        /// If the FormatOrAnsiString field of AnsiClipboardFormat contains CF_DIB (section 2.1.1), the Data field MUST contain a
        /// DeviceIndependentBitmap Object structure as specified in [MS-WMF] section 2.2.2.9.
        /// If the FormatOrAnsiString field of AnsiClipboardFormat contains CF_METAFILEPICT (section 2.1.1), the Data field MUST contain
        /// a Windows metafile, as specified in [MS-WMF] section 1.3.1.
        /// If, after processing the Data field the end of the stream has not been reached, then the Reserved2 field MUST be present.
        /// If the FormatOrAnsiString field of AnsiClipboardFormat contains CF_ENHMETAFILE (section 2.1.1), the Data field MUST contain
        /// an Enhanced metafile as specified in [MS-WMF] section 1.3.1.
        /// If the FormatOrAnsiString field of AnsiClipboardFormat contains the name of a registered clipboard format (section 2.1.1), the
        /// format of the Data field is specified by the application or the higher level protocol.
        self.data = try dataStream.readBytes(count: Int(self.size))
        
        /// Reserved2 (18 bytes): This field MUST be present if the FormatOrAnsiString field of AnsiClipboardFormat contains
        /// CF_METAFILEPICT (section 2.1.1). Otherwise, this field MUST NOT be present. This field can contain any arbitrary value and MUST
        /// be ignored on receipt.
        if case let .standard(format) = self.ansiClipboardFormat.formatOrAnsiString, format == CF_METAFILEPICT {
            self.reserved2 = try dataStream.readBytes(count: 18)
        } else {
            self.reserved2 = nil
        }
        
        /// TocSignature (4 bytes): If this field does not contain the value 0x494E414E, the TocEntry field MUST NOT be present.
        let tocSignature: UInt32 = try dataStream.read(endianess: .littleEndian)
        self.tocSignature = tocSignature
        
        /// TocCount (4 bytes): This MUST contain the number of elements in the TocEntry array. If 0, the TocEntry structure
        /// MUST NOT be present.
        let tocCount: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard tocCount == 0 || tocSignature == 0x494E414E else {
            throw OleError.corrupted
        }
        
        self.tocCount = tocCount
        
        /// TocEntry (variable): This MUST contain an array of TOCENTRY structures (section 2.3.5). The number of structures MUST be
        /// specified in the TocCount field. The first octet of an array element MUST immediately follow the last octet of the previous element
        /// without any alignment gaps.
        var tocEntry: [TOCENTRY] = []
        tocEntry.reserveCapacity(Int(self.tocCount))
        for _ in 0..<self.tocCount {
            tocEntry.append(try TOCENTRY(dataStream: &dataStream))
        }
        
        self.tocEntry = tocEntry
    }
}
