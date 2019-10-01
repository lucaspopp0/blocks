//
//  ListBlock.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/20/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

class ListBlock: Block {
    
    override var blockDescription: String {
        get {
            return "Creates and outputs a list of items."
        }
    }
    
    var numberOfItems: Int = 0
    
    var itemsLabel: NSTextField = NSTextField(labelWithString: "Items")
    let itemsCounter: NSTextField = NSTextField(labelWithString: "0")
    let itemsStepper: NSStepper = NSStepper()
    
    required init(origin: CGPoint = CGPoint.zero) {
        super.init(origin: origin)
        
        outputType = DataType.list
        
        fillColor = BlockColor.listColor
        textColor = BlockColor.lightTextColor
        
        itemsStepper.increment = 1
        itemsStepper.minValue = 0
        itemsStepper.target = self
        itemsStepper.action = #selector(ListBlock.updateNumberOfItems)
        itemsStepper.valueWraps = false
        
        itemsCounter.alignment = NSTextAlignment.right
        
        let line: BlockLine = BlockLine()
        let textComponent: TextComponent = TextComponent(text: "empty list")
        line.fullWidth = true
        
        line.addComponent(textComponent)
        addLine(line)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func updateNumberOfItems() {
        numberOfItems = Int(round(itemsStepper.doubleValue))
        itemsCounter.stringValue = "\(numberOfItems)"
        
        updateBlock()
    }
    
    @discardableResult override func evaluate() -> Any? {
        let output: DataList = DataList()
        
        for line: BlockLine in lines {
            for component: BlockComponent in line.components {
                if component is SlotInputComponent {
                    let slot: SlotInputComponent = component as! SlotInputComponent
                    
                    if slot.input != nil {
                        let inputEvaluated: Any? = slot.input!.evaluate()
                        
                        if inputEvaluated != nil {
                            output.items.append(inputEvaluated!)
                        }
                    } else {
                        workspace?.console.error(message: "Item in list left empty.", sourceBlock: self)
                    }
                }
            }
        }
        
        return output
    }
    
    override func duplicate() -> Block {
        let newBlock: ListBlock = ListBlock()
        
        newBlock.numberOfItems = numberOfItems
        
        newBlock.updateBlock()
        
        return newBlock
    }
    
    override func typeRelatedProperties() -> NSMutableDictionary {
        let properties: NSMutableDictionary = super.typeRelatedProperties()
        
        properties.setValue(numberOfItems, forKey: "numberOfItems")
        
        return properties
    }
    
    override func applyTypeRelatedProperties(_ data: NSDictionary) {
        if DataManager.dictionary(dictionary: data, hasValueForKey: "numberOfItems") {
            numberOfItems = data.value(forKey: "numberOfItems") as! Int
            
            updateBlock()
        }
    }
    
    override func updateBlock() {
        var slotBlocks: [Block?] = []
        
        for line: BlockLine in lines {
            for component: BlockComponent in line.components {
                if component is SlotInputComponent {
                    slotBlocks.append((component as! SlotInputComponent).input)
                }
            }
        }
        
        while lines.count > 0 {
            removeLine(lines.first!)
        }
        
        if numberOfItems == 0 {
            let line: BlockLine = BlockLine()
            let textComponent: TextComponent = TextComponent(text: "empty list")
            line.fullWidth = true
            
            line.addComponent(textComponent)
            addLine(line)
        } else {
            let firstLine: BlockLine = BlockLine()
            let textComponent: TextComponent = TextComponent(text: "new list with")
            firstLine.fullWidth = true
            
            firstLine.addComponent(textComponent)
            addLine(firstLine)
            
            for i in 0 ..< numberOfItems {
                let newLine: BlockLine = BlockLine()
                let newComp: SlotInputComponent = SlotInputComponent()
                
                newLine.fullWidth = true
                newComp.alignment = BlockComponent.Alignment.right
                
                newLine.addComponent(newComp)
                addLine(newLine)
                
                if i < slotBlocks.count && slotBlocks[i] != nil {
                    newComp.connectInput(slotBlocks[i]!)
                }
            }
        }
        
        layoutFullObjectHierarchy()
    }
    
    override func numberOfRows(inRowView rowView: RowView) -> Int {
        return 1
    }
    
    override func viewFor(row: Int, inRowView rowView: RowView) -> NSView? {
        let genericView: NSView = NSView()
        
        if row == 0 {
            genericView.addSubview(itemsLabel)
            genericView.addSubview(itemsStepper)
            genericView.addSubview(itemsCounter)
            
            itemsLabel.frame = CGRect(x: 10, y: (heightOf(row: row, inRowView: rowView) - itemsLabel.frame.size.height) / 2, width: rowView.bounds.size.width - 20, height: itemsLabel.frame.size.height)
            itemsStepper.frame.size = CGSize(width: 19, height: 27)
            itemsStepper.frame = CGRect(x: rowView.frame.size.width - 10 - itemsStepper.frame.size.width, y: (heightOf(row: row, inRowView: rowView) - itemsStepper.frame.size.height) / 2, width: itemsStepper.frame.size.width, height: itemsStepper.frame.size.height)
            
            itemsCounter.sizeToFit()
            itemsCounter.frame = CGRect(x: 10, y: (heightOf(row: row, inRowView: rowView) - itemsCounter.frame.size.height) / 2, width: itemsStepper.frame.origin.x - 10 - 5, height: itemsCounter.frame.size.height)
        }
        
        return genericView
    }
    
}
