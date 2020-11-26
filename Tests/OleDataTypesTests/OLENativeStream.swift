import XCTest
import DataStream
import WindowsDataTypes
@testable import OleDataTypes

final class OleNativeStreamTests: XCTestCase {
    func testExample() throws {
        do {
            /// [MS-OLEDS] 3.5 OLENativeStream Structure
            /// This section describes the binary layout of the OLENativeStream (section 2.3.6) structure.
            let buffer: [UInt8] = [
                0x03, 0x00, 0x00, 0x00, 0x01, 0x02, 0x03
            ]
            var dataStream = DataStream(buffer)
            let entry = try OLENativeStream(dataStream: &dataStream, count: dataStream.count)
            XCTAssertEqual(0x00000003, entry.nativeDataSize)
            XCTAssertEqual([0x01, 0x02, 0x03], entry.nativeData)
            XCTAssertEqual(0, dataStream.remainingCount)
        }
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
