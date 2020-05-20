import Foundation

extension String: JSONCodable {
  public init(jsonValue value: JSONValue) throws {
    switch value {
    case let string as String:
        self = string
    case let int as Int:
        self = String(int)
    default:
        throw JSONDecodingError.couldNotConvert(value: value, to: String.self)
    }
  }

  public var jsonValue: JSONValue {
    return self
  }
}

extension Int: JSONCodable {
  public init(jsonValue value: JSONValue) throws {
    guard let number = value as? NSNumber else {
      throw JSONDecodingError.couldNotConvert(value: value, to: Int.self)
    }
    self = number.intValue
  }

  public var jsonValue: JSONValue {
    return self
  }
}

extension Float: JSONCodable {
  public init(jsonValue value: JSONValue) throws {
    guard let number = value as? NSNumber else {
      throw JSONDecodingError.couldNotConvert(value: value, to: Float.self)
    }
    self = number.floatValue
  }

  public var jsonValue: JSONValue {
    return self
  }
}

extension Double: JSONCodable {
  public init(jsonValue value: JSONValue) throws {
    guard let number = value as? NSNumber else {
      throw JSONDecodingError.couldNotConvert(value: value, to: Double.self)
    }
    self = number.doubleValue
  }

  public var jsonValue: JSONValue {
    return self
  }
}

extension Bool: JSONCodable {
  public init(jsonValue value: JSONValue) throws {
    guard let bool = value as? Bool else {
        throw JSONDecodingError.couldNotConvert(value: value, to: Bool.self)
    }
    self = bool
  }

  public var jsonValue: JSONValue {
    return self
  }
}

extension RawRepresentable where RawValue: JSONDecodable {
  public init(jsonValue value: JSONValue) throws {
    let rawValue = try RawValue(jsonValue: value)
    if let tempSelf = Self(rawValue: rawValue) {
      self = tempSelf
    } else {
      throw JSONDecodingError.couldNotConvert(value: value, to: Self.self)
    }
  }
}

extension RawRepresentable where RawValue: JSONEncodable {
  public var jsonValue: JSONValue {
    return rawValue.jsonValue
  }
}

extension Optional where Wrapped: JSONDecodable {
  public init(jsonValue value: JSONValue) throws {
    if value is NSNull {
      self = .none
    } else {
      self = .some(try Wrapped(jsonValue: value))
    }
  }
}

extension Optional where Wrapped: JSONEncodable {
  public var jsonValue: JSONValue {
    switch self {
      case .none:
        return NSNull()
      case .some(let wrapped):
        return wrapped.jsonValue
    }
  }
}

extension Dictionary where Key == String, Value == JSONEncodable? {
  public var jsonValue: JSONValue {
    return jsonObject
  }
  
  public var jsonObject: JSONObject {
    var jsonObject = JSONObject(minimumCapacity: count)
    for (key, value) in self {
      jsonObject[key] = value
    }
    return jsonObject
  }
}

extension Array where Element == JSONEncodable? {
  public var jsonValue: JSONValue {
    return map() { element -> (JSONValue?) in
      return element
    }
  }
}

// Example custom scalar
extension URL: JSONCodable {
  public init(jsonValue value: JSONValue) throws {
    guard let string = value as? String else {
      throw JSONDecodingError.couldNotConvert(value: value, to: URL.self)
    }

    if let url = URL(string: string) {
        self = url
    } else {
        throw JSONDecodingError.couldNotConvert(value: value, to: URL.self)
    }
  }

  public var jsonValue: JSONValue {
    return self.absoluteString
  }
}
