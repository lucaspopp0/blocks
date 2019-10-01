//
//  ConcatenateTextBlock.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 5/12/17.
//  Copyright © 2017 Lucas Popp. All rights reserved.
//

import Cocoa

class ConcatenateTextBlock: Block {
    
    override var blockDescription: String {
        get {
            return "Combines a number of values into a string."
        }
    }
    
    var numberOfItems: Int = 2
    
    let itemsLabel: NSTextField = NSTextField(labelWithString: "Number of items")
    let itemsCountLabel: NSTextField = NSTextField(labelWithString: "2")
    let itemsStepper: NSStepper = NSStepper()    

    required init(origin: CGPoint = CGPoint.zero) {
        super.init(origin: origin)
        
        outputType = DataType.string
        
        let l1: BlockLine = BlockLine()
        
        for _ in 0 ..< numberOfItems {
            l1.addComponent(SlotInputComponent(allowedInputTypes: DataType.any))
        }
        
        addLine(l1)
        
        itemsStepper.floatValue = Float(numberOfItems)
        itemsCountLabel.stringValue = "\(numberOfItems)"
        
        itemsStepper.increment = 1
        itemsStepper.minValue = 2
        itemsStepper.target = self
        itemsStepper.action = #selector(ConcatenateTextBlock.updateNumberOfItems(sender:))
        itemsStepper.valueWraps = false
        
        itemsCountLabel.alignment = NSTextAlignment.right
        
        fillColor = BlockColor.textColor
        textColor = BlockColor.lightTextColor
        
        updateNumberOfItems(sender: itemsStepper)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func updateNumberOfItems(sender: NSStepper) {
        numberOfItems = Int(sender.floatValue)
        itemsCountLabel.stringValue = "\(numberOfItems)"
        
        updateBlock()
    }
    
    @discardableResult override func evaluate() -> Any? {
        var items: [Block?] = []
        
        for component: BlockComponent in lines[0].components {
            if let slot: SlotInputComponent = component as? SlotInputComponent {
                items.append(slot.input)
            }
        }
        
        var output: String = ""
        
        for item: Block? in items {
            if let realItem: Block = item {
                if let evaluated: Any = realItem.evaluate() {
                    output = "\(output)\(evaluated)"
                } else {
                    workspace?.console.error(message: "Item in string concatenation evaluated to nil.", sourceBlock: self)
                }
            } else {
                workspace?.console.error(message: "Slot left blank", sourceBlock: self)
            }
        }
        
        return output
    }
    
    override func duplicate() -> Block {
        fatalError("Still need to implement duplicate() on ConcatenateTextBlock")
    }
    
    override func typeRelatedProperties() -> NSMutableDictionary {
        let properties: NSMutableDictionary = super.typeRelatedProperties()
        
        properties.setValue(numberOfItems, forKey: "numberOfItems")
        
        return properties
    }
    
    override func applyTypeRelatedProperties(_ data: NSDictionary) {
        if DataManager.dictionary(dictionary: data, hasValuesForKeys: "numberOfItems") {
            numberOfItems = data.value(forKey: "numberOfItems") as! Int
            
            updateBlock()
        }
    }
    
    override func updateBlock() {
        var items: [Block?] = []
        
        for component in lines[0].components {
            if let slot: SlotInputComponent = component as? SlotInputComponent {
                items.append(slot.input)
            }
        }
        
        while lines[0].components.count > 0 {
            lines[0].removeComponent(lines[0].components[0])
        }
        
        lines[0].addComponent(TextComponent(text: "\""))
        
        for i in 0 ..< numberOfItems {
            let newSlot: SlotInputComponent = SlotInputComponent()
            lines[0].addComponent(newSlot)
            
            if items.count > i && items[i] != nil {
                newSlot.connectInput(items[i]!)
            }
        }
        
        lines[0].addComponent(TextComponent(text: "\""))
        
        layoutFullObjectHierarchy()
    }
    
    override func numberOfRows(inRowView rowView: RowView) -> Int {
        return 1
    }
    
    override func viewFor(row: Int, inRowView rowView: RowView) -> NSView? {
        let genericView: NSView = NSView()
        
        if row == 0 {
            genericView.addSubview(itemsLabel)
            genericView.addSubview(itemsCountLabel)
            genericView.addSubview(itemsStepper)
            
            itemsLabel.frame = CGRect(x: 10, y: (heightOf(row: row, inRowView: rowView) - itemsLabel.frame.size.height) / 2, width: itemsLabel.frame.size.width, height: itemsLabel.frame.size.height)
            
            itemsStepper.frame.size = CGSize(width: 19, height: 27)
            itemsStepper.frame = CGRect(x: rowView.frame.size.width - 10 - itemsStepper.frame.size.width, y: (heightOf(row: row, inRowView: rowView) - itemsStepper.frame.size.height) / 2, width: itemsStepper.frame.size.width, height: itemsStepper.frame.size.height)
            
            itemsCountLabel.sizeToFit()
            itemsCountLabel.frame = CGRect(x: 10, y: (heightOf(row: row, inRowView: rowView) - itemsCountLabel.frame.size.height) / 2, width: itemsStepper.frame.origin.x - 14, height: itemsCountLabel.frame.size.height)
            
            return genericView
        }
        
        return nil
    }
}
