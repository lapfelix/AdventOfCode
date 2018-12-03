import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(____Inventory_Management_SystemTests.allTests),
    ]
}
#endif