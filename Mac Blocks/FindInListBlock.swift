//
//  FindInListBlock.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/20/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

class FindInListBlock: Block {
    
    override var blockDescription: String {
        get {
            return "Outputs the position of an item in a list."
        }
    }
    
    let picker: PickerInputComponent = PickerInputComponent(options: "first", "last")
    let input1: SlotInputComponent = SlotInputComponent(placeholder: "item")
    let input2: SlotInputComponent = SlotInputComponent(placeholder: "list", allowedInputTypes: DataType.list)
    
    required init(origin: CGPoint = CGPoint.zero) {
        super.init(origin: origin)
        
        outputType = DataType.number
        
        let l1: BlockLine = BlockLine()
        
        l1.addComponents(TextComponent(text: "the position of the"), picker, TextComponent(text: "occurance of"), input1, TextComponent(text: "in"), input2)
        
        addLine(l1)
        
        fillColor = BlockColor.listColor
        textColor = BlockColor.lightTextColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult override func evaluate() -> Any? {
        if input1.input != nil && input2.input != nil {
            let query: Any? = input1.input!.evaluate()
            let source: DataList? = DataType.valueAsList(value: input2.input!.evaluate())
            
            if query != nil && source != nil {
                if picker.currentValue == "first" {
                    for i in 0 ..< source!.items.count {
                        if DataManager.objectsEqual(source!.items[i], query!) {
                            return i
                        }
                    }
                    
                    return -1
                } else if picker.currentValue == "first" {
                    var i: Int = source!.items.count - 1
                    
                    while i >= 0 {
                        if DataManager.objectsEqual(source!.items[i], query!) {
                            return i
                        }
                        
                        i -= 1
                    }
                    
                    return -1
                }
            }
        } else {
            if input1.input == nil {
                workspace?.console.error(message: "Didn't provide an item to search for.", sourceBlock: self)
            }
            
            if input2.input == nil {
                workspace?.console.error(message: "Didn't provide a list to search in.", sourceBlock: self)
            }
        }
        
        return nil
    }
    
    override func duplicate() -> Block {
        let newBlock: FindInTextBlock = FindInTextBlock()
        
        newBlock.picker.picker.selectItem(at: picker.picker.indexOfSelectedItem)
        
        return newBlock
    }
    
    override func applyTypeRelatedProperties(_ data: NSDictionary) {
        if DataManager.dictionary(dictionary: data, hasValueForKey: "firstLast") {
            picker.picker.selectItem(withTitle: data.value(forKey: "firstLast") as! String)
        }
    }
    
    override func typeRelatedProperties() -> NSMutableDictionary {
        let properties: NSMutableDictionary = super.typeRelatedProperties()
        
        properties.setValue(picker.currentValue, forKey: "firstLast")
        
        return properties
    }
    
}
