//
//  ConstantBlock.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/9/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

class ConstantBlock: Block {
    
    override var blockDescription: String {
        get {
            return "Outputs a constant."
        }
    }
    
    var picker: PickerInputComponent = PickerInputComponent(options: "π", "e")
    
    required init(origin: CGPoint = CGPoint.zero) {
        super.init(origin: origin)
        
        outputType = DataType.number
        
        let l1: BlockLine = BlockLine()
        
        l1.addComponent(picker)
        
        addLine(l1)
        
        fillColor = BlockColor.mathColor
        textColor = BlockColor.lightTextColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult override func evaluate() -> Any? {
        if picker.currentValue == "π" {
            return Double.pi
        } else if picker.currentValue == "e" {
            return M_E
        } else {
            return nil
        }
    }
    
    override func duplicate() -> Block {
        let newBlock: ConstantBlock = ConstantBlock()
        
        newBlock.picker.picker.selectItem(at: picker.picker.indexOfSelectedItem)
        
        return newBlock
    }
    
    override func applyTypeRelatedProperties(_ data: NSDictionary) {
        if DataManager.dictionary(dictionary: data, hasValueForKey: "constant") {
            picker.picker.selectItem(withTitle: data.value(forKey: "constant") as! String)
        }
    }
    
    override func typeRelatedProperties() -> NSMutableDictionary {
        let properties: NSMutableDictionary = super.typeRelatedProperties()
        
        properties.setValue(picker.currentValue, forKey: "constant")
        
        return properties
    }
    
}
