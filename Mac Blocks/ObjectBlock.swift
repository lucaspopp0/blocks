//
//  ObjectBlock.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/22/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

class ObjectBlock: Block {
    
    override var blockDescription: String {
        get {
            return "Outputs an object, with named properties."
        }
    }
    
    var numberOfProperties: Int = 0
    
    var propertiesLabel: NSTextField = NSTextField(labelWithString: "Properties")
    let propertiesCounter: NSTextField = NSTextField(labelWithString: "0")
    let propertiesStepper: NSStepper = NSStepper()
    
    required init(origin: CGPoint = CGPoint.zero) {
        super.init(origin: origin)
        
        outputType = DataType.object
        
        propertiesStepper.increment = 1
        propertiesStepper.minValue = 0
        propertiesStepper.target = self
        propertiesStepper.action = #selector(ObjectBlock.updateNumberOfProperties)
        propertiesStepper.valueWraps = false
        
        propertiesCounter.alignment = NSTextAlignment.right
        
        let line: BlockLine = BlockLine()
        let textComponent: TextComponent = TextComponent(text: "empty object")
        
        line.addComponent(textComponent)
        addLine(line)
        
        fillColor = BlockColor.objectColor
        textColor = BlockColor.lightTextColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func updateNumberOfProperties() {
        numberOfProperties = Int(round(propertiesStepper.doubleValue))
        propertiesCounter.stringValue = "\(numberOfProperties)"
        
        updateBlock()
    }
    
    @discardableResult override func evaluate() -> Any? {
        let output: DataObject = DataObject()
        
        for line: BlockLine in lines {
            var propertyName: String?
            var propertyValue: Any?
            
            for component: BlockComponent in line.components {
                if component is SlotInputComponent {
                    let slot: SlotInputComponent = component as! SlotInputComponent
                    
                    if slot.input != nil {
                        let inputEvaluated: Any? = slot.input!.evaluate()
                        
                        if propertyName == nil {
                            if inputEvaluated != nil {
                                if DataType.valueIsString(value: inputEvaluated!) {
                                    propertyName = DataType.valueAsString(value: inputEvaluated!)
                                }
                            } else {
                                workspace?.console.error(message: "Couldn't determine a property name.", sourceBlock: self)
                            }
                        } else if propertyValue == nil {
                            propertyValue = inputEvaluated
                        }
                    } else {
                        if propertyName == nil {
                            workspace?.console.error(message: "Didn't provide a property name.", sourceBlock: self)
                        }
                    }
                }
            }
            
            if propertyName != nil && propertyValue != nil {
                output.object[propertyName!] = propertyValue!
            }
        }
        
        return output
    }
    
    override func duplicate() -> Block {
        let newBlock: ObjectBlock = ObjectBlock()
        
        newBlock.numberOfProperties = numberOfProperties
        
        newBlock.updateBlock()
        
        return newBlock
    }
    
    override func typeRelatedProperties() -> NSMutableDictionary {
        let properties: NSMutableDictionary = super.typeRelatedProperties()
        
        properties.setValue(numberOfProperties, forKey: "numberOfProperties")
        
        return properties
    }
    
    override func applyTypeRelatedProperties(_ data: NSDictionary) {
        if DataManager.dictionary(dictionary: data, hasValueForKey: "numberOfProperties") {
            numberOfProperties = data.value(forKey: "numberOfProperties") as! Int
            
            updateBlock()
        }
    }
    
    override func updateBlock() {
        for line: BlockLine in lines {
            removeLine(line)
        }
        
        if numberOfProperties == 0 {
            let l1: BlockLine = BlockLine()
            let c1: TextComponent = TextComponent(text: "empty object")
            l1.fullWidth = true
            
            l1.addComponent(c1)
            addLine(l1)
        } else {
            let l1: BlockLine = BlockLine()
            let l2: BlockLine = BlockLine()
            l1.fullWidth = true
            l2.fullWidth = true
            
            let titleComponent: TextComponent = TextComponent(text: "new object with")
            let propertyComponent: TextLabelComponent = TextLabelComponent(text: "PROPERTY")
            let valueComponent: TextLabelComponent = TextLabelComponent(text: "VALUE")
            
            valueComponent.alignment = BlockComponent.Alignment.right
            
            l1.addComponent(titleComponent)
            addLine(l1)
            
            l2.addComponents(propertyComponent, valueComponent)
            addLine(l2)
            
            for _ in 0 ..< numberOfProperties {
                let newLine: BlockLine = BlockLine()
                let propertyInput: SlotInputComponent = SlotInputComponent(doubleClickData: TextInputBlock().dictionaryValue(), allowedInputTypes: DataType.string)
                let propertyValue: SlotInputComponent = SlotInputComponent()
                newLine.fullWidth = true
                
                propertyValue.alignment = BlockComponent.Alignment.right
                
                newLine.addComponents(propertyInput, propertyValue)
                addLine(newLine)
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
            genericView.addSubview(propertiesLabel)
            genericView.addSubview(propertiesStepper)
            genericView.addSubview(propertiesCounter)
            
            propertiesLabel.frame = CGRect(x: 10, y: (heightOf(row: row, inRowView: rowView) - propertiesLabel.frame.size.height) / 2, width: rowView.bounds.size.width - 20, height: propertiesLabel.frame.size.height)
            propertiesStepper.frame.size = CGSize(width: 19, height: 27)
            propertiesStepper.frame = CGRect(x: rowView.frame.size.width - 10 - propertiesStepper.frame.size.width, y: (heightOf(row: row, inRowView: rowView) - propertiesStepper.frame.size.height) / 2, width: propertiesStepper.frame.size.width, height: propertiesStepper.frame.size.height)
            
            propertiesCounter.sizeToFit()
            propertiesCounter.frame = CGRect(x: 10, y: (heightOf(row: row, inRowView: rowView) - propertiesCounter.frame.size.height) / 2, width: propertiesStepper.frame.origin.x - 10 - 5, height: propertiesCounter.frame.size.height)
        }
        
        return genericView
    }
    
}
