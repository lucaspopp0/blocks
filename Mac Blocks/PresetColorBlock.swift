//
//  PresetColorBlock.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 5/2/17.
//  Copyright © 2017 Lucas Popp. All rights reserved.
//

import Cocoa

class PresetColorBlock: Block {
    
    override var blockDescription: String {
        get {
            return "Outputs a preset color value."
        }
    }
    
    var color: NSColor = NSColor.red {
        didSet {
            colorComponent.fillColor = color
        }
    }
    
    let colorComponent: ColorComponent = ColorComponent(color: NSColor.red)
    let pickerComponent: PickerInputComponent = PickerInputComponent(options: "red", "orange", "yellow", "green", "blue", "purple")
    
    let colors: [NSColor] = [NSColor.red, NSColor.orange, NSColor.yellow, NSColor.green, NSColor.blue, NSColor.purple]
    
    required init(origin: CGPoint = CGPoint.zero) {
        super.init(origin: origin)
        
        let l1: BlockLine = BlockLine()
        
        l1.addComponents(colorComponent, pickerComponent)
        
        addLine(l1)
        
        outputType = DataType.color
        
        fillColor = BlockColor.colorColor
        textColor = BlockColor.lightTextColor
        
        pickerComponent.changeTarget = self
        pickerComponent.changeHandler = #selector(PresetColorBlock.colorChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult override func evaluate() -> Any? {
        return color
    }
    
    @objc func colorChanged() {
        color = colors[pickerComponent.picker.indexOfSelectedItem]
    }
    
    override func duplicate() -> Block {
        let newBlock: PresetColorBlock = PresetColorBlock()
        
        return newBlock
    }
    
    override func applyTypeRelatedProperties(_ data: NSDictionary) {
//        if DataManager.dictionary(dictionary: data, hasValueForKey: "hexValue") {
//            color = NSColor(hex: data.value(forKey: "hexValue") as! String)
//        }
    }
    
    override func typeRelatedProperties() -> NSMutableDictionary {
        let properties: NSMutableDictionary = super.typeRelatedProperties()
        
//        properties.setValue(hexInput.textField.stringValue, forKey: "hexValue")
        
        return properties
    }
    
}
