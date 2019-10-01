//
//  TextCaseBlock.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/9/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

class TextCaseBlock: Block {
    
    override var blockDescription: String {
        get {
            return "Converts text to lowercase or uppercase, and outputs the result."
        }
    }
    
    let slot: SlotInputComponent = SlotInputComponent(placeholder: "string", allowedInputTypes: DataType.string)
    let picker: PickerInputComponent = PickerInputComponent(options: "lowercase", "uppercase")
    
    required init(origin: CGPoint = CGPoint.zero) {
        super.init(origin: origin)
        
        outputType = DataType.string
        
        let l1: BlockLine = BlockLine()
        
        l1.addComponents(slot, TextComponent(text: "converted to"), picker)
        
        addLine(l1)
        
        fillColor = BlockColor.textColor
        textColor = BlockColor.lightTextColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult override func evaluate() -> Any? {
        if slot.input != nil {
            let str: String? = DataType.valueAsString(value: slot.input!.evaluate())
            
            if str != nil {
                if picker.currentValue == "lowercase" {
                    return str!.lowercased()
                } else if picker.currentValue == "uppercase" {
                    return str!.uppercased()
                }
            }
        } else {
            workspace?.console.error(message: "Did not supply a string to convert to \(picker.currentValue).", sourceBlock: self)
        }
        
        return nil
    }
    
    override func duplicate() -> Block {
        let newBlock: TextCaseBlock = TextCaseBlock()
        
        newBlock.picker.picker.selectItem(at: picker.picker.indexOfSelectedItem)
        
        return newBlock
    }
    
    override func applyTypeRelatedProperties(_ data: NSDictionary) {
        if DataManager.dictionary(dictionary: data, hasValueForKey: "case") {
            picker.picker.selectItem(withTitle: data.value(forKey: "case") as! String)
        }
    }
    
    override func typeRelatedProperties() -> NSMutableDictionary {
        let properties: NSMutableDictionary = super.typeRelatedProperties()
        
        properties.setValue(picker.currentValue, forKey: "case")
        
        return properties
    }
    
}
