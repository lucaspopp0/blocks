//
//  CountLoopBlock.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/8/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

class CountLoopBlock: Block {
    
    override var blockDescription: String {
        get {
            return "Repeats a block of code a specific number of times."
        }
    }
    
    let countInput: SlotInputComponent = SlotInputComponent(doubleClickData: NumberInputBlock().dictionaryValue(), allowedInputTypes: DataType.number)
    let chunkLine: ChunkInputLine = ChunkInputLine()
    
    required init(origin: CGPoint = CGPoint.zero) {
        super.init(origin: origin)
        
        let l1: BlockLine = BlockLine()
        l1.addComponents(TextComponent(text: "do the following"), countInput, TextComponent(text: "times"))
        
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
        if countInput.input != nil && chunkLine.component.anchor.connectedTo != nil {
            let countEvaluated: Any? = countInput.input!.evaluate()
            
            if DataType.valueIsInt(value: countEvaluated) {
                let upperBound: Int = DataType.valueAsInt(value: countEvaluated)!
                
                let chunkBlock: Block = chunkLine.component.anchor.connectedTo as! Block
                
                for _ in 0 ..< upperBound {
                    chunkBlock.evaluate()
                    
                    if workspace?.shouldBreakOutOfLoop ?? false {
                        break
                    }
                }
            }
        } else {
            if countInput.input == nil {
                workspace?.console.error(message: "Did not specify a number of times to repeat the loop.", sourceBlock: self)
            }
            
            if chunkLine.component.anchor.connectedTo == nil {
                workspace?.console.warning(message: "Did not provide any blocks to execute when running the loop.", sourceBlock: self)
            }
        }
        
        super.evaluate()
        
        return nil
    }
    
    override func duplicate() -> Block {
        return CountLoopBlock()
    }
    
}
