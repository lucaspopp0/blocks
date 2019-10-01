//
//  AddToListBlock.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/20/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

class AddToListBlock: Block {
    
    override var blockDescription: String {
        get {
            return "Adds an item to the end of a list."
        }
    }
    
    let input1: SlotInputComponent = SlotInputComponent(placeholder: "new item")
    let input2: SlotInputComponent = SlotInputComponent(placeholder: "list", allowedInputTypes: DataType.list)
    
    required init(origin: CGPoint = CGPoint.zero) {
        super.init(origin: origin)
        
        upperConnection.enabled = true
        lowerConnection.enabled = true
        
        let l1: BlockLine = BlockLine()
        
        l1.addComponents(TextComponent(text: "add"), input1, TextComponent(text: "to"), input2)
        
        addLine(l1)
        
        fillColor = BlockColor.listColor
        textColor = BlockColor.lightTextColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult override func evaluate() -> Any? {
        if input1.input != nil && input2.input != nil {
            let itemValue: Any? = input1.input!.evaluate()
            let listValue: DataList? = DataType.valueAsList(value: input2.input!.evaluate())
            
            if listValue != nil && itemValue != nil {
                listValue!.items.append(itemValue!)
            }
        } else {
            if input1.input == nil {
                workspace?.console.error(message: "Didn't specify an item to add to the list.", sourceBlock: self)
            }
            
            if input2.input == nil {
                workspace?.console.error(message: "Didn't specify a list to add to.", sourceBlock: self)
            }
        }
        
        super.evaluate()
        
        return nil
    }
    
    override func duplicate() -> Block {
        return ListItemAtIndexBlock()
    }
    
}
