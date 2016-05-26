import XCTest
@testable import BSON2JSON
import BSON
import enum C7.JSON

class BSON2JSONTests: XCTestCase {

    func json(doc: Document) -> JSON {
        let bson = doc.makeBsonValue()
        let json = bson.toJSON()
        return json
    }
    
    func assert(_ doc: Document, _ expected: JSON, file: StaticString = #file, line: UInt = #line) {
        let gen = doc.makeBsonValue().toJSON()
        XCTAssertEqual(gen, expected, file: file, line: line)
    }
    
    func testNull() {
        let exp: JSON = .object(["hello": .null])
        assert(["hello": .null], exp)
    }
    
    func testDouble() {
        let exp: JSON = .object(["hello": .number(.double(-43.01))])
        assert(["hello": .double(-43.01)], exp)
    }
    
    func testInt() {
        let exp: JSON = .object(["hello": .number(.integer(42))])
        assert(["hello": .int64(42)], exp)
    }

	func testString() {
        let exp: JSON = .object(["hello": .string("world")])
        assert(["hello": "world"], exp)
    }
    
    func testBoolean() {
        let exp: JSON = .object(["hello": .boolean(false)])
        assert(["hello": .boolean(false)], exp)
    }
    
    func testArray() {
        let exp: JSON = .object(["hello": .array([.string("Earth"), .string("Mars")])])
        assert(["hello": ["Earth", "Mars"]], exp)
    }
    
    func testObject() {
        let exp: JSON = .object(["hello": .object(["home": .string("Earth"), "vacation": .string("Mars")])])
        assert(["hello": ["home": "Earth", "vacation": "Mars"]], exp)
    }
}
extension BSON2JSONTests {
	static var allTests: [(String, (BSON2JSONTests) -> () throws -> Void)] {
		return [
            ("testNull", testNull),
            ("testDouble", testDouble),
            ("testInt", testInt),
            ("testString", testString),
            ("testBoolean", testBoolean),
            ("testArray", testArray),
            ("testObject", testObject)
        ]
	}
}
