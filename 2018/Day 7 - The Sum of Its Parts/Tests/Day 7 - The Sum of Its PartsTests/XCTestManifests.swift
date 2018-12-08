import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(Day_7___The_Sum_of_Its_PartsTests.allTests),
    ]
}
#endif