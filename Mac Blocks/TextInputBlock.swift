//
//  TextInputBlock.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/9/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

class TextInputBlock: Block {
    
    override var blockDescription: String {
        get {
            return "Outputs a text value."
        }
    }
    
    let input: TextInputComponent = TextInputComponent(placeholder: "")
    
    required init(origin: CGPoint = CGPoint.zero) {
        super.init(origin: origin)
        
        let l1: BlockLine = BlockLine()
        
        outputType = DataType.string
        
        l1.addComponents(TextComponent(text: "“"), input, TextComponent(text: "”"))
        
        addLine(l1)
        
        fillColor = BlockColor.textColor
        textColor = BlockColor.lightTextColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult override func evaluate() -> Any? {
        return input.textField.stringValue
    }
    
    override func duplicate() -> Block {
        let newBlock: TextInputBlock = TextInputBlock()
        
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
