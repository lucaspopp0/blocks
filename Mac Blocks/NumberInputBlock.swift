//
//  NumberInputBlock.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/8/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

class NumberInputBlock: Block {
    
    override var blockDescription: String {
        get {
            return "Outputs a number."
        }
    }
    
    let input: TextInputComponent = TextInputComponent(placeholder: "\(Int(round(drand48() * 100)))")
    
    required init(origin: CGPoint = CGPoint.zero) {
        super.init(origin: origin)
        
        outputType = DataType.number
        
        let l1: BlockLine = BlockLine()
        
        l1.addComponent(input)
        
        addLine(l1)
        
        fillColor = BlockColor.mathColor
        textColor = BlockColor.lightTextColor
        
        input.disableEditing()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult override func evaluate() -> Any? {
        if let out: Double = Double(input.textField.stringValue) {
            return out
        } else {
            workspace?.console.error(message: "\"\(input.textField.stringValue)\" could not be converted to a number.", sourceBlock: self)
            
            return nil
        }
    }
    
    override func duplicate() -> Block {
        let newBlock: NumberInputBlock = NumberInputBlock()
        
        newBlock.input.textField.stringValue = input.textField.stringValue
        
        return newBlock
    }
    
    override func applyTypeRelatedProperties(_ data: NSDictionary) {
        if DataManager.dictionary(dictionary: data, hasValueForKey: "value") {
            input.textField.stringValue = data.value(forKey: "value") as! String
        }
    }
    
    override func typeRelatedProperties() -> NSMutableDictionary {
        let properties: NSMutableDictionary = super.typeRelatedProperties()
        
        properties.setValue(input.textField.stringValue, forKey: "value")
        
        return properties
    }
    
}
