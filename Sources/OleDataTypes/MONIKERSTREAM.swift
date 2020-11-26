//
//  MONIKERSTREAM.swift
//  
//
//  Created by Hugh Bellamy on 25/11/2020.
//

import DataStream
import WindowsDataTypes

/// [MS-OLEDS] 2.3.3.1 MONIKERSTREAM
/// The MONIKERSTREAM structure specifies the reference to the linked object.
public struct MONIKERSTREAM {
    public let clsid: GUID
    public let streamData: [UInt8]
    
    public init(dataStream: inout DataStream, count: Int) throws {
        guard count >= 16 else {
            throw OleError.corrupted
        }
        
        let startPosition = dataStream.position
        
        /// Clsid (16 bytes): This MUST be the packetized CLSID (section 2.1.2) of an implementation-specific object capable of processing the data
        /// contained in the StreamData field.
        self.clsid = try GUID(dataStream: &dataStream)
        
        /// StreamData (variable): This MUST be an array of bytes that specifies the reference to the linked object. The value of this array is interpreted
        /// in an implementation-specific manner.<14>
        let remainingBytes = count - (dataStream.position - startPosition)
        self.streamData = try dataStream.readBytes(count: remainingBytes)
        
        guard dataStream.position - startPosition == count else {
            throw OleError.corrupted
        }
    }
}
