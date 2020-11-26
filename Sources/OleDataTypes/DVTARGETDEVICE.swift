//
//  DVTARGETDEVICE.swift
//  
//
//  Created by Hugh Bellamy on 25/11/2020.
//

import DataStream

/// [MS-OLEDS] 2.1.7 DVTARGETDEVICE
/// The DVTARGETDEVICE structure specifies information about a device (such as a display or printer device) that renders the presentation data.
public struct DVTARGETDEVICE {
    public let driverNameOffSet: UInt16
    public let deviceNameOffSet: UInt16
    public let portNameOffSet: UInt16
    public let extDevModeOffSet: UInt16
    public let driverName: String?
    public let deviceName: String?
    public let portName: String?
    public let extDevMode: DEVMODEA?
    
    public init(dataStream: inout DataStream, count: Int) throws {
        let startPosition = dataStream.position
        
        /// DriverNameOffSet (2 bytes): This MUST be set to the offset, in bytes, from the beginning of the structure to the DriverName field.
        /// If this field is set to 0x0000, the DriverName field MUST NOT be present.
        let driverNameOffSet: UInt16 = try dataStream.read(endianess: .littleEndian)
        self.driverNameOffSet = driverNameOffSet
        
        /// DeviceNameOffSet (2 bytes): This MUST be set to the offset, in bytes, from the beginning of the structure to the DeviceName field.
        /// If this field is set to 0x0000, the DeviceName field MUST NOT be present.
        let deviceNameOffSet: UInt16 = try dataStream.read(endianess: .littleEndian)
        self.deviceNameOffSet = deviceNameOffSet
        
        /// PortNameOffSet (2 bytes): This MUST be set to the offset, in bytes, from the beginning of the structure to the PortName field.
        /// If this field is set to 0x0000, the PortName field MUST NOT be present.
        let portNameOffSet: UInt16 = try dataStream.read(endianess: .littleEndian)
        self.portNameOffSet = portNameOffSet
        
        /// ExtDevModeOffSet (2 bytes): This MUST be set to the offset, in bytes, from the beginning of the structure to the ExtDevMode field.
        /// If this field is set to 0x0000, the ExtDevMode field MUST NOT be present. Any gaps between the end of this field and the beginning
        /// of the next field MUST be ignored on processing.
        let extDevModeOffSet: UInt16 = try dataStream.read(endianess: .littleEndian)
        self.extDevModeOffSet = extDevModeOffSet
        
        let endPosition = dataStream.position
        
        /// DriverName (variable): This MUST be a null-terminated ANSI string that contains a hint on how to display or print presentation data.
        /// The creator of this data structure MUST NOT assume that it will be understood during processing. On processing, the hint MAY be
        /// ignored. Any gaps between the end of this field and the beginning of the next field MUST be ignored on processing.<3>
        if driverNameOffSet != 0x0000 {
            guard startPosition + Int(driverNameOffSet) > endPosition &&
                    startPosition + Int(driverNameOffSet) < startPosition + count &&
                    startPosition + Int(driverNameOffSet) < dataStream.count else {
                throw OleError.corrupted
            }
            
            dataStream.position = startPosition + Int(driverNameOffSet)
            self.driverName = try dataStream.readAsciiString()
        } else {
            self.driverName = nil
        }
        
        /// DeviceName (variable): This MUST be a null-terminated ANSI string that contains a hint on how to display or print presentation data.
        /// The creator of this data structure MUST NOT assume that it will be understood during processing. On processing, the hint MAY be
        /// ignored. Any gaps between the end of this field and the beginning of the next field MUST be ignored on processing. This field is
        /// optional.<4>
        if deviceNameOffSet != 0x0000 {
            guard startPosition + Int(deviceNameOffSet) > endPosition &&
                    startPosition + Int(deviceNameOffSet) < startPosition + count &&
                    startPosition + Int(deviceNameOffSet) < dataStream.count else {
                throw OleError.corrupted
            }
            
            dataStream.position = startPosition + Int(deviceNameOffSet)
            self.deviceName = try dataStream.readAsciiString()
        } else {
            self.deviceName = nil
        }
        
        /// PortName (variable): This MUST be a null-terminated ANSI string that contains any arbitrary value and MUST be ignored on
        /// processing. Any gaps between the end of this field and the beginning of the next field MUST be ignored on processing. This field
        /// is optional.
        if portNameOffSet != 0x0000 {
            guard startPosition + Int(portNameOffSet) > endPosition &&
                    startPosition + Int(portNameOffSet) < startPosition + count &&
                    startPosition + Int(portNameOffSet) < dataStream.count else {
                throw OleError.corrupted
            }
            
            dataStream.position = startPosition + Int(portNameOffSet)
            self.portName = try dataStream.readAsciiString()
        } else {
            self.portName = nil
        }
        
        /// ExtDevMode (variable): This MUST contain a DEVMODEA structure (as specified in section 2.1.6). This field is optional.
        if extDevModeOffSet != 0x0000 {
            guard startPosition + Int(extDevModeOffSet) > endPosition &&
                    startPosition + Int(extDevModeOffSet) < startPosition + count &&
                    startPosition + Int(extDevModeOffSet) < dataStream.count else {
                throw OleError.corrupted
            }
            
            dataStream.position = startPosition + Int(extDevModeOffSet)
            self.extDevMode = try DEVMODEA(dataStream: &dataStream)
        } else {
            self.extDevMode = nil
        }
        
        guard dataStream.position - startPosition == count else {
            throw OleError.corrupted
        }
    }
}
