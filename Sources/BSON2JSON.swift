import enum C7.JSON
import BSON
import Foundation

extension BSON.Value {
    
    /// This is a "best-effort" conversion, this is *not* Extended JSON spec,
    /// only an approximation of what makes sense to me.
    /// See https://docs.mongodb.com/v3.0/reference/mongodb-extended-json/
    /// for more details, although this code doesn't exactly follow it fully.
    /// Basically we try to convert the types that are mirrored in JSON natively,
    /// the rest we wrap in a separate JSON dictionary (Extended-JSON-style)
    public func toJSON() -> JSON {
        switch self {
        case .array(let arrayDoc):
            return .array(arrayDoc.arrayValue.map { $0.toJSON() })
        case .binary(let subtype, let data):
            return binaryToJSON(subtype, data)
        case .boolean(let bool):
            return .boolean(bool)
        case .dateTime(let date):
            return date.toJSON()
        case .document(let doc):
            return docToJSON(doc)
        case .double(let dbl):
            return .number(.double(dbl))
        case .int32(let int):
            return .number(.integer(Int(int)))
        case .int64(let int):
            return .number(.integer(Int(int)))
        case .javascriptCode(let js):
            return .string(js)
        case .javascriptCodeWithScope(let code, let scope):
            return jsToJSON(code, scope)
        case .maxKey:
            return .object(["$maxKey": .number(.integer(1))])
        case .minKey:
            return .object(["$minKey": .number(.integer(1))])
        case .nothing, .null:
            return .null
        case .objectId(let oid):
            return .object(["$oid": .string(oid.hexString)])
        case .regularExpression(let pattern, let options):
            return .object(["$regex": .string(pattern), "$options": .string(options)])
        case .string(let str):
            return .string(str)
        case .timestamp(let timestamp):
            return .string(String(timestamp))
        }
    }
}

// TODO: once this (https://github.com/open-swift/C7/pull/41) is merged, remove it from here
extension JSON.Number: Equatable { }
public func ==(lhs: JSON.Number, rhs: JSON.Number) -> Bool {
    switch (lhs, rhs) {
    case (.integer(let l), .integer(let r)): return l == r
    case (.unsignedInteger(let l), .unsignedInteger(let r)): return l == r
    case (.double(let l), .double(let r)): return l == r
    default: return false
    }
}

extension JSON: Equatable { }
public func ==(lhs: JSON, rhs: JSON) -> Bool {
    switch (lhs, rhs) {
    case (.null, .null): return true
    case (.boolean(let l), .boolean(let r)): return l == r
    case (.string(let l), .string(let r)): return l == r
    case (.number(let l), .number(let r)): return l == r
    case (.array(let l), .array(let r)): return l == r
    case (.object(let l), .object(let r)): return l == r
    default: return false
    }
}

//MARK: Document
extension String {
    func dropZeroTerminator() -> String {
        guard let last = self.characters.last where last == "\0" else { return self }
        return String(self.characters.dropLast())
    }
}

func docToJSON(_ doc: Document) -> JSON {
    var out: [String: JSON] = [:]
    for (key, value) in doc {
        out[key.dropZeroTerminator()] = value.makeBsonValue().toJSON()
    }
    return .object(out)
}

//MARK: Javascript
func jsToJSON(_ code: String, _ scope: Document) -> JSON {
    return .object(["code": .string(code), "scope": scope.makeBsonValue().toJSON()])
}

//MARK: binaryData
func binaryToJSON(_ subtype: BinarySubtype, _ data: [UInt8]) -> JSON {
    let base64 = NSData(bytes: data, length: data.count).base64EncodedString([])
    let binType = String(format:"%2X", subtype.rawValue)
    return .object(["$binary": .string(base64), "$type": .string(binType)])
}

//MARK: dateTime

private var dateFormatter: NSDateFormatter = {
    let dateFormatter = NSDateFormatter()
    let enUSPosixLocale = NSLocale(localeIdentifier: "en_US_POSIX")
    dateFormatter.locale = enUSPosixLocale
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    return dateFormatter
}()

extension NSDate {
    func toJSON() -> JSON {
        let iso8601String = dateFormatter.string(from: self)
        return .object(["$date": .string(iso8601String)])
    }
}
