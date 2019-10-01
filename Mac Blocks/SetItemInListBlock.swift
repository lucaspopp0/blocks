//
//  SetItemInListBlock.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/20/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

class SetItemInListBlock: Block {
    
    override var blockDescription: String {
        get {
            return "Sets the value of a specific item in a list."
        }
    }
    
    let input1: SlotInputComponent = SlotInputComponent(doubleClickData: NumberInputBlock().dictionaryValue(), allowedInputTypes: DataType.number)
    let input2: SlotInputComponent = SlotInputComponent(placeholder: "list", allowedInputTypes: DataType.list)
    let input3: SlotInputComponent = SlotInputComponent(placeholder: "value")
    
    required init(origin: CGPoint = CGPoint.zero) {
        super.init(origin: origin)
        
        upperConnection.enabled = true
        lowerConnection.enabled = true
        
        let l1: BlockLine = BlockLine()
        
        l1.addComponents(TextComponent(text: "set item #"), input1, TextComponent(text: "in"), input2, TextComponent(text: "to"), input3)
        
        addLine(l1)
        
        fillColor = BlockColor.listColor
        textColor = BlockColor.lightTextColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult override func evaluate() -> Any? {
        if input1.input != nil && input2.input != nil && input3.input != nil {
            let indexEvaluated: Any? = input1.input!.evaluate()
            
            if indexEvaluated != nil && DataType.valueIsInt(value: indexEvaluated) {
                let indexValue: Int? = DataType.valueAsInt(value: input1.input!.evaluate())
                let listValue: DataList? = DataType.valueAsList(value: input2.input!.evaluate())
                let itemValue: Any? = input3.input!.evaluate()
                
                if indexValue! >= 0 {
                    if indexValue! < listValue!.items.count {
                        if itemValue != nil {
                            listValue!.items[indexValue!] = itemValue!
                        } else {
                            workspace?.console.error(message: "Cannot set item #\(indexValue!) to an empty value.", sourceBlock: self)
                        }
                    } else {
                        workspace?.console.error(message: "The item # cannot be greater than the total number of items in the list.", sourceBlock: self)
                    }
                } else {
                    workspace?.console.error(message: "The item # cannot be less than zero.", sourceBlock: self)
                }
            }
        } else {
            if input1.input == nil {
                workspace?.console.error(message: "Didn't specify an index to get the item at.", sourceBlock: self)
            }
            
            if input2.input == nil {
                workspace?.console.error(message: "Didn't specify a list to get the item from.", sourceBlock: self)
            }
            
            if input3.input == nil {
                workspace?.console.error(message: "Didn't specify a value to set the item to.", sourceBlock: self)
            }
        }
        
        super.evaluate()
        
        return nil
    }
    
    override func duplicate() -> Block {
        return SetItemInListBlock()
    }
    
}
