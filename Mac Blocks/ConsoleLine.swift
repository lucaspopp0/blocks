//
//  ConsoleLine.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 5/28/17.
//  Copyright © 2017 Lucas Popp. All rights reserved.
//

import Cocoa

class GenericConsoleLine: NSView {
    
    class ActionTextView: NSTextView {
        
        var target: AnyObject?
        var action: Selector?
        
        override func keyUp(with event: NSEvent) {
            if event.keyCode == 36 {
                if action != nil {
                    let _ = target?.perform(action)
                }
            }
        }
        
    }
    
    var textView: ActionTextView = ActionTextView()
    var blockReference: BlockLink?
    
    fileprivate func unifiedInit() {
        addSubview(textView)
        
        textView.font = NSFont(name: "Menlo", size: NSFont.systemFontSize)
        
        if blockReference != nil {
            addSubview(blockReference!)
        }
    }
    
    init(attributedString: NSAttributedString?, blockReference: Block?) {
        super.init(frame: NSRect.zero)
        
        if blockReference != nil {
            self.blockReference = BlockLink(block: blockReference!)
        }
        
        unifiedInit()
        
        if attributedString != nil {
            textView.textStorage?.setAttributedString(attributedString!)
        }
    }
    
    init(text: String?, blockReference: Block?) {
        super.init(frame: NSRect.zero)
        
        textView.string = text ?? ""
        
        if blockReference != nil {
            self.blockReference = BlockLink(block: blockReference!)
        }
        
        unifiedInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutSubviews() {
        if let button = blockReference {
            button.sizeToFit()
            button.frame.origin.x = frame.size.width - button.frame.size.width
            
            textView.frame.size.width = frame.size.width - button.frame.size.width
            
            let layoutManager: NSLayoutManager = textView.layoutManager!
            let textContainer: NSTextContainer = layoutManager.textContainers[0]
            
            layoutManager.ensureLayout(for: textContainer)
            
            frame.size.height = max(button.frame.size.height, textView.frame.size.height)
            button.frame.origin.y = frame.size.height - button.frame.size.height
            textView.frame.origin.y = (frame.size.height - textView.frame.size.height) / 2
        } else {
            textView.frame.size.width = frame.size.width
            
            let layoutManager: NSLayoutManager = textView.layoutManager!
            let textContainer: NSTextContainer = layoutManager.textContainers[0]
            
            layoutManager.ensureLayout(for: textContainer)
            
            frame.size.height = textView.frame.size.height
            textView.frame.origin.y = (frame.size.height - textView.frame.size.height) / 2
        }
    }
    
    override func resizeSubviews(withOldSize oldSize: NSSize) {
        super.resizeSubviews(withOldSize: oldSize)
        
        if let button = blockReference {
            button.frame.origin.x = frame.size.width - button.frame.size.width
            button.frame.origin.y = frame.size.height - button.frame.size.height
            
            textView.frame.size.width = frame.size.width - button.frame.size.width
            textView.frame.origin.y = (frame.size.height - textView.frame.size.height) / 2
        } else {
            textView.frame.size.width = frame.size.width
            textView.frame.origin.y = (frame.size.height - textView.frame.size.height) / 2
        }
    }
    
}

class ConsoleLine: GenericConsoleLine {
    
    override func unifiedInit() {
        super.unifiedInit()
        
        textView.isEditable = false
    }
    
    convenience init(printString: NSAttributedString, blockReference: Block? = nil) {
        self.init(attributedString: printString, blockReference: blockReference)
    }
    
    convenience init(printMessage: String, blockReference: Block? = nil) {
        self.init(text: printMessage, blockReference: blockReference)
    }
    
    convenience init(warningString: NSAttributedString, blockReference: Block? = nil) {
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: "Warning: ", attributes: [NSAttributedStringKey.foregroundColor: NSColor(hex: "FFBA00"),
                                                                                                                      NSAttributedStringKey.font: NSFont(name: "Menlo-Bold", size: NSFont.systemFontSize) ?? NSFont.boldSystemFont(ofSize: NSFont.systemFontSize)])
        
        
        attributedString.append(warningString)
        
        self.init(attributedString: attributedString, blockReference: blockReference)
    }
    
    convenience init(warningMessage: String, blockReference: Block? = nil) {
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: "Warning: ", attributes: [NSAttributedStringKey.foregroundColor: NSColor(hex: "FFBA00"),
                                                                                                                      NSAttributedStringKey.font: NSFont(name: "Menlo-Bold", size: NSFont.systemFontSize) ?? NSFont.boldSystemFont(ofSize: NSFont.systemFontSize)])
        
        attributedString.append(NSAttributedString(string: warningMessage, attributes: [NSAttributedStringKey.foregroundColor: NSColor(hex: "FFBA00"),
                                                                                        NSAttributedStringKey.font: NSFont(name: "Menlo", size: NSFont.systemFontSize) ?? NSFont.systemFont(ofSize: NSFont.systemFontSize)]))
        
        self.init(attributedString: attributedString, blockReference: blockReference)
    }
    
    convenience init(errorString: NSAttributedString, blockReference: Block? = nil) {
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: "Error: ", attributes: [NSAttributedStringKey.foregroundColor: NSColor(hex: "F44336"),
                                                                                                                    NSAttributedStringKey.font: NSFont(name: "Menlo-Bold", size: NSFont.systemFontSize) ?? NSFont.boldSystemFont(ofSize: NSFont.systemFontSize)])
        
        attributedString.append(errorString)
        
        self.init(attributedString: attributedString, blockReference: blockReference)
    }
    
    convenience init(errorMessage: String, blockReference: Block? = nil) {
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: "Error: ", attributes: [NSAttributedStringKey.foregroundColor: NSColor(hex: "F44336"),
                                                                                                                    NSAttributedStringKey.font: NSFont(name: "Menlo-Bold", size: NSFont.systemFontSize) ?? NSFont.boldSystemFont(ofSize: NSFont.systemFontSize)])
        
        attributedString.append(NSAttributedString(string: errorMessage, attributes: [NSAttributedStringKey.foregroundColor: NSColor(hex: "F44336"),
                                                                                      NSAttributedStringKey.font: NSFont(name: "Menlo", size: NSFont.systemFontSize) ?? NSFont.systemFont(ofSize: NSFont.systemFontSize)]))
        
        self.init(attributedString: attributedString, blockReference: blockReference)
    }
    
}

protocol InputLineDelegate {
    
    func inputCompleted(_ line: InputLine)
    
}

class InputLine: GenericConsoleLine {
    
    var delegate: InputLineDelegate?
    
    let inputCaret: NSTextView = NSTextView()
    
    override func unifiedInit() {
        super.unifiedInit()
        inputCaret.font = textView.font
        inputCaret.isEditable = false
        inputCaret.string = "❭"
        
        let testCaret: NSTextField = NSTextField(labelWithString: "❭")
        testCaret.font = textView.font
        testCaret.sizeToFit()
        
        inputCaret.frame.size.width = testCaret.frame.size.width
        
        if let layoutManager = inputCaret.layoutManager {
            layoutManager.ensureLayout(for: layoutManager.textContainers[0])
        }
        
        addSubview(inputCaret)
        
        textView.target = self
        textView.action = #selector(InputLine.enterPressed)
    }
    
    init() {
        super.init(text: "", blockReference: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func enterPressed() {
        delegate?.inputCompleted(self)
    }
    
    override func layoutSubviews() {
        if let layoutManager = inputCaret.layoutManager {
            layoutManager.ensureLayout(for: layoutManager.textContainers[0])
        }
        
        inputCaret.frame.origin.x = 0
        
        textView.frame.origin.x = inputCaret.frame.size.width
        
        if let button = blockReference {
            button.sizeToFit()
            button.frame.origin.x = frame.size.width - button.frame.size.width
            
            textView.frame.size.width = frame.size.width - button.frame.size.width - textView.frame.origin.x
            
            let layoutManager: NSLayoutManager = textView.layoutManager!
            let textContainer: NSTextContainer = layoutManager.textContainers[0]
            
            layoutManager.ensureLayout(for: textContainer)
            
            frame.size.height = max(button.frame.size.height, textView.frame.size.height)
            button.frame.origin.y = frame.size.height - button.frame.size.height
            textView.frame.origin.y = (frame.size.height - textView.frame.size.height) / 2
        } else {
            textView.frame.size.width = frame.size.width - textView.frame.origin.x
            
            let layoutManager: NSLayoutManager = textView.layoutManager!
            let textContainer: NSTextContainer = layoutManager.textContainers[0]
            
            layoutManager.ensureLayout(for: textContainer)
            
            frame.size.height = textView.frame.size.height
            textView.frame.origin.y = (frame.size.height - textView.frame.size.height) / 2
        }
        
        inputCaret.frame.origin.y = textView.frame.origin.y
        inputCaret.frame.size.height = textView.frame.size.height
    }
    
}
