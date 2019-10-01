//
//  TypeOfBlock.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/16/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

class TypeOfBlock: Block {
    
    override var blockDescription: String {
        get {
            return "Outputs the type of a value."
        }
    }
    
    let slot: SlotInputComponent = SlotInputComponent()
    
    required init(origin: CGPoint = CGPoint.zero) {
        super.init(origin: origin)
        
        outputType = DataType.type
        
        let l1: BlockLine = BlockLine()
        
        l1.addComponents(TextComponent(text: "type of"), slot)
        
        addLine(l1)
        
        fillColor = BlockColor.typeColor
        textColor = BlockColor.lightTextColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult override func evaluate() -> Any? {
        if slot.input != nil {
            if slot.input!.outputType != DataType.any {
                return slot.input!.outputType
            } else {
                let slotEvaluated: Any? = slot.input!.evaluate()
                
                if slotEvaluated != nil {
                    for type in DataType.all() {
                        if DataType.valueIs(value: slotEvaluated!, type: type) {
                            return type
                        }
                    }
                    
                    return DataType.none
                }
            }
        } else {
            workspace?.console.error(message: "Didn't specify the value to get the type of.", sourceBlock: self)
        }
        
        return nil
    }
    
    override func duplicate() -> Block {
        return TypeOfBlock()
    }
    
}
