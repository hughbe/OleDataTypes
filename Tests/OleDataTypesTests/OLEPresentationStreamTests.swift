import XCTest
import DataStream
import WindowsDataTypes
@testable import OleDataTypes

final class OLEPresentationStreamTests: XCTestCase {
    func testExample() throws {
        do {
            /// [MS-OLEDS] 3.3 OLEPresentationStream Structure
            /// This section describes the binary layout of the OLEPresentationStream (section 2.3.4)structure.
            let buffer: [UInt8] = [
                0xFF, 0xFF, 0xFF, 0xFF, 0x08, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00,
                0xFF, 0xFF, 0xFF, 0xFF, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x91, 0x74, 0x00, 0x00,
                0xA7, 0x42, 0x00, 0x00, 0x18, 0x00, 0x00, 0x00, 0x28, 0x00, 0x00, 0x00, 0x68, 0x04, 0x00, 0x00,
                0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
                0x4E, 0x41, 0x4E, 0x49, 0x01, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0x03, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0x20, 0x00, 0x00, 0x00,
                0x95, 0x74, 0x00, 0x00, 0xAA, 0x42, 0x00, 0x00, 0x16, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00,
                0x18, 0x00, 0x00, 0x00,
            ]
            var dataStream = DataStream(buffer)
            let stream = try OLEPresentationStream(dataStream: &dataStream)
            XCTAssertEqual(0xFFFFFFFF, stream.ansiClipboardFormat.markerOrLength)
            guard case let .standard(format1) = stream.ansiClipboardFormat.formatOrAnsiString else {
                XCTAssertTrue(false)
                return
            }
            XCTAssertEqual(CF_DIB, format1)
            XCTAssertEqual(0x00000004, stream.targetDeviceSize)
            XCTAssertEqual(0x00000001, stream.aspect)
            XCTAssertEqual(0xFFFFFFFF, stream.lindex)
            XCTAssertEqual(0x00000002, stream.advf)
            XCTAssertEqual(0x00000000, stream.reserved1)
            XCTAssertEqual(0x00007491, stream.width)
            XCTAssertEqual(0x000042A7, stream.height)
            XCTAssertEqual(0x00000018, stream.size)
            XCTAssertEqual([0x28, 0x00, 0x00, 0x00, 0x68, 0x04, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF], stream.data)
            XCTAssertEqual(0x494E414E, stream.tocSignature)
            XCTAssertEqual(0x00000001, stream.tocCount)
            
            let entry = stream.tocEntry[0]
            XCTAssertEqual(0xFFFFFFFF, entry.ansiClipboardFormat.markerOrLength)
            guard case let .standard(format2) = entry.ansiClipboardFormat.formatOrAnsiString else {
                XCTAssertTrue(false)
                return
            }
            XCTAssertEqual(CF_METAFILEPICT, format2)
            XCTAssertEqual(0x00000000, entry.targetDeviceSize)
            XCTAssertEqual(0x00000001, entry.aspect)
            XCTAssertEqual(0xFFFFFFFF, entry.lindex)
            XCTAssertEqual(0x00000020, entry.tymed)
            XCTAssertEqual(0x00007495, entry.reserved1[0])
            XCTAssertEqual(0x000042AA, entry.reserved1[1])
            XCTAssertEqual(0x00000016, entry.reserved1[2])
            XCTAssertEqual(0x00000002, entry.advf)
            XCTAssertEqual(0x00000018, entry.reserved2)
            XCTAssertNil(entry.targetDevice)
            XCTAssertEqual(0, dataStream.remainingCount)
            XCTAssertEqual(0, dataStream.remainingCount)
        }
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
