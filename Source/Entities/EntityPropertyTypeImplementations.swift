//
// Copyright © 2018 ObjectBox Ltd. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

/// Marks all supported scalar value types as such.
/// Used to provide 1 interface for e.g. `distinct`.
public protocol EntityScalarPropertyType {}

// MARK: Disambiguate Int/Int32/Int64

/// Annotates a type as being of Int64 length.
public protocol LongPropertyType: EntityScalarPropertyType, EntityPropertyTypeConvertible {}
extension Optional: LongPropertyType, EntityScalarPropertyType where Wrapped: LongPropertyType {}

/// Makes type as usable in Query.setParameter for Int64 values.
public protocol LongPropertyQueryType: LongPropertyType {
    var int64Value: Int64 { get }
}

/// Annotates a type as being of Int32 length.
public protocol IntegerPropertyType: EntityScalarPropertyType, EntityPropertyTypeConvertible {}
//extension Optional: IntegerPropertyType where Wrapped: IntegerPropertyType {}

/// Makes type as usable in Query.setParameter for Int32 values.
public protocol IntegerPropertyQueryType: IntegerPropertyType {
    var int64Value: Int64 { get } // Used for OBXQuery only
    var int32Value: Int32 { get } // Used for array pointer conversion
}

extension Int32: IntegerPropertyQueryType {
    public var int64Value: Int64 { return Int64(self) }
    public var int32Value: Int32 { return self }
}

extension Int64: LongPropertyQueryType {
    public var int64Value: Int64 { return self }
}

// Clarify how we want to treat `Int` in the core
#if (arch(i386) || arch(arm))
// 32bit
extension Int: IntegerPropertyQueryType {
    public var int64Value: Int64 { return Int64(self)}
    public var int32Value: Int32 { return Int32(self) }
}
#else
// 64bit
extension Int: LongPropertyQueryType {
    public var int64Value: Int64 { return Int64(self) }
}
#endif

// MARK: Enabling String/String? shared behavior

public protocol StringPropertyType: EntityPropertyTypeConvertible {}
extension String: StringPropertyType {}
extension Optional: StringPropertyType where Wrapped == String {}

// MARK: Enabling Data/Data? shared behavior

public protocol DataPropertyType: EntityPropertyTypeConvertible {}
extension Data: DataPropertyType {}
extension Optional: DataPropertyType where Wrapped == Data {}

// MARK: - Entity Property Types

extension Bool: EntityPropertyTypeConvertible, EntityScalarPropertyType {
    public static var entityPropertyType: EntityPropertyType { return .bool }
}

public typealias Byte = UInt8

extension EntityId: EntityPropertyTypeConvertible, EntityScalarPropertyType {
    public static var entityPropertyType: EntityPropertyType { return .long }
}

extension Int8: EntityPropertyTypeConvertible, EntityScalarPropertyType {
    public static var entityPropertyType: EntityPropertyType { return .byte }
}

extension Int16: EntityPropertyTypeConvertible, EntityScalarPropertyType {
    public static var entityPropertyType: EntityPropertyType { return .short }
}

extension Int32: EntityPropertyTypeConvertible, EntityScalarPropertyType {
    public static var entityPropertyType: EntityPropertyType { return .int }
}

extension Int64: EntityPropertyTypeConvertible, EntityScalarPropertyType {
    public static var entityPropertyType: EntityPropertyType { return .long }
}

// TODO: conditionally compile to .int on 32bit platforms
extension Int: EntityPropertyTypeConvertible, EntityScalarPropertyType {
    public static var entityPropertyType: EntityPropertyType { return .long }
}

extension Float: EntityPropertyTypeConvertible, EntityScalarPropertyType {
    public static var entityPropertyType: EntityPropertyType { return .float }
}

extension Double: EntityPropertyTypeConvertible, EntityScalarPropertyType {
    public static var entityPropertyType: EntityPropertyType { return .double }
}

extension String: EntityPropertyTypeConvertible {
    public static var entityPropertyType: EntityPropertyType { return .string }
}

extension Date: EntityPropertyTypeConvertible, EntityScalarPropertyType {
    public static var entityPropertyType: EntityPropertyType { return .date }
}

extension Data: EntityPropertyTypeConvertible {
    public static var entityPropertyType: EntityPropertyType { return .byteVector }
}

extension Optional: EntityPropertyTypeConvertible where Wrapped: EntityPropertyTypeConvertible {
    public static var entityPropertyType: EntityPropertyType { return Wrapped.entityPropertyType }
}

extension Id: EntityPropertyTypeConvertible {
    public static var entityPropertyType: EntityPropertyType {
        return .long
    }
}
