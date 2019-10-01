//
//  FindInTextBlock.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/9/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

class FindInTextBlock: Block {
    
    override var blockDescription: String {
        get {
            return "Outputs the position of one string of text within another."
        }
    }
    
    let picker: PickerInputComponent = PickerInputComponent(options: "first", "last")
    let input1: SlotInputComponent = SlotInputComponent(placeholder: "string 1", doubleClickData: TextInputBlock().dictionaryValue(), allowedInputTypes: DataType.string)
    let input2: SlotInputComponent = SlotInputComponent(placeholder: "string 2", doubleClickData: TextInputBlock().dictionaryValue(), allowedInputTypes: DataType.string)
    
    required init(origin: CGPoint = CGPoint.zero) {
        super.init(origin: origin)
        
        outputType = DataType.number
        
        let l1: BlockLine = BlockLine()
        
        l1.addComponents(TextComponent(text: "the position of the"), picker, TextComponent(text: "time"), input1, TextComponent(text: "appears in"), input2)
        
        addLine(l1)
        
        fillColor = BlockColor.textColor
        textColor = BlockColor.lightTextColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult override func evaluate() -> Any? {
        if input1.input != nil && input2.input != nil {
            let searchString: String? = DataType.valueAsString(value: input1.input!.evaluate())
            let sourceString: String? = DataType.valueAsString(value: input2.input!.evaluate())
            
            if searchString != nil && sourceString != nil {
                if picker.currentValue == "first" {
                    for i in 0 ..< sourceString!.length - searchString!.length {
                        if sourceString!.substring(start: i, length: searchString!.length) == searchString! {
                            return i
                        }
                    }
                    
                    return -1
                } else if picker.currentValue == "first" {
                    var i: Int = sourceString!.length - searchString!.length
                    
                    while i >= 0 {
                        if sourceString!.substring(start: i, length: searchString!.length) == searchString! {
                            return i
                        }
                        
                        i -= 1
                    }
                    
                    return -1
                }
            }
        } else {
            if input1.input == nil {
                workspace?.console.error(message: "Didn't specify a string to search for.", sourceBlock: self)
            }
            
            if input2.input == nil {
                workspace?.console.error(message: "Didn't specify the string to search in.", sourceBlock: self)
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
