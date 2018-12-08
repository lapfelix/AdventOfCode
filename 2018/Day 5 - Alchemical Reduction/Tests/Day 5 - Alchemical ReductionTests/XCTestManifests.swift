import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(Day_5___Alchemical_ReductionTests.allTests),
    ]
}
#endif