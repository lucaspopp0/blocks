//
//  TypeBlock.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/16/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

class TypeBlock: Block {
    
    override var blockDescription: String {
        get {
            return "Outputs a specific type of data."
        }
    }
    
    var typePicker: PickerInputComponent = PickerInputComponent(options: "types")
    
    required init(origin: CGPoint = CGPoint.zero) {
        super.init(origin: origin)
        
        outputType = DataType.type
        
        var options: [String] = []
        
        for type in DataType.all() {
            options.append(String(describing: type))
        }
        
        typePicker = PickerInputComponent(options: options)
        
        let l1: BlockLine = BlockLine()
        
        l1.addComponent(typePicker)
        
        addLine(l1)
        
        fillColor = BlockColor.typeColor
        textColor = BlockColor.lightTextColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult override func evaluate() -> Any? {
        return DataType.all()[typePicker.picker.indexOfSelectedItem]
    }
    
    override func duplicate() -> Block {
        let newBlock: TypeBlock = TypeBlock()
        
        newBlock.typePicker.picker.selectItem(at: typePicker.picker.indexOfSelectedItem)
        
        return newBlock
    }
    
    override func applyTypeRelatedProperties(_ data: NSDictionary) {
        if DataManager.dictionary(dictionary: data, hasValueForKey: "value") {
            typePicker.picker.selectItem(withTitle: data.value(forKey: "value") as! String)
        }
    }
    
    override func typeRelatedProperties() -> NSMutableDictionary {
        let properties: NSMutableDictionary = super.typeRelatedProperties()
        
        properties.setValue(typePicker.currentValue, forKey: "value")
        
        return properties
    }
    
}
