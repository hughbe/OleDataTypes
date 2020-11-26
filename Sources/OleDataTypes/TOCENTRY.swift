//
//  TOCENTRY.swift
//  
//
//  Created by Hugh Bellamy on 26/11/2020.
//

import DataStream

/// [MS-OLEDS] 2.3.5 TOCENTRY
/// The TOCENTRY structure is used to specify the additional values of the attributes of the OLEPresentationStream structure.
/// An OLEPresentationStream structure, if present, MUST have one or more values for attributes such as the Clipboard Format and
/// the target device.
public struct TOCENTRY {
    public let ansiClipboardFormat: ClipboardFormatOrAnsiString
    public let targetDeviceSize: UInt32
    public let aspect: UInt32
    public let lindex: UInt32
    public let tymed: UInt32
    public let reserved1: [UInt32]
    public let advf: UInt32
    public let reserved2: UInt32
    public let targetDevice: DVTARGETDEVICE?
    
    public init(dataStream: inout DataStream) throws {
        /// AnsiClipboardFormat (variable): This MUST be a ClipboardFormatOrAnsiString structure (section 2.3.1) containing the Clipboard
        /// Format of the presentation data.
        self.ansiClipboardFormat = try ClipboardFormatOrAnsiString(dataStream: &dataStream)
        
        /// TargetDeviceSize (4 bytes): This MUST contain the size, in bytes, of the TargetDevice field.
        self.targetDeviceSize = try dataStream.read(endianess: .littleEndian)
        
        /// Aspect (4 bytes): This field contains an implementation-specific hint on how to render the presentation data on the screen.
        /// It MAY be ignored on processing.<21>
        self.aspect = try dataStream.read(endianess: .littleEndian)
        
        /// Lindex (4 bytes): This field contains an implementation-specific hint on how to render the presentation data on the screen.
        /// It MAY be ignored on processing.<22>
        self.lindex = try dataStream.read(endianess: .littleEndian)
        
        /// Tymed (4 bytes): This field MUST be ignored on processing.
        self.tymed = try dataStream.read(endianess: .littleEndian)

        /// Reserved1 (12 bytes): This can contain any arbitrary value and MUST be ignored on processing.
        self.reserved1 = [
            try dataStream.read(endianess: .littleEndian),
            try dataStream.read(endianess: .littleEndian),
            try dataStream.read(endianess: .littleEndian)
        ]
        
        /// Advf (4 bytes): This field contains an implementation-specific hint on how to render the presentation data on the screen.
        /// It MAY be ignored on processing.<23>
        self.advf = try dataStream.read(endianess: .littleEndian)
        
        /// Reserved2 (4 bytes): This can contain any arbitrary value and MUST be ignored on processing.
        self.reserved2 = try dataStream.read(endianess: .littleEndian)
        
        let startPosition = dataStream.position
        
        /// TargetDevice (variable): This field MUST contain a DVTARGETDEVICE structure (as specified in section 2.1.7).
        if self.targetDeviceSize != 0 {
            self.targetDevice = try DVTARGETDEVICE(dataStream: &dataStream, count: Int(self.targetDeviceSize))
        } else {
            self.targetDevice = nil
        }
        
        guard dataStream.position - startPosition == self.targetDeviceSize else {
            throw OleError.corrupted
        }
    }
}
