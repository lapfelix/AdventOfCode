import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(____No_Matter_How_You_Slice_ItTests.allTests),
    ]
}
#endif