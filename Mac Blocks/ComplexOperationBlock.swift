//
//  ComplexOperationBlock.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/9/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

class ComplexOperationBlock: Block {
    
    override var blockDescription: String {
        get {
            return "Performs one of the functions from the dropdown on a number, and outputs the result."
        }
    }
    
    let operationPicker: PickerInputComponent = PickerInputComponent(options: "square root", "absolute value", "log₁₀", "ln", "eˣ", "10ˣ")
    let slot: SlotInputComponent = SlotInputComponent(doubleClickData: NumberInputBlock().dictionaryValue(), allowedInputTypes: DataType.number)
    
    required init(origin: CGPoint = CGPoint.zero) {
        super.init(origin: origin)
        
        outputType = DataType.number
        
        let l1: BlockLine = BlockLine()
        
        l1.addComponents(operationPicker, TextComponent(text: "of"), slot)
        
        addLine(l1)
        
        fillColor = BlockColor.mathColor
        textColor = BlockColor.lightTextColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult override func evaluate() -> Any? {
        if slot.input != nil {
            let inputValue: Double? = DataType.valueAsDouble(value: slot.input!.evaluate())
            
            if inputValue != nil {
                if operationPicker.currentValue == "square root" {
                    return sqrt(inputValue!)
                } else if operationPicker.currentValue == "absolute value" {
                    return abs(inputValue!)
                } else if operationPicker.currentValue == "log₁₀" {
                    return log10(inputValue!)
                } else if operationPicker.currentValue == "ln" {
                    return log10(inputValue!) / log10(M_E)
                } else if operationPicker.currentValue == "eˣ" {
                    return pow(M_E, inputValue!)
                } else if operationPicker.currentValue == "10ˣ" {
                    return pow(10, inputValue!)
                }
            }
        } else {
            workspace?.console.error(message: "Didn't specify a number to perform the indicated function on.", sourceBlock: self)
        }
        
        return nil
    }
    
    override func duplicate() -> Block {
        let newBlock: ComplexOperationBlock = ComplexOperationBlock()
        
        newBlock.operationPicker.picker.selectItem(at: operationPicker.picker.indexOfSelectedItem)
        
        return newBlock
    }
    
    override func applyTypeRelatedProperties(_ data: NSDictionary) {
        if DataManager.dictionary(dictionary: data, hasValueForKey: "operation") {
            operationPicker.picker.selectItem(withTitle: data.value(forKey: "operation") as! String)
        }
    }
    
    override func typeRelatedProperties() -> NSMutableDictionary {
        let properties: NSMutableDictionary = super.typeRelatedProperties()
        
        properties.setValue(operationPicker.currentValue, forKey: "operation")
        
        return properties
    }
    
}
