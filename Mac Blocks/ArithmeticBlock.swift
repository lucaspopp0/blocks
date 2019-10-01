//
//  ArithmeticBlock.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/9/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

class ArithmeticBlock: Block {
    
    override var blockDescription: String {
        get {
            return "Performs a simple arithmetic operation on two numbers, and outputs the result."
        }
    }
    
    let slot1: SlotInputComponent = SlotInputComponent(placeholder: "x", doubleClickData: NumberInputBlock().dictionaryValue(), allowedInputTypes: DataType.number)
    let operationPicker: PickerInputComponent = PickerInputComponent(options: "+", "-", "×", "÷")
    let slot2: SlotInputComponent = SlotInputComponent(placeholder: "y", doubleClickData: NumberInputBlock().dictionaryValue(), allowedInputTypes: DataType.number)
    
    required init(origin: CGPoint = CGPoint.zero) {
        super.init(origin: origin)
        
        outputType = DataType.number
        
        let l1: BlockLine = BlockLine()
        
        l1.addComponents(slot1, operationPicker, slot2)
        
        addLine(l1)
        
        fillColor = BlockColor.mathColor
        textColor = BlockColor.lightTextColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult override func evaluate() -> Any? {
        if slot1.input != nil && slot2.input != nil {
            let number1: Double? = DataType.valueAsDouble(value: slot1.input!.evaluate())
            let number2: Double? = DataType.valueAsDouble(value: slot2.input!.evaluate())
            
            if number1 != nil && number2 != nil {
                if operationPicker.currentValue == "+" {
                    return number1! + number2!
                } else if operationPicker.currentValue == "-" {
                    return number1! - number2!
                } else if operationPicker.currentValue == "×" {
                    return number1! * number2!
                } else if operationPicker.currentValue == "÷" {
                    return number1! / number2!
                }
            }
        } else {
            workspace?.console.error(message: "Need to specify two numbers to operate on.", sourceBlock: self)
        }
        
        return nil
    }
    
    override func duplicate() -> Block {
        let newBlock: ArithmeticBlock = ArithmeticBlock()
        
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
