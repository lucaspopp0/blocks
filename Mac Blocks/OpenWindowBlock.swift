//
//  OpenWindowBlock.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 4/8/17.
//  Copyright © 2017 Lucas Popp. All rights reserved.
//

import Cocoa

class OpenWindowBlock: Block {
    
    override var blockDescription: String {
        get {
            return "Opens a window."
        }
    }
    
    let windowSlot: SlotInputComponent = SlotInputComponent(placeholder: "window", allowedInputTypes: DataType.windowController)
    
    required init(origin: CGPoint = CGPoint.zero) {
        super.init(origin: origin)
        
        upperConnection.enabled = true
        lowerConnection.enabled = true
        
        let l1: BlockLine = BlockLine()
        l1.addComponents(TextComponent(text: "open"), windowSlot)
        
        addLine(l1)
        
        fillColor = BlockColor.functionColor
        textColor = BlockColor.lightTextColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult override func evaluate() -> Any? {
        if windowSlot.input != nil {
            let wc: NSWindowController? = DataType.valueAsWindowController(value: windowSlot.input!.evaluate())
            
            wc?.showWindow(self)
        }
        
        return super.evaluate()
    }
    
    override func duplicate() -> Block {
        return OpenWindowBlock()
    }
    
}
