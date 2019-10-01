//
//  RandomBetweenBlock.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/9/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

class RandomBetweenBlock: Block {
    
    override var blockDescription: String {
        get {
            return "Outputs a random number from within a range."
        }
    }
    
    let picker: PickerInputComponent = PickerInputComponent(options: "integer", "number")
    let lowerBound: SlotInputComponent = SlotInputComponent(doubleClickData: NumberInputBlock().dictionaryValue(), allowedInputTypes: DataType.number)
    let upperBound: SlotInputComponent = SlotInputComponent(doubleClickData: NumberInputBlock().dictionaryValue(), allowedInputTypes: DataType.number)
    
    required init(origin: CGPoint = CGPoint.zero) {
        super.init(origin: origin)
        
        outputType = DataType.number
        
        let l1: BlockLine = BlockLine()
        
        l1.addComponents(TextComponent(text: "random"), picker, TextComponent(text: "between"), lowerBound, TextComponent(text: "and"), upperBound)
        
        addLine(l1)
        
        fillColor = BlockColor.mathColor
        textColor = BlockColor.lightTextColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult override func evaluate() -> Any? {
        if lowerBound.input != nil && upperBound.input != nil {
            var lowerNumber: Double? = DataType.valueAsDouble(value: lowerBound.input!.evaluate())
            var upperNumber: Double? = DataType.valueAsDouble(value: upperBound.input!.evaluate())
            
            if lowerNumber != nil && upperNumber != nil {
                if picker.currentValue == "number" {
                    return lowerNumber! + (drand48() * (upperNumber! - lowerNumber!))
                } else if picker.currentValue == "integer" {
                    if lowerNumber! < upperNumber! {
                        lowerNumber = ceil(lowerNumber!)
                        upperNumber = floor(upperNumber!)
                    } else if lowerNumber! > upperNumber! {
                        lowerNumber = floor(lowerNumber!)
                        upperNumber = ceil(upperNumber!)
                    } else {
                        lowerNumber = ceil(lowerNumber!)
                        upperNumber = floor(upperNumber!)
                    }
                    
                    if lowerNumber! <= upperNumber! {
                        return round(lowerNumber! + (drand48() * (upperNumber! - lowerNumber!)))
                    }
                }
            }
        } else {
            if lowerBound.input == nil {
                workspace?.console.error(message: "Didn't specify a lower bound.", sourceBlock: self)
            }
            
            if upperBound.input == nil {
                workspace?.console.error(message: "Didn't specify a upper bound.", sourceBlock: self)
            }
        }
        
        return nil
    }
    
    override func duplicate() -> Block {
        let newBlock: RandomBetweenBlock = RandomBetweenBlock()
        
        newBlock.picker.picker.selectItem(at: picker.picker.indexOfSelectedItem)
        
        return newBlock
    }
    
    override func applyTypeRelatedProperties(_ data: NSDictionary) {
        if DataManager.dictionary(dictionary: data, hasValueForKey: "numberType") {
            picker.picker.selectItem(withTitle: data.value(forKey: "numberType") as! String)
        }
    }
    
    override func typeRelatedProperties() -> NSMutableDictionary {
        let properties: NSMutableDictionary = super.typeRelatedProperties()
        
        properties.setValue(picker.currentValue, forKey: "numberType")
        
        return properties
    }
    
}
