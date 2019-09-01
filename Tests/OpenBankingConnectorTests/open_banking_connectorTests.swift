import XCTest
@testable import OpenBankingConnector

final class OpenBankingConnectorTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(OpenBankingConnector().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
