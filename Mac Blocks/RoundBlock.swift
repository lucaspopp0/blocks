//
//  RoundBlock.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/9/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

class RoundBlock: Block {
    
    override var blockDescription: String {
        get {
            return "Rounds a number and outputs the result."
        }
    }
    
    let picker: PickerInputComponent = PickerInputComponent(options: "round", "round up", "round down")
    let slot: SlotInputComponent = SlotInputComponent(placeholder: "number", allowedInputTypes: DataType.number)
    
    required init(origin: CGPoint = CGPoint.zero) {
        super.init(origin: origin)
        
        outputType = DataType.boolean
        
        let l1: BlockLine = BlockLine()
        
        l1.addComponents(picker, slot)
        
        addLine(l1)
        
        fillColor = BlockColor.mathColor
        textColor = BlockColor.lightTextColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult override func evaluate() -> Any? {
        if slot.input != nil {
            let num: Double? = DataType.valueAsDouble(value: slot.input!.evaluate())
            
            if num != nil {
                if picker.currentValue == "round" {
                    return round(num!)
                } else if picker.currentValue == "round up" {
                    return ceil(num!)
                } else if picker.currentValue == "round down" {
                    return floor(num!)
                }
            }
        } else {
            workspace?.console.error(message: "Didn't specify a number to round.", sourceBlock: self)
        }
        
        return nil
    }
    
    override func duplicate() -> Block {
        let newBlock: RoundBlock = RoundBlock()
        
        newBlock.picker.picker.selectItem(at: picker.picker.indexOfSelectedItem)
        
        return newBlock
    }
    
    override func applyTypeRelatedProperties(_ data: NSDictionary) {
        if DataManager.dictionary(dictionary: data, hasValueForKey: "roundType") {
            picker.picker.selectItem(withTitle: data.value(forKey: "roundType") as! String)
        }
    }
    
    override func typeRelatedProperties() -> NSMutableDictionary {
        let properties: NSMutableDictionary = super.typeRelatedProperties()
        
        properties.setValue(picker.currentValue, forKey: "roundType")
        
        return properties
    }
    
}
