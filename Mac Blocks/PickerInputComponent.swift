//
//  PickerInputComponent.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/6/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

// The equivalent of a dropdown menu
class PickerInputComponent: UserInputComponent {
    
    let label: NSTextField = NSTextField()
    let picker: CustomPicker = CustomPicker()
    let miniCell: MiniPopUpButtonCell = MiniPopUpButtonCell()
    
    var changeTarget: AnyObject?
    var changeHandler: Selector?
    
    var currentValue: String {
        get {
            return picker.titleOfSelectedItem ?? ""
        }
    }
    
    init(options: [String]) {
        super.init()
        
        picker.cell = miniCell
        
        picker.bezelStyle = NSButton.BezelStyle.regularSquare
        picker.isBordered = false
        
        (picker.cell as! NSPopUpButtonCell).arrowPosition = NSPopUpButton.ArrowPosition.arrowAtBottom
        
        picker.alphaValue = 0
        
        picker.target = self
        picker.action = #selector(PickerInputComponent.changed)
        
        for option: String in options {
            picker.addItem(withTitle: option)
        }
        
        label.isEditable = false
        label.isBordered = false
        label.isSelectable = false
        label.backgroundColor = NSColor.clear
        label.font = Block.FONT
        label.textColor = BlockColor.darkTextColor
        
        addSubview(picker)
        addSubview(label)
        
        label.stringValue = picker.title
        
        fillColor = NSColor(white: 1, alpha: 0.9)
    }
    
    convenience init(options: String...) {
        self.init(options: options)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func openMenu() {
        picker.performClick(nil)
    }
    
    @objc internal func changed() {
        if changeTarget != nil && changeHandler != nil {
            let _ = changeTarget!.perform(changeHandler!)
        }
        
        layoutFullObjectHierarchy()
    }
    
    override func updateStyle() {
        super.updateStyle()
        
        label.font = Block.FONT
    }
    
    override func redraw() {
        super.redraw()
        
        if Block.blockStyle == Block.BlockStyle.rounded {
            styleLayer.path = CGPath(roundedRect: bounds, cornerWidth: 2, cornerHeight: 2, transform: nil)
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
    }
    
    override func layoutObject() {
        label.stringValue = "\(picker.title) ▾"
        label.sizeToFit()
        
        var labelSize: CGSize = label.stringValue.size(withAttributes: [NSAttributedStringKey.font: label.font!])
        
        let dw: CGFloat = label.frame.size.width  - labelSize.width
        
        label.frame.origin.x = -dw / 2
        label.frame.origin.y = 1.5
        
        label.frame.origin.x += 6

        picker.frame.size = labelSize
        labelSize.width += 12
        
        frame.size = labelSize
        
        super.layoutObject()
    }
    
}
