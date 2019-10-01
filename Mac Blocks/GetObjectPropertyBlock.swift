//
//  GetObjectPropertyBlock.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 4/10/17.
//  Copyright © 2017 Lucas Popp. All rights reserved.
//

import Cocoa

class GetObjectPropertyBlock: Block {
    
    override var blockDescription: String {
        get {
            return "Outputs a specific property of an object."
        }
    }
    
    let propertyInput: SlotInputComponent = SlotInputComponent(placeholder: "property", doubleClickData: TextInputBlock().dictionaryValue(), allowedInputTypes: DataType.string)
    let objectInput: SlotInputComponent = SlotInputComponent(placeholder: "object", allowedInputTypes: DataType.object)
    
    required init(origin: CGPoint = CGPoint.zero) {
        super.init(origin: origin)
        
        outputType = DataType.any
        
        let l1: BlockLine = BlockLine()
        l1.addComponents(propertyInput, TextComponent(text: "of"), objectInput)
        
        addLine(l1)
        
        fillColor = BlockColor.objectColor
        textColor = BlockColor.lightTextColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult override func evaluate() -> Any? {
        if propertyInput.input != nil && objectInput.input != nil {
            let propertyEvaluated: String? = DataType.valueAsString(value: propertyInput.input!.evaluate())
            let objectEvaluated: DataObject? = DataType.valueAsObject(value: objectInput.input!.evaluate())
            
            if propertyEvaluated != nil && objectEvaluated != nil {
                return objectEvaluated!.object[propertyEvaluated!]
            }
        } else {
            if objectInput.input == nil {
                workspace?.console.error(message: "Didn't provide an object to get the property of.", sourceBlock: self)
            }
            
            if propertyInput.input == nil {
                workspace?.console.error(message: "Didn't provide a property to get from the object.", sourceBlock: self)
            }
        }
        
        return nil
    }
    
    override func duplicate() -> Block {
        return GetObjectPropertyBlock()
    }
    
}
