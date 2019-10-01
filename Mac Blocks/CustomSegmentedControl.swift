//
//  CustomSegmentedControl.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 5/5/17.
//  Copyright © 2017 Lucas Popp. All rights reserved.
//

import Cocoa

class CustomSegmentedControl: NSControl {
    
    private var buttons: [NSButton] = []
    private var separators: [NSBox] = []
    
    var titles: [String] = []
    
    var selectedIndex: Int? = nil {
        didSet {
            updateSelection()
        }
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        unifiedInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        unifiedInit()
    }
    
    func unifiedInit() {
        translatesAutoresizingMaskIntoConstraints = false
        
        positionButtons()
    }
    
    private func updateSelection() {
        for button in buttons {
            button.state = NSControl.StateValue.off
        }
        
        if buttons.count > 0 && selectedIndex != nil {
            buttons[selectedIndex!].state = NSControl.StateValue.on
        }
    }
    
    func addSegment(withTitle title: String, at index: Int = -1) {
        if index == -1 {
            titles.append(title)
        } else {
            titles.insert(title, at: index)
        }
        
        positionButtons()
        updateSelection()
    }
    
    func setTitle(title: String, ofSegment segment: Int) {
        buttons[segment].title = title
    }
    
    private func positionButtons() {
        while buttons.count > 0 {
            buttons.removeFirst().removeFromSuperview()
        }
        
        while separators.count > 0 {
            separators.removeFirst().removeFromSuperview()
        }
        
        for title: String in titles {
            let newButton: NSButton = NSButton(title: title, target: self, action: #selector(CustomSegmentedControl.handleSegmentPress(_:)))
            newButton.setButtonType(NSButton.ButtonType.toggle)
            newButton.bezelStyle = NSButton.BezelStyle.regularSquare
            newButton.isBordered = false
            newButton.translatesAutoresizingMaskIntoConstraints = false
            
            addSubview(newButton)
            
            buttons.append(newButton)
        }
        
        for i in 0 ..< buttons.count {
            if i < buttons.count - 1 {
                let newSeparator: NSBox = NSBox()
                newSeparator.boxType = NSBox.BoxType.separator
                newSeparator.translatesAutoresizingMaskIntoConstraints = false
                
                separators.append(newSeparator)
                addSubview(newSeparator)
                
                addConstraint(NSLayoutConstraint(item: newSeparator, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 1))
                
                addConstraint(NSLayoutConstraint(item: newSeparator, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0))
                addConstraint(NSLayoutConstraint(item: newSeparator, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0))
                
                addConstraint(NSLayoutConstraint(item: newSeparator, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: buttons[i], attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0))
                addConstraint(NSLayoutConstraint(item: newSeparator, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: buttons[i + 1], attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0))
            }
            
            addConstraint(NSLayoutConstraint(item: buttons[i], attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 4))
            addConstraint(NSLayoutConstraint(item: buttons[i], attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: -4))
            
            addConstraint(NSLayoutConstraint(item: buttons[i], attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: (frame.size.width - CGFloat(buttons.count - 1)) / CGFloat(buttons.count)))
            
            if i == 0 {
                addConstraint(NSLayoutConstraint(item: buttons[i], attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0))
            }
            
            if i == buttons.count - 1 {
                addConstraint(NSLayoutConstraint(item: buttons[i], attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0))
            }
        }
        
        updateSelection()
    }
    
    func setEnabled(segment: Int, enabled: Bool) {
        buttons[segment].isEnabled = enabled
    }
    
    func isEnabled(segment: Int) -> Bool {
        return buttons[segment].isEnabled
    }
    
    @objc private func handleSegmentPress(_ sender: NSButton) {
        if let index: Int = buttons.index(of: sender) {
            selectedIndex = index
            
            sendAction(action, to: target)
        }
    }
    
    override func resizeSubviews(withOldSize oldSize: NSSize) {
        super.resizeSubviews(withOldSize: oldSize)
        
        positionButtons()
    }
    
}
