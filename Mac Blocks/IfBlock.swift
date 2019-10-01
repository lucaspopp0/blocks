//
//  IfBlock.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/7/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

class IfBlock: Block {
    
    override var blockDescription: String {
        get {
            return "Runs a block of code if a condition is true."
        }
    }
    
    let conditionInput: SlotInputComponent = SlotInputComponent(placeholder: "this is true", allowedInputTypes: DataType.boolean)
    let chunkLine: ChunkInputLine = ChunkInputLine(placeholder: "do this")
    
    var elseIfClauses: Int = 0
    var elseClause: Bool = false
    
    let elseIfLabel: NSTextField = NSTextField(labelWithString: "Extra clauses")
    let elseIfCounter: NSTextField = NSTextField(labelWithString: "0")
    let elseIfStepper: NSStepper = NSStepper()
    let elseLabel: NSTextField = NSTextField(labelWithString: "Else clause")
    let elseToggle: NSSegmentedControl = NSSegmentedControl(labels: ["Enabled", "Disabled"], trackingMode: NSSegmentedControl.SwitchTracking.selectOne, target: nil, action: nil)
    
    required init(origin: CGPoint = CGPoint.zero) {
        super.init(origin: origin)
        
        let l1: BlockLine = BlockLine()
        l1.addComponents(TextComponent(text: "if"), conditionInput)
        
        upperConnection.enabled = true
        lowerConnection.enabled = true
        
        addLines(l1, chunkLine)
        
        fillColor = BlockColor.logicColor
        textColor = BlockColor.lightTextColor
        
        elseIfStepper.increment = 1
        elseIfStepper.minValue = 0
        elseIfStepper.target = self
        elseIfStepper.action = #selector(IfBlock.updateElseIfClauses)
        elseIfStepper.valueWraps = false
        
        elseIfCounter.alignment = NSTextAlignment.right
        
        elseToggle.selectedSegment = 1
        elseToggle.target = self
        elseToggle.action = #selector(IfBlock.updateElseClause)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func updateElseIfClauses() {
        elseIfClauses = Int(round(elseIfStepper.doubleValue))
        elseIfCounter.stringValue = "\(elseIfClauses)"
        
        updateBlock()
    }
    
    @objc func updateElseClause() {
        elseClause = elseToggle.selectedSegment == 0
        
        updateBlock()
    }
    
    @discardableResult override func evaluate() -> Any? {
        var slotInputHeads: [Block?] = []
        var chunkInputHeads: [Block?] = []
        
        for line: BlockLine in lines {
            for component: BlockComponent in line.components {
                if component is SlotInputComponent {
                    slotInputHeads.append((component as! SlotInputComponent).input)
                } else if component is ChunkInputComponent {
                    chunkInputHeads.append((component as! ChunkInputComponent).anchor.connectedTo as? Block)
                }
            }
        }
        
        var evaluated: Bool = false
        
        for i in 0 ..< slotInputHeads.count {
            if slotInputHeads[i] != nil {
                let slotEvaluated: Any? = slotInputHeads[i]!.evaluate()
                
                if slotEvaluated != nil && DataType.valueIsBoolean(value: slotEvaluated) {
                    if DataType.valueAsBoolean(value: slotEvaluated)! {
                        evaluated = true
                        let _ = chunkInputHeads[i]?.evaluate()
                        break
                    }
                }
            } else {
                workspace?.console.error(message: "A slot for the condition to check was left empty.", sourceBlock: self)
            }
        }
        
        if elseClause && !evaluated {
            let _ = chunkInputHeads.last!?.evaluate()
        }
        
        super.evaluate()
        
        return nil
    }
    
    override func duplicate() -> Block {
        let newBlock: IfBlock = IfBlock()
        
        newBlock.elseIfClauses = elseIfClauses
        newBlock.elseClause = elseClause
        
        newBlock.updateBlock()
        
        return newBlock
    }
    
    override func typeRelatedProperties() -> NSMutableDictionary {
        let properties: NSMutableDictionary = super.typeRelatedProperties()
        
        properties.setValue(elseIfClauses, forKey: "elseIfClauses")
        properties.setValue(elseClause, forKey: "elseClause")
        
        return properties
    }
    
    override func applyTypeRelatedProperties(_ data: NSDictionary) {
        if DataManager.dictionary(dictionary: data, hasValuesForKeys: "elseIfClauses", "elseClause") {
            elseIfClauses = data.value(forKey: "elseIfClauses") as! Int
            elseClause = data.value(forKey: "elseClause") as! Bool
            
            updateBlock()
        }
    }
    
    override func updateBlock() {
        var conditionalBlocks: [Block?] = []
        var chunkBlocks: [Block?] = []
        
        for line: BlockLine in lines {
            for component: BlockComponent in line.components {
                if component is SlotInputComponent {
                    conditionalBlocks.append((component as! SlotInputComponent).input)
                    (component as! SlotInputComponent).disconnectInput()
                } else if component is ChunkInputComponent {
                    chunkBlocks.append((component as! ChunkInputComponent).anchor.connectedTo as? Block)
                    
                    if (component as! ChunkInputComponent).anchor.connectedTo as? Block != nil {
                        ((component as! ChunkInputComponent).anchor.connectedTo as! Block).disconnectUpperConnection()
                    }
                }
            }
        }
        
        while lines.count > 0 {
            removeLine(lines.first!)
        }
        
        let ifLine: BlockLine = BlockLine()
        ifLine.addComponents(TextComponent(text: "if"), conditionInput)
        
        addLines(ifLine, chunkLine)
        
        for _ in 0 ..< elseIfClauses {
            let elseIfLine: BlockLine = BlockLine()
            let slot: SlotInputComponent = SlotInputComponent(placeholder: "this is true", allowedInputTypes: DataType.boolean)
            
            elseIfLine.addComponents(TextComponent(text: "otherwise if"), slot)
            addLines(elseIfLine, ChunkInputLine(placeholder: "do this"))
        }
        
        if elseClause {
            let elseLine: BlockLine = BlockLine()
            elseLine.addComponent(TextComponent(text: "otherwise"))
            
            addLines(elseLine, ChunkInputLine(placeholder: "do this"))
        }
        
        var inputIndex: Int = 0
        var breakAll: Bool = false
        
        for line: BlockLine in lines {
            for component: BlockComponent in line.components {
                if component is SlotInputComponent {
                    if conditionalBlocks[inputIndex] != nil {
                        (component as! SlotInputComponent).connectInput(conditionalBlocks[inputIndex]!)
                    }
                    
                    inputIndex += 1
                    
                    if !(inputIndex < conditionalBlocks.count) {
                        breakAll = true
                        break
                    }
                }
            }
            
            if breakAll {
                break
            }
        }
        
        var chunkIndex: Int = 0
        breakAll = false
        
        for line: BlockLine in lines {
            for component: BlockComponent in line.components {
                if component is ChunkInputComponent {
                    if chunkBlocks[chunkIndex] != nil {
                        chunkBlocks[chunkIndex]!.formUpperConnection(toChunkInput: component as! ChunkInputComponent)
                    }
                    
                    chunkIndex += 1
                    
                    if !(chunkIndex < chunkBlocks.count) {
                        breakAll = true
                        break
                    }
                }
            }
            
            if breakAll {
                break
            }
        }
        
        layoutFullObjectHierarchy()
    }
    
    override func numberOfRows(inRowView rowView: RowView) -> Int {
        return 2
    }
    
    override func viewFor(row: Int, inRowView rowView: RowView) -> NSView? {
        let genericView: NSView = NSView()
        
        if row == 0 {
            genericView.addSubview(elseIfLabel)
            genericView.addSubview(elseIfStepper)
            genericView.addSubview(elseIfCounter)
            
            elseIfLabel.frame = CGRect(x: 10, y: (heightOf(row: row, inRowView: rowView) - elseIfLabel.frame.size.height) / 2, width: rowView.bounds.size.width - 20, height: elseIfLabel.frame.size.height)
            elseIfStepper.frame.size = CGSize(width: 19, height: 27)
            elseIfStepper.frame = CGRect(x: rowView.frame.size.width - 10 - elseIfStepper.frame.size.width, y: (heightOf(row: row, inRowView: rowView) - elseIfStepper.frame.size.height) / 2, width: elseIfStepper.frame.size.width, height: elseIfStepper.frame.size.height)
            
            elseIfCounter.sizeToFit()
            elseIfCounter.frame = CGRect(x: 10, y: (heightOf(row: row, inRowView: rowView) - elseIfCounter.frame.size.height) / 2, width: elseIfStepper.frame.origin.x - 10 - 5, height: elseIfCounter.frame.size.height)
        } else if row == 1 {
            genericView.addSubview(elseLabel)
            genericView.addSubview(elseToggle)
            
            elseLabel.frame = CGRect(x: 10, y: (heightOf(row: row, inRowView: rowView) - elseLabel.frame.size.height) / 2, width: rowView.bounds.size.width - 20, height: elseLabel.frame.size.height)
            
            elseToggle.frame = CGRect(x: rowView.bounds.size.width - 10 - elseToggle.frame.size.width, y: (heightOf(row: row, inRowView: rowView) - elseToggle.frame.size.height) / 2, width: elseToggle.frame.size.width, height: elseToggle.frame.size.height)
        }
        
        return genericView
    }
    
}
