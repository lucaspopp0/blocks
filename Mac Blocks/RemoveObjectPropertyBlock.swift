//
//  RemoveObjectPropertyBlock.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/22/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

class RemoveObjectPropertyBlock: Block {
    
    override var blockDescription: String {
        get {
            return "Removes a specific property of an object."
        }
    }
    
    let input1: SlotInputComponent = SlotInputComponent(placeholder: "property", doubleClickData: TextInputBlock().dictionaryValue(), allowedInputTypes: DataType.string)
    let input2: SlotInputComponent = SlotInputComponent(placeholder: "object", allowedInputTypes: DataType.object)
    
    required init(origin: CGPoint = CGPoint.zero) {
        super.init(origin: origin)
        
        upperConnection.enabled = true
        lowerConnection.enabled = true
        
        let l1: BlockLine = BlockLine()
        
        l1.addComponents(TextComponent(text: "remove"), input1, TextComponent(text: "from"), input2)
        
        addLine(l1)
        
        fillColor = BlockColor.objectColor
        textColor = BlockColor.lightTextColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult override func evaluate() -> Any? {
        if input1.input != nil && input2.input != nil {
            let propertyEvaluated: Any? = input1.input!.evaluate()
            
            if propertyEvaluated != nil && DataType.valueIsString(value: propertyEvaluated) {
                let objectValue: DataObject? = DataType.valueAsObject(value: input2.input!.evaluate())
                
                if objectValue != nil {
                    objectValue!.object.removeValue(forKey: DataType.valueAsString(value: propertyEvaluated!)!)
                }
            }
        } else {
            if input2.input == nil {
                workspace?.console.error(message: "Didn't provide an object to remove the property of.", sourceBlock: self)
            }
            
            if input1.input == nil {
                workspace?.console.error(message: "Didn't provide a property to remove.", sourceBlock: self)
            }
        }
        
        super.evaluate()
        
        return nil
    }
    
    override func duplicate() -> Block {
        return RemoveObjectPropertyBlock()
    }
    
}
