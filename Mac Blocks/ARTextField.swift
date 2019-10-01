//
//  ARTextField.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/24/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

// A text field that resizes automatically based on its text
class ARTextField: NSTextField {
    
    var resizeTarget: AnyObject?
    var resizeAction: Selector?
    
    var editingEndedTarget: AnyObject?
    var editingEndedAction: Selector?
    
    override var intrinsicContentSize: NSSize {
        get {
            return super.intrinsicContentSize
        }
    }
    
    override init(frame frameRect: NSRect = NSRect.zero) {
        super.init(frame: frameRect)
        
        target = self
        action = #selector(ARTextField.loseFocus)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc internal func loseFocus() {
        window?.makeFirstResponder(superview)
    }
    
    override func textDidChange(_ notification: Notification) {
        super.textDidChange(notification)
        
        invalidateIntrinsicContentSize()
        
        if resizeTarget != nil && resizeAction != nil {
            let _ = resizeTarget!.perform(resizeAction!)
        }
    }
    
    override func textDidEndEditing(_ notification: Notification) {
        super.textDidEndEditing(notification)
        
        if editingEndedTarget != nil && editingEndedAction != nil {
            let _ = editingEndedTarget!.perform(editingEndedAction!)
        }
    }
}
