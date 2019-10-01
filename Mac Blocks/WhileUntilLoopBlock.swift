//
//  WhileUntilLoopBlock.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/8/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

class WhileUntilLoopBlock: Block {
    
    override var blockDescription: String {
        get {
            return "Repeats a block of code either while until a condition is met."
        }
    }
    
    let loopTypeInput: PickerInputComponent = PickerInputComponent(options: "while", "until")
    let conditionInput: SlotInputComponent = SlotInputComponent(placeholder: "this is true", allowedInputTypes: DataType.boolean)
    let chunkLine: ChunkInputLine = ChunkInputLine()
    
    required init(origin: CGPoint = CGPoint.zero) {
        super.init(origin: origin)
        
        let l1: BlockLine = BlockLine()
        l1.addComponents(TextComponent(text: "repeat the following"), loopTypeInput, conditionInput)
        
        upperConnection.enabled = true
        lowerConnection.enabled = true
        
        addLines(l1, chunkLine)
        
        fillColor = BlockColor.loopColor
        textColor = BlockColor.lightTextColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult override func evaluate() -> Any? {
        if conditionInput.input != nil && chunkLine.component.anchor.connectedTo != nil {
            let chunkBlock: Block = chunkLine.component.anchor.connectedTo as! Block
            
            if loopTypeInput.currentValue == "while" {
                while DataType.valueAsBoolean(value: conditionInput.input!.evaluate()) ?? false {
                    chunkBlock.evaluate()
                    
                    if workspace?.shouldBreakOutOfLoop ?? false {
                        break
                    }
                }
            } else if loopTypeInput.currentValue == "until" {
                while !(DataType.valueAsBoolean(value: conditionInput.input!.evaluate()) ?? false) {
                    chunkBlock.evaluate()
                    
                    if workspace?.shouldBreakOutOfLoop ?? false {
                        break
                    }
                }
            }
        } else {
            if conditionInput.input == nil {
                workspace?.console.error(message: "Did not specify a condition to check for the loop.", sourceBlock: self)
            }
            
            if chunkLine.component.anchor.connectedTo == nil {
                workspace?.console.warning(message: "Did not provide any blocks to execute when running the loop.", sourceBlock: self)
            }
        }
        
        super.evaluate()
        
        return nil
    }
    
    override func duplicate() -> Block {
        let newBlock: WhileUntilLoopBlock = WhileUntilLoopBlock()
        
        newBlock.loopTypeInput.picker.selectItem(at: loopTypeInput.picker.indexOfSelectedItem)
        
        return newBlock
    }
    
    override func applyTypeRelatedProperties(_ data: NSDictionary) {
        if DataManager.dictionary(dictionary: data, hasValueForKey: "loopType") {
            loopTypeInput.picker.selectItem(withTitle: data.value(forKey: "loopType") as! String)
        }
    }
    
    override func typeRelatedProperties() -> NSMutableDictionary {
        let properties: NSMutableDictionary = super.typeRelatedProperties()
        
        properties.setValue(loopTypeInput.currentValue, forKey: "loopType")
        
        return properties
    }
    
}
