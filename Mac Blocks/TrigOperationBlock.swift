//
//  TrigOperationBlock.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/9/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

class TrigOperationBlock: Block {
    
    override var blockDescription: String {
        get {
            return "Performs a trigonometric  operation on a number, and outputs the result."
        }
    }
    
    let operationPicker: PickerInputComponent = PickerInputComponent(options: "sin", "cos", "tan", "csc", "sec", "cot", "sin\u{207B}\u{00B9}", "cos\u{207B}\u{00B9}", "tan\u{207B}\u{00B9}", "csc\u{207B}\u{00B9}", "sec\u{207B}\u{00B9}", "cot\u{207B}\u{00B9}")
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
                if operationPicker.currentValue == "sin" {
                    return sin(inputValue!)
                } else if operationPicker.currentValue == "cos" {
                    return cos(inputValue!)
                } else if operationPicker.currentValue == "tan" {
                    return tan(inputValue!)
                } else if operationPicker.currentValue == "csc" {
                    return 1 / sin(inputValue!)
                } else if operationPicker.currentValue == "sec" {
                    return 1 / cos(inputValue!)
                } else if operationPicker.currentValue == "cot" {
                    return 1 / tan(inputValue!)
                } else if operationPicker.currentValue == "sin\u{207B}\u{00B9}" {
                    return asin(inputValue!)
                } else if operationPicker.currentValue == "cos\u{207B}\u{00B9}" {
                    return acos(inputValue!)
                } else if operationPicker.currentValue == "tan\u{207B}\u{00B9}" {
                    return atan(inputValue!)
                } else if operationPicker.currentValue == "csc\u{207B}\u{00B9}" {
                    return sin(1 / inputValue!)
                } else if operationPicker.currentValue == "sec\u{207B}\u{00B9}" {
                    return cos(1 / inputValue!)
                } else if operationPicker.currentValue == "cot\u{207B}\u{00B9}" {
                    return tan(1 / inputValue!)
                }
            }
        } else {
            workspace?.console.error(message: "Didn't specify a number to perform the indicated function on.", sourceBlock: self)
        }
        
        return nil
    }
    
    override func duplicate() -> Block {
        let newBlock: TrigOperationBlock = TrigOperationBlock()
        
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
