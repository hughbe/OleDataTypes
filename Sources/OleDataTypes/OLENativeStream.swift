//
//  OLENativeStream.swift
//  
//
//  Created by Hugh Bellamy on 25/11/2020.
//

import DataStream

/// [MS-OLEDS] 2.3.6 OLENativeStream
/// The OLENativeStream structure is contained inside an OLE Compound File Stream object ([MS-CFB] section 1.3). The OLE Compound File Stream
/// object is named "\1Ole10Native". The stream object is contained within the OLE Compound File Storage object ([MS-CFB] section 1.3) that
/// corresponds to the linked object or embedded object (see section 1.3.3). This stream is present when native data from a container document in the
/// OLE1.0 format is converted to the OLE2.0 format. The OLENativeStream structure specifies the native data for OLE1.0 embedded objects.
public struct OLENativeStream {
    public let nativeDataSize: UInt32
    public let nativeData: [UInt8]
    
    public init(dataStream: inout DataStream, count: Int) throws {
        guard count >= 4 else {
            throw OleError.corrupted
        }
        
        let startPosition = dataStream.position
        
        /// NativeDataSize (4 bytes): This MUST be set to the size, in bytes, of the NativeData field.
        self.nativeDataSize = try dataStream.read(endianess: .littleEndian)
        
        /// NativeData (variable): This MUST be set to an array of bytes that contains the native data.
        self.nativeData = try dataStream.readBytes(count: Int(self.nativeDataSize))
        
        guard dataStream.position - startPosition == count else {
            throw OleError.corrupted
        }
    }
}
