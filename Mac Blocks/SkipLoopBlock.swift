//
//  SkipLoopBlock.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/8/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

// Equivalent of break/continue in a loop
class SkipLoopBlock: Block {
    
    override var blockDescription: String {
        get {
            return "Skips to either the end or the next iteration of the loop."
        }
    }
    
    let actionPicker: PickerInputComponent = PickerInputComponent(options: "end", "next iteration")
    
    required init(origin: CGPoint = CGPoint.zero) {
        super.init(origin: origin)
        
        let l1: BlockLine = BlockLine()
        
        l1.addComponents(TextComponent(text: "skip to the"), actionPicker, TextComponent(text: "of the loop"))
        
        upperConnection.enabled = true
        
        addLine(l1)
        
        fillColor = BlockColor.loopColor
        textColor = BlockColor.lightTextColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult override func evaluate() -> Any? {
        if actionPicker.currentValue == "end" {
            workspace?.shouldBreakOutOfLoop = true
        }
        
        return nil
    }
    
    override func duplicate() -> Block {
        let newBlock: SkipLoopBlock = SkipLoopBlock()
        
        newBlock.actionPicker.picker.selectItem(at: actionPicker.picker.indexOfSelectedItem)
        
        return newBlock
    }
    
    override func applyTypeRelatedProperties(_ data: NSDictionary) {
        if DataManager.dictionary(dictionary: data, hasValueForKey: "action") {
            actionPicker.picker.selectItem(withTitle: data.value(forKey: "action") as! String)
        }
    }
    
    override func typeRelatedProperties() -> NSMutableDictionary {
        let properties: NSMutableDictionary = super.typeRelatedProperties()
        
        properties.setValue(actionPicker.currentValue, forKey: "action")
        
        return properties
    }
    
}
