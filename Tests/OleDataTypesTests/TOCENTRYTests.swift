import XCTest
import DataStream
import WindowsDataTypes
@testable import OleDataTypes

final class TOCEntryTests: XCTestCase {
    func testExample() throws {
        do {
            /// [MS-OLEDS] 3.4 TOCENTRY Structure
            /// This section describes the binary layout of the TOCENTRY (section 2.3.5) structure. 
            let buffer: [UInt8] = [
                0xFF, 0xFF, 0xFF, 0xFF, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00,
                0xFF, 0xFF, 0xFF, 0xFF, 0x20, 0x00, 0x00, 0x00, 0x95, 0x74, 0x00, 0x00, 0xAA, 0x42, 0x00, 0x00,
                0x16, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x00
            ]
            var dataStream = DataStream(buffer)
            let entry = try TOCENTRY(dataStream: &dataStream)
            XCTAssertEqual(0xFFFFFFFF, entry.ansiClipboardFormat.markerOrLength)
            guard case let .standard(format) = entry.ansiClipboardFormat.formatOrAnsiString else {
                XCTAssertTrue(false)
                return
            }
            XCTAssertEqual(CF_METAFILEPICT, format)
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
        }
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
