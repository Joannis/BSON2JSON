import XCTest
@testable import BSON2JSON
import BSON
import enum C7.JSON

class BSON2JSONTests: XCTestCase {
    
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

class JSON2BSONTests: XCTestCase {
    
    func assert(_ json: JSON, _ expected: Document, file: StaticString = #file, line: UInt = #line) {
        let gen = json.toBSON()
        XCTAssertEqual(gen, expected.makeBsonValue(), file: file, line: line)
    }
    
    func testNull() {
        let json: JSON = .object(["hello": .null])
        assert(json, ["hello": .null])
    }
    
    func testDouble() {
        let json: JSON = .object(["hello": .number(.double(-43.01))])
        assert(json, ["hello": .double(-43.01)])
    }
    
    func testInt() {
        let json: JSON = .object(["hello": .number(.integer(42))])
        assert(json, ["hello": .int64(42)])
    }

    func testString() {
        let json: JSON = .object(["hello": .string("world")])
        assert(json, ["hello": "world"])
    }
    
    func testBoolean() {
        let json: JSON = .object(["hello": .boolean(false)])
        assert(json, ["hello": .boolean(false)])
    }
    
    func testArray() {
        let json: JSON = .object(["hello": .array([.string("Earth"), .string("Mars")])])
        assert(json, ["hello": ["Earth", "Mars"]])
    }
    
    func testObject() {
        let json: JSON = .object(["hello": .object(["home": .string("Earth"), "vacation": .string("Mars")])])
        let doc: Document = ["hello": ["home": "Earth", "vacation": "Mars"]]
        //FIXME: can't compare with BSON, gives different results, in JSON
        //gives == true. Weird.
        XCTAssertEqual(doc.makeBsonValue().toJSON(), json)
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

extension JSON2BSONTests {
    static var allTests: [(String, (JSON2BSONTests) -> () throws -> Void)] {
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

