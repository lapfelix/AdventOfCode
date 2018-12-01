import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(____Chronal_CalibrationTests.allTests),
    ]
}
#endif