//
//  TypeIsBlock.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/16/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

class TypeIsBlock: Block {
    
    override var blockDescription: String {
        get {
            return "Checks if a value is of a specific type."
        }
    }
    
    let slot: SlotInputComponent = SlotInputComponent()
    let typeSlot: SlotInputComponent = SlotInputComponent(placeholder: "type", allowedInputTypes: DataType.type)
    
    required init(origin: CGPoint = CGPoint.zero) {
        super.init(origin: origin)
        
        outputType = DataType.boolean
        
        let l1: BlockLine = BlockLine()
        
        l1.addComponents(slot, TextComponent(text: "is"), typeSlot)
        
        addLine(l1)
        
        fillColor = BlockColor.typeColor
        textColor = BlockColor.lightTextColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult override func evaluate() -> Any? {
        if slot.input != nil && typeSlot.input != nil {
            let valueEvaluated: Any? = slot.input?.evaluate()
            
            if let typeEvaluated: DataType = DataType.valueAsType(value: typeSlot.input?.evaluate()) {
                return DataType.valueIs(value: valueEvaluated, type: typeEvaluated)
            } else {
                workspace?.console.error(message: "Could not determine the type to test for.", sourceBlock: self)
            }
        } else {
            if slot.input == nil {
                workspace?.console.error(message: "No value to check the type of.", sourceBlock: self)
            }
            
            if typeSlot.input == nil {
                workspace?.console.error(message: "No type to test for.", sourceBlock: self)
            }
        }
        
        return nil
    }
    
    override func duplicate() -> Block {
        return TypeOfBlock()
    }
    
}
