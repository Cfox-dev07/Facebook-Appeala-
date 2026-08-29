import XCTest
@testable import FacebookAppealAssistant

final class FacebookAppealAssistantTests: XCTestCase {
    func testDisabled() {
        let result = AppealFinder().analyze(text: "Your account has been disabled because it doesn't follow our Community Standards.")
        XCTAssertEqual(result.status, .disabled)
        XCTAssertGreaterThan(result.confidence, 0.6)
    }

    func testIntegrity() {
        let result = AppealFinder().analyze(text: "Your account was disabled due to account integrity.")
        XCTAssertEqual(result.status, .accountIntegrity)
    }

    func testIdentity() {
        let result = AppealFinder().analyze(text: "Confirm your identity to continue.")
        XCTAssertEqual(result.status, .identityVerification)
    }

    func testHacked() {
        let result = AppealFinder().analyze(text: "Your account may have been hacked.")
        XCTAssertEqual(result.status, .hacked)
    }

    func testUnknown() {
        let result = AppealFinder().analyze(text: "Hello Facebook")
        XCTAssertEqual(result.status, .unknown)
    }
}
