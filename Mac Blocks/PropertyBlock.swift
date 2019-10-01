//
//  PropertyBlock.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/30/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

class PropertyBlock: Block {
    
    let nameInput: TextInputComponent = TextInputComponent(placeholder: "Property name")
    let typeInput: PickerInputComponent = PickerInputComponent(options: "string", "number", "boolean", "type", "object", "list", "any")
    
    required init(origin: CGPoint = CGPoint.zero) {
        super.init(origin: origin)
        
        selectable = false
        movable = false
        
        let l1: BlockLine = BlockLine()
        l1.fullWidth = true
        
        let t1: TextComponent = TextComponent(text: "Property")
        l1.addComponent(t1)
        
        let l2: BlockLine = BlockLine()
        l2.fullWidth = true
        
        let s1: TextLabelComponent = TextLabelComponent(text: "NAME")
        let s2: TextLabelComponent = TextLabelComponent(text: "VALUE")
        s2.alignment = BlockComponent.Alignment.right
        l2.addComponents(s1, s2)
        
        let l3: BlockLine = BlockLine()
        l3.fullWidth = true
        
        typeInput.alignment = BlockComponent.Alignment.right
        l3.addComponents(nameInput, typeInput)
        
        addLines(l1, l2, l3)
        
        typeInput.changeTarget = self
        typeInput.changeHandler = #selector(PropertyBlock.updateBackground)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func updateBackground() {
        switch typeInput.currentValue {
        case "string":
            fillColor = BlockColor.textColor
            break
        case "number":
            fillColor = BlockColor.mathColor
            break
        case "boolean":
            fillColor = BlockColor.logicColor
            break
        case "type":
            fillColor = BlockColor.typeColor
            break
        case "object":
            fillColor = BlockColor.objectColor
            break
        case "list":
            fillColor = BlockColor.listColor
            break
        case "any":
            fillColor = BlockColor.functionColor
            break
        default:
            fillColor = NSColor.white
            break
        }
    }
    
}
