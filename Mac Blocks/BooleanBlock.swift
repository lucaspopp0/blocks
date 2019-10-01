//
//  BooleanBlock.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/6/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

// Outputs either true or false
class BooleanBlock: Block {
    
    override var blockDescription: String {
        get {
            return "Outputs either \"true\" or \"false\"."
        }
    }
    
    let booleanPicker: PickerInputComponent = PickerInputComponent(options: "true", "false")
    
    required init(origin: CGPoint = CGPoint.zero) {
        super.init(origin: origin)
        
        outputType = DataType.boolean
        
        let l1: BlockLine = BlockLine()
        
        l1.addComponent(booleanPicker)
        
        addLine(l1)
        
        fillColor = BlockColor.logicColor
        textColor = BlockColor.lightTextColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult override func evaluate() -> Any? {
        if booleanPicker.picker.indexOfSelectedItem == 0 {
            return true
        } else {
            return false
        }
    }
    
    override func duplicate() -> Block {
        let newBlock: BooleanBlock = BooleanBlock()
        
        newBlock.booleanPicker.picker.selectItem(at: booleanPicker.picker.indexOfSelectedItem)
        
        return newBlock
    }
    
    override func applyTypeRelatedProperties(_ data: NSDictionary) {
        if DataManager.dictionary(dictionary: data, hasValueForKey: "value") {
            booleanPicker.picker.selectItem(withTitle: data.value(forKey: "value") as! String)
        }
    }
    
    override func typeRelatedProperties() -> NSMutableDictionary {
        let properties: NSMutableDictionary = super.typeRelatedProperties()
        
        properties.setValue(booleanPicker.currentValue, forKey: "value")
        
        return properties
    }
    
}
