import enum C7.JSON
import BSON
import Foundation

extension JSON {
    
    /// This is a "best-effort" conversion, this is *not* Extended JSON spec,
    /// only an approximation of what makes sense to me.
    /// See https://docs.mongodb.com/v3.0/reference/mongodb-extended-json/
    /// for more details, although this code doesn't exactly follow it fully.
    /// Basically we try to convert the types that are mirrored in JSON natively,
    /// the rest we wrap in a separate JSON dictionary (Extended-JSON-style)
    public func toBSON() -> BSON.Value {
        switch self {
        case .array(let items):
            return .array(Document(array: items.map { $0.toBSON() }))
        case .boolean(let bool):
            return .boolean(bool)
        case .null:
            return .null
        case .number(let number):
            switch number{
            case .double(let dbl):
                return .double(dbl)
            case .integer(let int):
                return .int64(Int64(int))
            case .unsignedInteger(let uint):
                return .int64(Int64(uint)) //err...
            }
        case .object(let items):
            return .document(Document(dictionaryElements: items.map { ($0, $1.toBSON()) }))
        case .string(let string):
            return .string(string)
        }
    }
}
