//
//  CompObjHeader.swift
//  
//
//  Created by Hugh Bellamy on 03/11/2020.
//

import DataStream
import WindowsDataTypes

/// [MS-OLEDS] 2.3.7 CompObjHeader
/// The CompObjHeader structure specifies the header of the CompObjStream structure (section 2.3.8).
/// See also https://github.com/PubDom/Windows-Server-2003/blob/master/com/ole32/ole232/base/privstm.cpp
public struct CompObjHeader {
    /// Note: this is actually:
    /// Byte Order (2 bytes): This field MUST be set to 0xFFFE. This field is a byte order mark for all
    /// integer fields, specifying little-endian byte order.
    /// Format Version (2 bytes): This field MUST be set to 0x0001
    public let reserved1: UInt32
    
    /// Note: this is actually:
    /// Original OS Version (4 bytes): This field MUST be set to 0x00000A03 - it is always Windows 3.1
    public let version: UInt32
    
    /// Note this is actually:
    /// Reserved (4 bytes): This field MUST be set to 0xFFFFFFFF.
    /// Clsid (16 bytes): This MUST be the CLSID (Packet) (section 2.1.2) containing the object class GUID of the creating application.
    public let reserved2: [UInt8]
    
    public init(dataStream: inout DataStream) throws {
        /// Reserved1 (4 bytes): This can be set to any arbitrary value and MUST be ignored on processing.
        self.reserved1 = try dataStream.read(endianess: .littleEndian)
        
        /// Version (4 bytes): This can be set to any arbitrary value and MUST be ignored on processing.
        self.version = try dataStream.read(endianess: .littleEndian)
        
        //let x: UInt32 = try dataStream.read(endianess: .littleEndian)
        //let y: GUID = try GUID(dataStream: &dataStream)
        
        /// Reserved2 (20 bytes): This can be set to any arbitrary value and MUST be ignored on processing.
        self.reserved2 = try dataStream.readBytes(count: 20)
    }
}
