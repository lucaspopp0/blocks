//
//  TextInputComponent.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/5/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

// The equivalent of a text field
class TextInputComponent: UserInputComponent {
    
    let textField: ARTextField = ARTextField()
    
    init(placeholder: String) {
        super.init()
        
        textField.isBordered = false
        textField.focusRingType = NSFocusRingType.none
        textField.backgroundColor = NSColor.clear
        textField.font = Block.FONT
        
        addSubview(textField)
        
        textField.resizeTarget = self
        textField.resizeAction = #selector(TextInputComponent.layoutFullObjectHierarchy)
        
        textField.editingEndedTarget = self
        textField.editingEndedAction = #selector(TextInputComponent.disableEditing)
        
        textField.placeholderString = placeholder
        
        fillColor = NSColor(white: 1, alpha: 0.9)
        
        disableEditing()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateStyle() {
        super.updateStyle()
        
        textField.font = Block.FONT
    }
    
    override func layoutObject() {
        let label: NSTextField = NSTextField()
        
        if textField.stringValue.isEmpty && textField.placeholderString != nil {
            label.stringValue = textField.placeholderString!
        } else {
            label.stringValue = textField.stringValue
        }
        
        label.isBordered = false
        label.font = Block.FONT
        label.isEditable = false
        label.sizeToFit()
        
        textField.frame.origin.x = 2
        textField.frame.origin.y = 1
        textField.frame.size = label.frame.size
        frame.size = textField.frame.size
        frame.size.width += 4
        
        if Block.blockStyle == Block.BlockStyle.rounded {
            let cornerRadius: CGFloat = 2
            
            styleLayer.path = CGPath(roundedRect: bounds, cornerWidth: cornerRadius, cornerHeight: cornerRadius, transform: nil)
        } else if Block.blockStyle == Block.BlockStyle.rectangle {
            styleLayer.path = CGPath(rect: bounds, transform: nil)
        } else if Block.blockStyle == Block.BlockStyle.trapezoid {
            let cornerRadius: CGFloat = 2
            let stylePath: CGMutablePath = CGMutablePath()
            
            stylePath.move(to: CGPoint(x: 0, y: frame.size.height - cornerRadius))
            stylePath.addLine(to: CGPoint(x: cornerRadius, y: frame.size.height))
            stylePath.addLine(to: CGPoint(x: frame.size.width - cornerRadius, y: frame.size.height))
            stylePath.addLine(to: CGPoint(x: frame.size.width, y: frame.size.height - cornerRadius))
            stylePath.addLine(to: CGPoint(x: frame.size.width, y: cornerRadius))
            stylePath.addLine(to: CGPoint(x: frame.size.width - cornerRadius, y: 0))
            stylePath.addLine(to: CGPoint(x: cornerRadius, y: 0))
            stylePath.addLine(to: CGPoint(x: 0, y: cornerRadius))
            
            styleLayer.path = stylePath
        }
        
        super.layoutObject()
    }
    
    func enableEditing() {
        textField.isEditable = true
    }
    
    @objc func disableEditing() {
        textField.isEditable = false
    }
    
}
