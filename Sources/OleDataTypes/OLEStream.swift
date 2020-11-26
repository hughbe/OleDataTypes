//
//  OLEStream.swift
//  
//
//  Created by Hugh Bellamy on 25/11/2020.
//

import DataStream
import WindowsDataTypes

/// [MS-OLEDS] 2.3.3 OLEStream
/// The OLEStream structure is contained inside an OLE Compound File Stream object ([MS-CFB] section 1.3). The name of this Compound File Stream
/// object is "\1Ole". The stream object is contained within the OLE Compound File Storage object ([MS-CFB] section 1.3) corresponding to the linked
/// object or embedded object (see section 1.3.3). The OLEStream structure specifies whether the storage object is for a linked object or an embedded
/// object. When this structure specifies a storage object for a linked object, it also specifies the reference to the linked object.
public struct OLEStream {
    public let version: UInt32
    public let flags: Flags
    public let linkUpdateOption: UInt32
    public let reserved1: UInt32
    public let reservedMonikerStreamSize: UInt32
    public let reservedMonikerStream: MONIKERSTREAM?
    public let relativeSourceMonikerStreamSize: UInt32?
    public let relativeSourceMonikerStream: MONIKERSTREAM?
    public let absoluteSourceMonikerStreamSize: UInt32?
    public let absoluteSourceMonikerStream: MONIKERSTREAM?
    public let clsidIndicator: LONG?
    public let clsid: GUID?
    public let reservedDisplayName: LengthPrefixedUnicodeString?
    public let reserved2: UInt32?
    public let localUpdateTime: FILETIME?
    public let localCheckUpdateTime: FILETIME?
    public let remoteUpdateTime: FILETIME?
    
    public init(dataStream: inout DataStream, count: Int) throws {
        let startPosition = dataStream.position
        
        /// Version (4 bytes): This MUST be set to 0x02000001. Otherwise, the OLEStream structure is invalid.<9>
        self.version = try dataStream.read(endianess: .littleEndian)
        guard self.version == 0x02000001 else {
            throw OleError.corrupted
        }
        
        /// Flags (4 bytes): If this field is set to 0x00000001, the OLEStream structure MUST be for a linked object and the CLSID field of the Compound
        /// File Directory Entry ([MS-CFB] section 2.6.1) of the OLE Compound File Storage object ([MS-CFB] section 1.3) MUST be set to
        /// CLSID_StdOleLink ({00000300-0000-0000-C000-000000000046}). If this field is set to 0x00000000, then the OLEStream structure MUST be
        /// for an embedded object and the CLSID field of the Compound File Directory Entry ([MS-CFB] section 2.6.1) of the OLE Compound File
        /// Storage object ([MS-CFB] section 1.3) MUST be set to the object class GUID of the creating application.
        self.flags = Flags(rawValue: try dataStream.read(endianess: .littleEndian))
        
        /// LinkUpdateOption (4 bytes): This field contains an implementation-specific hint supplied by the application or by a higher-level protocol
        /// that creates the data structure. The hint MAY be ignored on processing of this data structure.<11>
        self.linkUpdateOption = try dataStream.read(endianess: .littleEndian)
        
        /// Reserved1 (4 bytes): This MUST be set to 0x00000000. Otherwise, the OLEStream structure is invalid.<12>
        self.reserved1 = try dataStream.read(endianess: .littleEndian)
        guard self.reserved1 == 0x00000000 else {
            throw OleError.corrupted
        }
        
        /// ReservedMonikerStreamSize (4 bytes): This MUST be set to the size, in bytes, of the ReservedMonikerStream field plus the size of this
        /// field. If this field has a value 0x00000000, the ReservedMonikerStream field MUST NOT be present.
        self.reservedMonikerStreamSize = try dataStream.read(endianess: .littleEndian)
        
        /// ReservedMonikerStream (variable): This MUST be a MONIKERSTREAM structure (section 2.3.3.1) that can contain any arbitrary value
        /// and MUST be ignored on processing.
        if self.reservedMonikerStreamSize != 0x00000000 {
            self.reservedMonikerStream = try MONIKERSTREAM(dataStream: &dataStream, count: Int(self.reservedMonikerStreamSize) - 4)
        } else {
            self.reservedMonikerStream = nil
        }
        
        /// Note The fields that follow MUST NOT be present if the OLEStream structure is for an embedded object.
        if dataStream.position - startPosition == count {
            self.relativeSourceMonikerStreamSize = nil
            self.relativeSourceMonikerStream = nil
            self.absoluteSourceMonikerStreamSize = nil
            self.absoluteSourceMonikerStream = nil
            self.clsidIndicator = nil
            self.clsid = nil
            self.reservedDisplayName = nil
            self.reserved2 = nil
            self.localUpdateTime = nil
            self.localCheckUpdateTime = nil
            self.remoteUpdateTime = nil
            return
        } else if !self.flags.contains(.linkedObject) {
            throw OleError.corrupted
        }
        
        /// RelativeSourceMonikerStreamSize (4 bytes): This MUST be set to the size, in bytes, of the RelativeSourceMonikerStream field plus the
        /// size of this field. If this field has a value 0x00000000, the RelativeSourceMonikerStream field MUST NOT be present.
        self.relativeSourceMonikerStreamSize = try dataStream.read(endianess: .littleEndian)
        
        /// RelativeSourceMonikerStream (variable): This MUST be a MONIKERSTREAM structure (section 2.3.3.1) that specifies the relative path
        /// to the linked object.
        if self.relativeSourceMonikerStreamSize != 0x00000000 {
            self.relativeSourceMonikerStream = try MONIKERSTREAM(dataStream: &dataStream, count: Int(self.relativeSourceMonikerStreamSize!) - 4)
        } else {
            self.relativeSourceMonikerStream = nil
        }
        
        /// AbsoluteSourceMonikerStreamSize (4 bytes): This MUST be set to the size, in bytes, of the AbsoluteSourceMonikerStream field plus the
        /// size of this field. This field MUST NOT contain the value 0x00000000.
        self.absoluteSourceMonikerStreamSize = try dataStream.read(endianess: .littleEndian)
        
        /// AbsoluteSourceMonikerStream (variable): This MUST be a MONIKERSTREAM structure (section 2.3.3.1) that specifies the full path to
        /// the linked object. If the RelativeSourceMonikerStream field is present, it MUST be used by the container application instead of the
        /// AbsoluteSourceMonikerStream. If the RelativeSourceMonikerStream field is not present, the AbsoluteSourceMonikerStream MUST be
        /// used by the container application.
        if self.absoluteSourceMonikerStreamSize != 0x00000000 {
            self.absoluteSourceMonikerStream = try MONIKERSTREAM(dataStream: &dataStream, count: Int(self.absoluteSourceMonikerStreamSize!) - 4)
        } else {
            self.absoluteSourceMonikerStream = nil
        }
        
        /// ClsidIndicator (4 bytes): This MUST be the LONG (as specified in section 2.2.27 of [MS-DTYP]) value -1. Otherwise the OLEStream
        /// structure is invalid.<13>
        self.clsidIndicator = try dataStream.read(endianess: .littleEndian)
        guard clsidIndicator == -1 else {
            throw OleError.corrupted
        }
        
        /// Clsid (16 bytes): This MUST be the CLSID (Packet) (section 2.1.2) containing the object class GUID of the creating application.
        self.clsid = try GUID(dataStream: &dataStream)
        
        /// ReservedDisplayName (4 bytes): This MUST be a LengthPrefixedUnicodeString (section 2.1.5) that can contain any arbitrary value and
        /// MUST be ignored on processing.
        self.reservedDisplayName = try LengthPrefixedUnicodeString(dataStream: &dataStream)
        
        /// Reserved2 (4 bytes): This can contain any arbitrary value and MUST be ignored on processing.
        self.reserved2 = try dataStream.read(endianess: .littleEndian)
        
        /// LocalUpdateTime (4 bytes): This MUST be a FILETIME (Packet) (section 2.1.3) that contains the time when the container application last
        /// updated the RemoteUpdateTime field.
        self.localUpdateTime = try FILETIME(dataStream: &dataStream)
        
        /// LocalCheckUpdateTime (4 bytes): This MUST be a FILETIME (Packet) (section 2.1.3) that contains the time when the container application
        /// last checked the update time of the linked object.
        self.localCheckUpdateTime = try FILETIME(dataStream: &dataStream)
        
        /// RemoteUpdateTime (4 bytes): This MUST be a FILETIME (Packet) (section 2.1.3) that contains the time when the linked object was last
        /// updated.
        self.remoteUpdateTime = try FILETIME(dataStream: &dataStream)

        guard dataStream.position - startPosition == count else {
            throw OleError.corrupted
        }
    }
    
    /// Flags (4 bytes): If this field is set to 0x00000001, the OLEStream structure MUST be for a linked object and the CLSID field of the Compound
    /// File Directory Entry ([MS-CFB] section 2.6.1) of the OLE Compound File Storage object ([MS-CFB] section 1.3) MUST be set to
    /// CLSID_StdOleLink ({00000300-0000-0000-C000-000000000046}). If this field is set to 0x00000000, then the OLEStream structure MUST be
    /// for an embedded object and the CLSID field of the Compound File Directory Entry ([MS-CFB] section 2.6.1) of the OLE Compound File
    /// Storage object ([MS-CFB] section 1.3) MUST be set to the object class GUID of the creating application.
    public struct Flags: OptionSet {
        public let rawValue: UInt32
        
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }
        
        /// 0x00000001 The OLEStream structure MUST be for a linked object.
        public static let linkedObject = Flags(rawValue: 0x00000001)
        
        /// 0x00000000 The OLEStream structure MUST be for an embedded object.
        public static let embeddedObject = Flags([])
        
        /// 0x00001000 This bit is set as an implementation-specific hint supplied by the application or by a higherlevel protocol that creates the
        /// data structure. The bit MAY be ignored on processing of this data structure. A server implementation which does not ignore this bit
        /// MAY cache the storage when the bit is set.<10>
        public static let cache = Flags(rawValue: 0x00001000)
        
        public static let all: Flags = [.linkedObject, .embeddedObject, .cache]
    }
}
