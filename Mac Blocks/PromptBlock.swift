//
//  PromptBlock.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 5/3/17.
//  Copyright © 2017 Lucas Popp. All rights reserved.
//

import Cocoa

// Prompts the user for a value
class PromptBlock: Block {
    
    override var blockDescription: String {
        get {
            return "Displays a prompt dialogue box for the user, with the specified message, and outputs the text typed by the user."
        }
    }
    
    let slot: SlotInputComponent = SlotInputComponent(placeholder: "message", doubleClickData: TextInputBlock().dictionaryValue())
    
    required init(origin: CGPoint = CGPoint.zero) {
        super.init(origin: origin)
        
        let l1: BlockLine = BlockLine()
        
        outputType = DataType.string
        
        l1.addComponents(TextComponent(text: "prompt the user with"), slot)
        
        addLine(l1)
        
        fillColor = BlockColor.systemColor
        textColor = BlockColor.lightTextColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult override func evaluate() -> Any? {
        if let message: String = DataType.valueAsString(value: slot.input?.evaluate()) {
            let alert: NSAlert = NSAlert()
            
            let textField: NSTextField = NSTextField()
            textField.stringValue = "Hello!"
            textField.sizeToFit()
            textField.stringValue = ""
            textField.frame.size.width = 200
            
            alert.messageText = message
            alert.accessoryView = textField
            
            alert.runModal()
            
            // Uncomment these lines to print each prompt and response to the console 
            
            // workspace?.console.view?.addLine(ConsoleLine(printString: NSAttributedString(string: "? \(message)", attributes: [NSAttributedStringKey.font: NSFont(name: "Menlo-Bold", size: NSFont.systemFontSize)!])))
            // workspace?.console.print("❭ \(textField.stringValue)")
            
            return textField.stringValue
        } else {
            workspace?.console.error(message: "Must provide a message to prompt the user with.", sourceBlock: self)
        }
        
        return nil
    }
    
    override func duplicate() -> Block {
        return PrintBlock()
    }
    
}
