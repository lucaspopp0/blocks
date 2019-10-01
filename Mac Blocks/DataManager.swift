//
//  DataManager.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/6/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

// Used to describe data types in blocks
enum DataType {
    
    case any
    
    static func valueIs(value: Any?, type: DataType) -> Bool {
        switch type {
        case DataType.string:
            return valueIsString(value: value)
        case DataType.number:
            return valueIsNumber(value: value)
        case DataType.boolean:
            return valueIsBoolean(value: value)
        case DataType.type:
            return valueIsType(value: value)
        case DataType.object:
            return valueIsObject(value: value)
        case DataType.list:
            return valueIsList(value: value)
        case DataType.windowController:
            return valueIsWindowController(value: value)
        case DataType.color:
            return valueIsColor(value: value)
        case DataType.any:
            return value != nil
        case DataType.none:
            return value == nil
        }
    }
    
    case string
    
    // Checks if Any? (usually returned by block evaluation) is a string
    static func valueIsString(value: Any?) -> Bool {
        return (value != nil && value! is String)
    }
    
    // Converts Any? (usually returned by block evaluation) into a string
    static func valueAsString(value: Any?) -> String? {
        return value as? String
    }
    
    case number
    
    static func valueIsNumber(value: Any?) -> Bool {
        return (value != nil && (value! is Double || value! is Int))
    }
    
    static func valueAsDouble(value: Any?) -> Double? {
        if let dv: Double = value as? Double {
            return dv
        } else if let iv: Int = value as? Int {
            return Double(exactly: iv)
        }
        
        return nil
    }
    
    static func valueIsInt(value: Any?) -> Bool {
        if value != nil {
            if value! is Int {
                return true
            } else if value! is Double {
                let doubleValue: Double = value as! Double
                
                if doubleValue == round(doubleValue) {
                    return true
                }
            }
        }
        
        return false
    }
    
    static func valueAsInt(value: Any?) -> Int? {
        if value != nil {
            if value! is Int {
                return value! as? Int
            } else if value! is Double {
                let doubleValue: Double = value as! Double
                
                if doubleValue == round(doubleValue) {
                    return Int(doubleValue)
                }
            }
        }
        
        return nil
    }
    
    case boolean
    
    static func valueIsBoolean(value: Any?) -> Bool {
        return (value != nil && value! is Bool)
    }
    
    static func valueAsBoolean(value: Any?) -> Bool? {
        return value as? Bool
    }
    
    case type
    
    static func valueIsType(value: Any?) -> Bool {
        return (value != nil && value! is DataType)
    }
    
    static func valueAsType(value: Any?) -> DataType? {
        return value as? DataType
    }
    
    case object
    
    static func valueIsObject(value: Any?) -> Bool {
        return (value != nil && value! is DataObject)
    }
    
    static func valueAsObject(value: Any?) -> DataObject? {
        return value as? DataObject
    }
    
    case list
    
    static func valueIsList(value: Any?) -> Bool {
        return (value != nil && value! is DataList)
    }
    
    static func valueAsList(value: Any?) -> DataList? {
        return value as? DataList
    }
    
    case windowController
    
    static func valueIsWindowController(value: Any?) -> Bool {
        return (value != nil && value! is NSWindowController)
    }
    
    static func valueAsWindowController(value: Any?) -> NSWindowController? {
        return value as? NSWindowController
    }
    
    case color
    
    static func valueIsColor(value: Any?) -> Bool {
        return value is NSColor
    }
    
    static func valueAsColor(value: Any?) -> NSColor? {
        return value as? NSColor
    }
    
    case none
    
    // Returns an array of all possible data types
    static func all() -> [DataType] {
        return [DataType.string, DataType.number, DataType.boolean, DataType.type, DataType.object, DataType.list, DataType.windowController, DataType.color]
    }
    
}

// A container for an object to be used and manipulated by "object" blocks
class DataObject: CustomStringConvertible {
    
    // The actual object
    var object: [String: Any] = [:]
    
    // The description of the object for printing in the cnosole
    var description: String {
        get {
            var output: [String] = ["Object"]
            
            for key: String in object.keys {
                output.append(" \(key): \(object[key]!)")
            }
            
            return "\(output.joined(separator: "\n"))"
        }
    }
    
    init(object: [String: Any] = [String: Any]()) {
        self.object = object
    }
    
}

// A container for a list to be used and manipulated by "list" blocks
class DataList: CustomStringConvertible {
    
    // The actual list
    var items: [Any] = []
    
    // The description of the list for printing in the cnosole
    var description: String {
        get {
            var output: [String] = ["List"]
            
            for i in 0 ..< items.count {
                output.append(" \(i): \(items[i])")
            }
            
            return "[\(output.joined(separator: "\n"))]"
        }
    }
    
    init(items: [Any] = []) {
        self.items = items
    }
    
}

class DataManager {
    
    static let documentController: NSDocumentController = NSDocumentController()
    
    // Checks if a dictionary has values for a set of keys
    static func dictionary(dictionary: NSDictionary, hasValuesForKeys keys: String...) -> Bool {
        for key: String in keys {
            if dictionary.object(forKey: key) == nil {
                return false
            }
        }
        
        return true
    }
    
    // Checks if a dictionary has values for a key
    static func dictionary(dictionary: NSDictionary, hasValueForKey key: String) -> Bool {
        if dictionary.object(forKey: key) != nil {
            return true
        }
        
        return false
    }
    
    // Converts two 'Any' values to DataObjects, and checks if they're equal
    static func objectsEqual(_ left: Any, _ right: Any) -> Bool {
        if DataType.valueIsObject(value: left) && DataType.valueIsObject(value: right) {
            let leftObject: DataObject = DataType.valueAsObject(value: left)!
            let rightObject: DataObject = DataType.valueAsObject(value: right)!
            
            if leftObject.object.keys.count == rightObject.object.keys.count {
                var leftKeys: [String] = []
                var rightKeys: [String] = []
                
                for key: String in leftObject.object.keys {
                    leftKeys.append(key)
                }
                
                for key: String in rightObject.object.keys {
                    rightKeys.append(key)
                }
                
                for i in 0 ..< leftKeys.count {
                    let equal: Bool = DataManager.objectsEqual(leftObject.object[leftKeys[i]]!, rightObject.object[rightKeys[i]]!)
                    
                    if !equal {
                        return false
                    }
                }
                
                return true
            }
        } else if DataType.valueIsList(value: left) && DataType.valueIsList(value: right) {
            let leftList: DataList = DataType.valueAsList(value: left)!
            let rightList: DataList = DataType.valueAsList(value: right)!
            
            if leftList.items.count == rightList.items.count {
                for i in 0 ..< leftList.items.count {
                    let equal: Bool = DataManager.objectsEqual(leftList.items[i], rightList.items[i])
                    
                    if !equal {
                        return false
                    }
                }
                
                return true
            }
        } else if DataType.valueIsType(value: left) && DataType.valueIsType(value: right) {
            return DataType.valueAsType(value: left)! == DataType.valueAsType(value: right)!
        } else if DataType.valueIsString(value: left) && DataType.valueIsString(value: right) {
            return DataType.valueAsString(value: left)! == DataType.valueAsString(value: right)!
        } else if DataType.valueIsNumber(value: left) && DataType.valueIsNumber(value: right) {
            return DataType.valueAsDouble(value: left)! == DataType.valueAsDouble(value: right)!
        } else if DataType.valueIsBoolean(value: left) && DataType.valueIsBoolean(value: right) {
            return DataType.valueAsBoolean(value: left)! == DataType.valueAsBoolean(value: right)!
        }
        
        // TODO: Add support for new DataTypes
        
        return false
    }
    
}
