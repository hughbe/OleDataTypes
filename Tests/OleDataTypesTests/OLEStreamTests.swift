import XCTest
import DataStream
import WindowsDataTypes
@testable import OleDataTypes

final class OLEStreamTests: XCTestCase {
    func testExample() throws {
        do {
            /// [MS-OLEDS] 3.1 OLEStream Structure - Embedded Object
            /// This section describes the binary layout of an OLEStream (section 2.3.3) structure that represents an embedded object.
            let buffer: [UInt8] = [
                0x01, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00
            ]
            var dataStream = DataStream(buffer)
            let stream = try OLEStream(dataStream: &dataStream, count: dataStream.count)
            XCTAssertEqual(0x02000001, stream.version)
            XCTAssertEqual(.embeddedObject, stream.flags)
            XCTAssertEqual(0x00000000, stream.linkUpdateOption)
            XCTAssertEqual(0, dataStream.remainingCount)
        }
        do {
            /// [MS-OLEDS] 3.2 OLEStream Structure - Linked Object
            /// This section describes the binary layout of an OLEStream (section 2.3.3) structure that represents a linked object.
            let buffer: [UInt8] = [
                0x01, 0x00, 0x00, 0x02, 0x01, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x55, 0x00, 0x00, 0x00, 0x03, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0xc0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x46, 0x01, 0x00, 0x09, 0x00, 0x00, 0x00, 0x74, 0x65,
                0x73, 0x74, 0x2E, 0x78, 0x6C, 0x73, 0x00, 0xFF, 0xFF, 0xAD, 0xDE, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x16,
                0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x03, 0x00, 0x74, 0x00, 0x65, 0x00, 0x73, 0x00, 0x74,
                0x00, 0x2E, 0x00, 0x78, 0x00, 0x6C, 0x00, 0x73, 0x00, 0x65, 0x02, 0x00, 0x00, 0x03, 0x03, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0xC0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x46, 0x00, 0x00, 0x18,
                0x00, 0x00, 0x00, 0x45, 0x3A, 0x5C, 0x6F, 0x6C, 0x65, 0x64, 0x73, 0x5C, 0x65, 0x78, 0x63, 0x65,
                0x6C, 0x5C, 0x74, 0x65, 0x73, 0x74, 0x2E, 0x78, 0x6C, 0x73, 0x00, 0xFF, 0xFF, 0xAD, 0xDE, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02,
                0x00, 0x00, 0x00, 0x17, 0x02, 0x00, 0x00, 0x2E, 0x00, 0x00, 0x00, 0x03, 0x00, 0x45, 0x00, 0x3A,
                0x00, 0x5C, 0x00, 0x6F, 0x00, 0x6C, 0x00, 0x65, 0x00, 0x64, 0x00, 0x73, 0x00, 0x5C, 0x00, 0x65,
                0x00, 0x78, 0x00, 0x63, 0x00, 0x65, 0x00, 0x6C, 0x00, 0x5C, 0x00, 0x74, 0x00, 0x65, 0x00, 0x73,
                0x00, 0x74, 0x00, 0x2E, 0x00, 0x78, 0x00, 0x6C, 0x00, 0x73, 0x00, 0xDD, 0x01, 0x00, 0x00, 0x05,
                0x00, 0x4C, 0x00, 0x00, 0x00, 0x01, 0x14, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0xc0, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x46, 0x83, 0x00, 0x00, 0x00, 0x20, 0x08, 0x00, 0x00, 0x7d, 0x69, 0xd0,
                0x31, 0xC4, 0xAF, 0xC8, 0x01, 0xD6, 0xCB, 0xD2, 0x31, 0xC4, 0xAF, 0xC8, 0x01, 0xE0, 0x5B, 0x7E,
                0xA2, 0xC4, 0xAF, 0xC8, 0x01, 0x00, 0x58, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xdb, 0x00, 0x14,
                0x00, 0x1F, 0x50, 0xE0, 0x4F, 0xD0, 0x20, 0xEA, 0x3A, 0x69, 0x10, 0xA2, 0xD8, 0x08, 0x00, 0x2B,
                0x30, 0x30, 0x9D, 0x19, 0x00, 0x2F, 0x45, 0x3A, 0x5C, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x36, 0x00, 0x31, 0x00,
                0x00, 0x00, 0x00, 0x00, 0xA6, 0x38, 0xED, 0x9E, 0x10, 0x08, 0x6F, 0x6C, 0x65, 0x64, 0x73, 0x00,
                0x22, 0x00, 0x03, 0x00, 0x04, 0x00, 0xEF, 0xBE, 0x8C, 0x38, 0x78, 0x0E, 0xA6, 0x38, 0xED, 0x9E,
                0x14, 0x00, 0x00, 0x00, 0x6F, 0x00, 0x6C, 0x00, 0x65, 0x00, 0x64, 0x00, 0x73, 0x00, 0x00, 0x00,
                0x14, 0x00, 0x36, 0x00, 0x31, 0x00, 0x00, 0x00, 0x00, 0x00, 0xa6, 0x38, 0x08, 0xB3, 0x10, 0x08,
                0x65, 0x78, 0x63, 0x65, 0x6C, 0x00, 0x22, 0x00, 0x03, 0x00, 0x04, 0x00, 0xEF, 0xBE, 0x99, 0x38,
                0xB2, 0x0A, 0xA6, 0x38, 0x08, 0xB3, 0x14, 0x00, 0x00, 0x00, 0x65, 0x00, 0x78, 0x00, 0x63, 0x00,
                0x65, 0x00, 0x6C, 0x00, 0x00, 0x00, 0x14, 0x00, 0x40, 0x00, 0x32, 0x00, 0x00, 0x58, 0x00, 0x00,
                0xA6, 0x38, 0x37, 0xB3, 0x20, 0x08, 0x74, 0x65, 0x73, 0x74, 0x2E, 0x78, 0x6C, 0x73, 0x00, 0x00,
                0x28, 0x00, 0x03, 0x00, 0x04, 0x00, 0xEF, 0xBE, 0xA6, 0x38, 0x33, 0xAF, 0xA6, 0x38, 0x33, 0xAF,
                0x14, 0x00, 0x00, 0x00, 0x74, 0x00, 0x65, 0x00, 0x73, 0x00, 0x74, 0x00, 0x2E, 0x00, 0x78, 0x00,
                0x6C, 0x00, 0x73, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x00, 0x50, 0x00, 0x00, 0x00, 0x1C, 0x00,
                0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x1C, 0x00, 0x00, 0x00, 0x37, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x4F, 0x00, 0x00, 0x00, 0x1B, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0xE1, 0x99,
                0x1E, 0x18, 0x10, 0x00, 0x00, 0x00, 0x4E, 0x65, 0x77, 0x20, 0x56, 0x6F, 0x6C, 0x75, 0x6D, 0x65,
                0x00, 0x45, 0x3A, 0x5C, 0x6F, 0x6C, 0x65, 0x64, 0x73, 0x5C, 0x65, 0x78, 0x63, 0x65, 0x6C, 0x5C,
                0x74, 0x65, 0x73, 0x74, 0x2E, 0x78, 0x6C, 0x73, 0x00, 0x00, 0x60, 0x00, 0x00, 0x00, 0x03, 0x00,
                0x00, 0xA0, 0x58, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x78, 0x78, 0x78, 0x78, 0x78, 0x78,
                0x78, 0x78, 0x78, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xB6, 0xF5, 0x56, 0x97, 0xAB, 0x4A,
                0x6A, 0x40, 0xB6, 0xb1, 0x84, 0xE1, 0x8D, 0xD1, 0x76, 0xEE, 0xAC, 0x14, 0xD9, 0x7D, 0x90, 0x18,
                0xDD, 0x11, 0xBA, 0xD5, 0x00, 0x0B, 0xDB, 0xCA, 0x27, 0x8E, 0xB6, 0xF5, 0x56, 0x97, 0xAb, 0x4A,
                0x6A, 0x40, 0xB6, 0xB1, 0x84, 0xE1, 0x8D, 0xD1, 0x76, 0xEE, 0xAC, 0x14, 0xD9, 0x7D, 0x90, 0x18,
                0xDD, 0x11, 0xBA, 0xD5, 0x00, 0x0B, 0xDB, 0xCA, 0x27, 0x8E, 0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF,
                0xFF, 0xFF, 0x20, 0x08, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0xc0, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x46, 0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xF0, 0x4E, 0x44, 0x26, 0xC8, 0xAF,
                0xC8, 0x01, 0x60, 0xB9, 0x45, 0x27, 0xC8, 0xAF, 0xC8, 0x01, 0xF0, 0x4e, 0x44, 0x26, 0xC8, 0xAF,
                0xC8, 0x01
            ]
            var dataStream = DataStream(buffer)
            let stream = try OLEStream(dataStream: &dataStream, count: dataStream.count)
            XCTAssertEqual(0x02000001, stream.version)
            XCTAssertEqual(.linkedObject, stream.flags)
            XCTAssertEqual(0x00000001, stream.linkUpdateOption)
            XCTAssertEqual(0x00000000, stream.reserved1)
            XCTAssertEqual(0x00000055, stream.relativeSourceMonikerStreamSize)
            XCTAssertEqual("00000303-0000-0000-C000-000000000046", stream.relativeSourceMonikerStream?.clsid.description)
            XCTAssertEqual([0x01, 0x00, 0x09, 0x00, 0x00, 0x00, 0x74, 0x65, 0x73, 0x74, 0x2E, 0x78, 0x6C, 0x73, 0x00, 0xFF, 0xFF, 0xAD, 0xDE, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x16, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x03, 0x00, 0x74, 0x00, 0x65, 0x00, 0x73, 0x00, 0x74, 0x00, 0x2E, 0x00, 0x78, 0x00, 0x6C, 0x00, 0x73, 0x00], stream.relativeSourceMonikerStream?.streamData)
            XCTAssertEqual(0x00000265, stream.absoluteSourceMonikerStreamSize)
            XCTAssertEqual("00000303-0000-0000-C000-000000000046", stream.absoluteSourceMonikerStream?.clsid.description)
            XCTAssertEqual([0x00, 0x00, 0x18, 0x00, 0x00, 0x00, 0x45, 0x3A, 0x5C, 0x6F, 0x6C, 0x65, 0x64, 0x73, 0x5C, 0x65, 0x78, 0x63, 0x65, 0x6C, 0x5C, 0x74, 0x65, 0x73, 0x74, 0x2E, 0x78, 0x6C, 0x73, 0x00, 0xFF, 0xFF, 0xAD, 0xDE, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x17, 0x02, 0x00, 0x00, 0x2E, 0x00, 0x00, 0x00, 0x03, 0x00, 0x45, 0x00, 0x3A, 0x00, 0x5C, 0x00, 0x6F, 0x00, 0x6C, 0x00, 0x65, 0x00, 0x64, 0x00, 0x73, 0x00, 0x5C, 0x00, 0x65, 0x00, 0x78, 0x00, 0x63, 0x00, 0x65, 0x00, 0x6C, 0x00, 0x5C, 0x00, 0x74, 0x00, 0x65, 0x00, 0x73, 0x00, 0x74, 0x00, 0x2E, 0x00, 0x78, 0x00, 0x6C, 0x00, 0x73, 0x00, 0xDD, 0x01, 0x00, 0x00, 0x05, 0x00, 0x4C, 0x00, 0x00, 0x00, 0x01, 0x14, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0xC0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x46, 0x83, 0x00, 0x00, 0x00, 0x20, 0x08, 0x00, 0x00, 0x7D, 0x69, 0xD0, 0x31, 0xC4, 0xAF, 0xC8, 0x01, 0xD6, 0xCB, 0xD2, 0x31, 0xC4, 0xAF, 0xC8, 0x01, 0xE0, 0x5B, 0x7E, 0xA2, 0xC4, 0xAF, 0xC8, 0x01, 0x00, 0x58, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xDB, 0x00, 0x14, 0x00, 0x1F, 0x50, 0xE0, 0x4F, 0xD0, 0x20, 0xEA, 0x3A, 0x69, 0x10, 0xA2, 0xD8, 0x08, 0x00, 0x2B, 0x30, 0x30, 0x9D, 0x19, 0x00, 0x2F, 0x45, 0x3A, 0x5C, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x36, 0x00, 0x31, 0x00, 0x00, 0x00, 0x00, 0x00, 0xA6, 0x38, 0xED, 0x9E, 0x10, 0x08, 0x6F, 0x6C, 0x65, 0x64, 0x73, 0x00, 0x22, 0x00, 0x03, 0x00, 0x04, 0x00, 0xEF, 0xBE, 0x8C, 0x38, 0x78, 0x0E, 0xA6, 0x38, 0xED, 0x9E, 0x14, 0x00, 0x00, 0x00, 0x6F, 0x00, 0x6C, 0x00, 0x65, 0x00, 0x64, 0x00, 0x73, 0x00, 0x00, 0x00, 0x14, 0x00, 0x36, 0x00, 0x31, 0x00, 0x00, 0x00, 0x00, 0x00, 0xA6, 0x38, 0x08, 0xB3, 0x10, 0x08, 0x65, 0x78, 0x63, 0x65, 0x6C, 0x00, 0x22, 0x00, 0x03, 0x00, 0x04, 0x00, 0xEF, 0xBE, 0x99, 0x38, 0xB2, 0x0A, 0xA6, 0x38, 0x08, 0xB3, 0x14, 0x00, 0x00, 0x00, 0x65, 0x00, 0x78, 0x00, 0x63, 0x00, 0x65, 0x00, 0x6C, 0x00, 0x00, 0x00, 0x14, 0x00, 0x40, 0x00, 0x32, 0x00, 0x00, 0x58, 0x00, 0x00, 0xA6, 0x38, 0x37, 0xB3, 0x20, 0x08, 0x74, 0x65, 0x73, 0x74, 0x2E, 0x78, 0x6C, 0x73, 0x00, 0x00, 0x28, 0x00, 0x03, 0x00, 0x04, 0x00, 0xEF, 0xBE, 0xA6, 0x38, 0x33, 0xAF, 0xA6, 0x38, 0x33, 0xAF, 0x14, 0x00, 0x00, 0x00, 0x74, 0x00, 0x65, 0x00, 0x73, 0x00, 0x74, 0x00, 0x2E, 0x00, 0x78, 0x00, 0x6C, 0x00, 0x73, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x00, 0x50, 0x00, 0x00, 0x00, 0x1C, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x1C, 0x00, 0x00, 0x00, 0x37, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x4F, 0x00, 0x00, 0x00, 0x1B, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0xE1, 0x99, 0x1E, 0x18, 0x10, 0x00, 0x00, 0x00, 0x4E, 0x65, 0x77, 0x20, 0x56, 0x6F, 0x6C, 0x75, 0x6D, 0x65, 0x00, 0x45, 0x3A, 0x5C, 0x6F, 0x6C, 0x65, 0x64, 0x73, 0x5C, 0x65, 0x78, 0x63, 0x65, 0x6C, 0x5C, 0x74, 0x65, 0x73, 0x74, 0x2E, 0x78, 0x6C, 0x73, 0x00, 0x00, 0x60, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0xA0, 0x58, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x78, 0x78, 0x78, 0x78, 0x78, 0x78, 0x78, 0x78, 0x78, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xB6, 0xF5, 0x56, 0x97, 0xAB, 0x4A, 0x6A, 0x40, 0xB6, 0xB1, 0x84, 0xE1, 0x8D, 0xD1, 0x76, 0xEE, 0xAC, 0x14, 0xD9, 0x7D, 0x90, 0x18, 0xDD, 0x11, 0xBA, 0xD5, 0x00, 0x0B, 0xDB, 0xCA, 0x27, 0x8E, 0xB6, 0xF5, 0x56, 0x97, 0xAB, 0x4A, 0x6A, 0x40, 0xB6, 0xB1, 0x84, 0xE1, 0x8D, 0xD1, 0x76, 0xEE, 0xAC, 0x14, 0xD9, 0x7D, 0x90, 0x18, 0xDD, 0x11, 0xBA, 0xD5, 0x00, 0x0B, 0xDB, 0xCA, 0x27, 0x8E, 0x00, 0x00, 0x00, 0x00], stream.absoluteSourceMonikerStream?.streamData)
            XCTAssertEqual(LONG(bitPattern: 0xFFFFFFFF), stream.clsidIndicator)
            XCTAssertEqual("00020820-0000-0000-C000-000000000046", stream.clsid?.description)
            XCTAssertEqual(0x00000000, stream.reservedDisplayName?.length)
            XCTAssertEqual(0xFFFFFFFF, stream.reserved2)
            XCTAssertEqual(0x26444EF0, stream.localUpdateTime?.dwLowDateTime)
            XCTAssertEqual(0x01C8AFC8, stream.localUpdateTime?.dwHighDateTime)
            XCTAssertEqual(0x2745B960, stream.localCheckUpdateTime?.dwLowDateTime)
            XCTAssertEqual(0x01C8AFC8, stream.localCheckUpdateTime?.dwHighDateTime)
            XCTAssertEqual(0x26444EF0, stream.remoteUpdateTime?.dwLowDateTime)
            XCTAssertEqual(0x01C8AFC8, stream.remoteUpdateTime?.dwHighDateTime)
            XCTAssertEqual(0, dataStream.remainingCount)
        }
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}