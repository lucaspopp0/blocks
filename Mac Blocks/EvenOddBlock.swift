//
//  EvenOddBlock.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/9/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

class EvenOddBlock: Block {
    
    override var blockDescription: String {
        get {
            return "Tests whether or not a number is even/odd."
        }
    }
    
    let slot: SlotInputComponent = SlotInputComponent(placeholder: "number", allowedInputTypes: DataType.number)
    let picker: PickerInputComponent = PickerInputComponent(options: "even", "odd")
    
    required init(origin: CGPoint = CGPoint.zero) {
        super.init(origin: origin)
        
        outputType = DataType.boolean
        
        let l1: BlockLine = BlockLine()
        
        l1.addComponents(slot, TextComponent(text: "is"), picker)
        
        addLine(l1)
        
        fillColor = BlockColor.mathColor
        textColor = BlockColor.lightTextColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult override func evaluate() -> Any? {
        if slot.input != nil {
            let evaluatedValue: Any? = slot.input!.evaluate()
            
            if DataType.valueIsInt(value: evaluatedValue) {
                let input: Int = DataType.valueAsInt(value: evaluatedValue)!
                
                if picker.currentValue == "even" {
                    return (input % 2 == 0)
                } else if picker.currentValue == "odd" {
                    return (input % 2 != 0)
                }
            } else {
                return false
            }
        } else {
            workspace?.console.error(message: "Didn't specify a number.", sourceBlock: self)
        }
        
        return nil
    }
    
    override func duplicate() -> Block {
        let newBlock: EvenOddBlock = EvenOddBlock()
        
        newBlock.picker.picker.selectItem(at: picker.picker.indexOfSelectedItem)
        
        return newBlock
    }
    
    override func applyTypeRelatedProperties(_ data: NSDictionary) {
        if DataManager.dictionary(dictionary: data, hasValueForKey: "evenOdd") {
            picker.picker.selectItem(withTitle: data.value(forKey: "evenOdd") as! String)
        }
    }
    
    override func typeRelatedProperties() -> NSMutableDictionary {
        let properties: NSMutableDictionary = super.typeRelatedProperties()
        
        properties.setValue(picker.currentValue, forKey: "evenOdd")
        
        return properties
    }

}
