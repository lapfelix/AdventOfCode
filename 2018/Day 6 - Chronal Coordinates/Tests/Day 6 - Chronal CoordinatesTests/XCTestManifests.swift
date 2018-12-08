import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(Day_6___Chronal_CoordinatesTests.allTests),
    ]
}
#endif