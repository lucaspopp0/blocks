//
//  ListLengthBlock.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/20/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

class ListLengthBlock: Block {
    
    override var blockDescription: String {
        get {
            return "Outputs the length of a list."
        }
    }
    
    let slot: SlotInputComponent = SlotInputComponent(placeholder: "list", allowedInputTypes: DataType.list)
    
    required init(origin: CGPoint = CGPoint.zero) {
        super.init(origin: origin)
        
        outputType = DataType.number
        
        let l1: BlockLine = BlockLine()
        
        l1.addComponents(TextComponent(text: "length of"), slot)
        
        addLine(l1)
        
        fillColor = BlockColor.listColor
        textColor = BlockColor.lightTextColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult override func evaluate() -> Any? {
        if slot.input != nil {
            let listValue: DataList? = DataType.valueAsList(value: slot.input!.evaluate())
            
            if listValue != nil {
                return listValue!.items.count
            }
        } else {
            workspace?.console.error(message: "Didn't provide a list to measure the length of.", sourceBlock: self)
        }
        
        return nil
    }
    
    override func duplicate() -> Block {
        return TextLengthBlock()
    }
    
}
