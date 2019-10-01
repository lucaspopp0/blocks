//
//  RGBColorBlock.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 5/2/17.
//  Copyright © 2017 Lucas Popp. All rights reserved.
//

import Cocoa

class RGBColorBlock: Block {
    
    override var blockDescription: String {
        get {
            return "Ouputs a color with specific RGB values."
        }
    }
    
    let redInput: SlotInputComponent = SlotInputComponent(doubleClickData: NumberInputBlock().dictionaryValue(), allowedInputTypes: DataType.number)
    let greenInput: SlotInputComponent = SlotInputComponent(doubleClickData: NumberInputBlock().dictionaryValue(), allowedInputTypes: DataType.number)
    let blueInput: SlotInputComponent = SlotInputComponent(doubleClickData: NumberInputBlock().dictionaryValue(), allowedInputTypes: DataType.number)
    
    required init(origin: CGPoint = CGPoint.zero) {
        super.init(origin: origin)
        
        let l1: BlockLine = BlockLine()
        l1.addComponents(TextComponent(text: "color with"), redInput, TextComponent(text: "red"), greenInput, TextComponent(text: "green and"), blueInput, TextComponent(text: "blue"))
        addLine(l1)
        
        outputType = DataType.color
        
        fillColor = BlockColor.colorColor
        textColor = BlockColor.lightTextColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult override func evaluate() -> Any? {
        if redInput.input != nil && greenInput.input != nil && blueInput.input != nil {
            if let red: Double = DataType.valueAsDouble(value: redInput.input?.evaluate()),
                let green: Double = DataType.valueAsDouble(value: greenInput.input?.evaluate()),
                let blue: Double = DataType.valueAsDouble(value: blueInput.input?.evaluate()) {
                return NSColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1)
            }
        }
        
        return nil
    }
    
    override func duplicate() -> Block {
        let newBlock: RGBColorBlock = RGBColorBlock()
        
        return newBlock
    }
    
}
