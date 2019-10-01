//
//  EqualityTestBlock.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/7/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

// Compares two values
class EqualityTestBlock: Block {
    
    override var blockDescription: String {
        get {
            return "Outputs true if the comparison is accurate."
        }
    }
    
    let leftSlot: SlotInputComponent = SlotInputComponent()
    let rightSlot: SlotInputComponent = SlotInputComponent()
    let comparisonPicker: PickerInputComponent = PickerInputComponent(options: "=", "≠", "<", ">", "≤", "≥")
    
    required init(origin: CGPoint = CGPoint.zero) {
        super.init(origin: origin)
        
        outputType = DataType.boolean
        
        let l1: BlockLine = BlockLine()
        
        l1.addComponents(leftSlot, comparisonPicker, rightSlot)
        
        addLine(l1)
        
        fillColor = BlockColor.logicColor
        textColor = BlockColor.lightTextColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult override func evaluate() -> Any? {
        if leftSlot.input != nil && rightSlot.input != nil {
            var typeToCheck: DataType = DataType.none
            
            let leftEvaluated: Any? = leftSlot.input!.evaluate()
            let rightEvaluated: Any? = rightSlot.input!.evaluate()
            
            if leftSlot.input!.outputType == DataType.any || rightSlot.input!.outputType == DataType.any {
                if leftSlot.input!.outputType == rightSlot.input!.outputType {
                    var leftType: DataType? = nil
                    var rightType: DataType? = nil
                    
                    if DataType.valueIsString(value: leftEvaluated) {
                        leftType = DataType.string
                    } else if DataType.valueIsNumber(value: leftEvaluated) {
                        leftType = DataType.number
                    } else if DataType.valueIsBoolean(value: leftEvaluated) {
                        leftType = DataType.boolean
                    }
                    
                    if DataType.valueIsString(value: rightEvaluated) {
                        rightType = DataType.string
                    } else if DataType.valueIsNumber(value: rightEvaluated) {
                        rightType = DataType.number
                    } else if DataType.valueIsBoolean(value: rightEvaluated) {
                        rightType = DataType.boolean
                    }
                    
                    if leftType != nil && rightType != nil && leftType! == rightType! {
                        typeToCheck = leftType!
                    } else {
                        return false
                    }
                } else if leftSlot.input!.outputType == DataType.any {
                    if rightSlot.input!.outputType == DataType.string {
                        if DataType.valueIsString(value: leftEvaluated) {
                            typeToCheck = DataType.string
                        } else {
                            workspace?.console.error(message: "Cannot compare a(n) \(leftSlot.input!.outputType) to a string.", sourceBlock: self)
                            return nil
                        }
                    } else if rightSlot.input!.outputType == DataType.number {
                        if DataType.valueIsNumber(value: leftEvaluated) {
                            typeToCheck = DataType.number
                        } else {
                            workspace?.console.error(message: "Cannot compare a(n) \(leftSlot.input!.outputType) to a number.", sourceBlock: self)
                            return nil
                        }
                    } else if rightSlot.input!.outputType == DataType.boolean {
                        if DataType.valueIsBoolean(value: leftEvaluated) {
                            typeToCheck = DataType.boolean
                        } else {
                            workspace?.console.error(message: "Cannot compare a(n) \(leftSlot.input!.outputType) to a boolean.", sourceBlock: self)
                            return nil
                        }
                    }
                } else if rightSlot.input!.outputType == DataType.any {
                    if leftSlot.input!.outputType == DataType.string {
                        if DataType.valueIsString(value: rightEvaluated) {
                            typeToCheck = DataType.string
                        } else {
                            workspace?.console.error(message: "Cannot compare a string to a(n) \(rightSlot.input!.outputType).", sourceBlock: self)
                            return nil
                        }
                    } else if leftSlot.input!.outputType == DataType.number {
                        if DataType.valueIsNumber(value: rightEvaluated) {
                            typeToCheck = DataType.number
                        } else {
                            workspace?.console.error(message: "Cannot compare a number to a(n) \(rightSlot.input!.outputType).", sourceBlock: self)
                            return nil
                        }
                    } else if leftSlot.input!.outputType == DataType.boolean {
                        if DataType.valueIsBoolean(value: rightEvaluated) {
                            typeToCheck = DataType.boolean
                        } else {
                            workspace?.console.error(message: "Cannot compare a boolean to a(n) \(rightSlot.input!.outputType).", sourceBlock: self)
                            return nil
                        }
                    }
                }
            } else if leftSlot.input!.outputType == rightSlot.input!.outputType {
                typeToCheck = leftSlot.input!.outputType
            } else {
                return false
            }
            
            if typeToCheck == DataType.boolean {
                let leftValue: Bool? = DataType.valueAsBoolean(value: leftEvaluated)
                let rightValue: Bool? = DataType.valueAsBoolean(value: rightEvaluated)
                
                if leftValue != nil && rightValue != nil {
                    if comparisonPicker.currentValue == "=" {
                        return leftValue! == rightValue!
                    } else if comparisonPicker.currentValue == "≠" {
                        return leftValue! != rightValue!
                    }
                }
            } else if typeToCheck == DataType.number {
                let leftValue: Double? = DataType.valueAsDouble(value: leftEvaluated)
                let rightValue: Double? = DataType.valueAsDouble(value: rightEvaluated)
                
                if leftValue != nil && rightValue != nil {
                    if comparisonPicker.currentValue == "=" {
                        return leftValue! == rightValue!
                    } else if comparisonPicker.currentValue == "≠" {
                        return leftValue! != rightValue!
                    } else if comparisonPicker.currentValue == "<" {
                        return leftValue! < rightValue!
                    } else if comparisonPicker.currentValue == ">" {
                        return leftValue! > rightValue!
                    } else if comparisonPicker.currentValue == "≤" {
                        return leftValue! <= rightValue!
                    } else if comparisonPicker.currentValue == "≥" {
                        return leftValue! >= rightValue!
                    }
                }
            } else if typeToCheck == DataType.string {
                let leftValue: String? = DataType.valueAsString(value: leftEvaluated)
                let rightValue: String? = DataType.valueAsString(value: rightEvaluated)
                
                if leftValue != nil && rightValue != nil {
                    if comparisonPicker.currentValue == "=" {
                        return leftValue! == rightValue!
                    } else if comparisonPicker.currentValue == "≠" {
                        return leftValue! != rightValue!
                    }
                }
            }
        } else {
            workspace?.console.error(message: "Required slot left empty.", sourceBlock: self)
        }
        
        return nil
    }
    
    override func duplicate() -> Block {
        let newBlock: EqualityTestBlock = EqualityTestBlock()
        
        newBlock.comparisonPicker.picker.selectItem(at: comparisonPicker.picker.indexOfSelectedItem)
        
        return newBlock
    }
    
    override func applyTypeRelatedProperties(_ data: NSDictionary) {
        if DataManager.dictionary(dictionary: data, hasValueForKey: "comparison") {
            comparisonPicker.picker.selectItem(withTitle: data.value(forKey: "comparison") as! String)
        }
    }
    
    override func typeRelatedProperties() -> NSMutableDictionary {
        let properties: NSMutableDictionary = super.typeRelatedProperties()
        
        properties.setValue(comparisonPicker.currentValue, forKey: "comparison")
        
        return properties
    }
    
}
