//
//  WindowBlock.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 4/8/17.
//  Copyright © 2017 Lucas Popp. All rights reserved.
//

import Cocoa

class WindowBlock: Block {
    
    override var blockDescription: String {
        get {
            return "Outputs an object representing a window."
        }
    }
    
    let titleSlot: SlotInputComponent = SlotInputComponent(allowedInputTypes: DataType.string)
    
    required init(origin: CGPoint = CGPoint.zero) {
        super.init(origin: origin)
        
        outputType = DataType.windowController
        
        let l1: BlockLine = BlockLine()
        l1.addComponents(TextComponent(text: "new window titled"), titleSlot)
        
        addLine(l1)
        
        fillColor = BlockColor.functionColor
        textColor = BlockColor.lightTextColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult override func evaluate() -> Any? {
        let storyboard: NSStoryboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        
        let window: NSWindow = NSWindow(contentViewController: storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "Blank View Controller")) as! NSViewController)

        if titleSlot.input != nil {
            if let windowTitle: String = DataType.valueAsString(value: titleSlot.input!.evaluate()) {
                window.title = windowTitle
            }
        }
        
        let controller: NSWindowController = NSWindowController(window: window)
        
        workspace?.data.windowReferences.append(controller)
        
        return controller
    }
    
    override func duplicate() -> Block {
        let newBlock: WindowBlock = WindowBlock()
        
        return newBlock
    }
    
    // applyTypeRelatedProperties
    // typeRelatedProperties
    
}
