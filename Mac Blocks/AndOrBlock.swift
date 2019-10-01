//
//  AndOrBlock.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/7/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

class AndOrBlock: Block {
    
    override var blockDescription: String {
        get {
            return "Outputs true if both are true, or one is true."
        }
    }
    
    let leftSlot: SlotInputComponent = SlotInputComponent(allowedInputTypes: DataType.boolean)
    let rightSlot: SlotInputComponent = SlotInputComponent(allowedInputTypes: DataType.boolean)
    let comparisonPicker: PickerInputComponent = PickerInputComponent(options: "and", "or")
    
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
            let leftValue: Bool? = DataType.valueAsBoolean(value: leftSlot.input!.evaluate())
            let rightValue: Bool? = DataType.valueAsBoolean(value: rightSlot.input!.evaluate())
            
            if leftValue != nil && rightValue != nil {
                if comparisonPicker.currentValue == "and" {
                    return leftValue! && rightValue!
                } else if comparisonPicker.currentValue == "or" {
                    return leftValue! || rightValue!
                }
            }
        } else {
            workspace?.console.error(message: "Must input two true/false values.", sourceBlock: self)
        }
        
        return nil
    }
    
    override func duplicate() -> Block {
        let newBlock: AndOrBlock = AndOrBlock()
        
        newBlock.comparisonPicker.picker.selectItem(at: comparisonPicker.picker.indexOfSelectedItem)
        newBlock.layoutObject()
        
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
