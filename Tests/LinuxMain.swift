import XCTest
@testable import BSON2JSONTestSuite

XCTMain([
	 testCase(BSON2JSONTests.allTests),
	 testCase(JSON2BSONTests.allTests),
])
