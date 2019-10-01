//
//  AsBlock.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/20/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

class AsBlock: Block {
    
    override var blockDescription: String {
        get {
            return "Converts a value into a specific type."
        }
    }
    
    let slot: SlotInputComponent = SlotInputComponent()
    let typeSlot: SlotInputComponent = SlotInputComponent(placeholder: "type", allowedInputTypes: DataType.type)
    
    required init(origin: CGPoint = CGPoint.zero) {
        super.init(origin: origin)
        
        outputType = DataType.any
        
        let l1: BlockLine = BlockLine()
        
        l1.addComponents(slot, TextComponent(text: "as"), typeSlot)
        
        addLine(l1)
        
        fillColor = BlockColor.typeColor
        textColor = BlockColor.lightTextColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult override func evaluate() -> Any? {
        if slot.input != nil && typeSlot.input != nil {
            let slotEvaluated: Any? = slot.input!.evaluate()
            
            if let type: DataType = DataType.valueAsType(value: typeSlot.input!.evaluate()) {
                switch type {
                case DataType.string:
                    return DataType.valueAsString(value: slotEvaluated)
                case DataType.number:
                    return DataType.valueAsDouble(value: slotEvaluated)
                case DataType.boolean:
                    return DataType.valueAsBoolean(value: slotEvaluated)
                case DataType.type:
                    return DataType.valueAsType(value: slotEvaluated)
                case DataType.object:
                    return DataType.valueAsObject(value: slotEvaluated)
                case DataType.list:
                    return DataType.valueAsList(value: slotEvaluated)
                case DataType.windowController:
                    return DataType.valueAsWindowController(value: slotEvaluated)
                case DataType.color:
                    return DataType.valueAsColor(value: slotEvaluated)
                case DataType.any:
                    return slotEvaluated != nil
                case DataType.none:
                    return slotEvaluated == nil
                }
            } else {
                workspace?.console.error(message: "Could not determine the type to convert the value to.", sourceBlock: self)
            }
        } else {
            if slot.input == nil {
                workspace?.console.error(message: "Did not specify a value to convert.", sourceBlock: self)
            }
            
            if typeSlot.input == nil {
                workspace?.console.error(message: "Did not specify a type to convert to.", sourceBlock: self)
            }
        }
        
        return nil
    }
    
    override func duplicate() -> Block {
        return TypeOfBlock()
    }
    
}
