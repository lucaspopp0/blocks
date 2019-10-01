//
//  ColorBlock.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 5/2/17.
//  Copyright © 2017 Lucas Popp. All rights reserved.
//

import Cocoa

class ColorBlock: Block, NSTextFieldDelegate {
    
    override var blockDescription: String {
        get {
            return "Outputs a color."
        }
    }
    
    var color: NSColor = NSColor.white {
        didSet {
            if segmentedControl.selectedSegment == 0 {
                if let rgbColor: NSColor = color.usingColorSpace(NSColorSpace.sRGB) {
                    colorComponent.fillColor = color
                    hexInput.textField.stringValue = color.hexString
                    
                    sliders[0].floatValue = Float(rgbColor.redComponent)
                    sliders[1].floatValue = Float(rgbColor.greenComponent)
                    sliders[2].floatValue = Float(rgbColor.blueComponent)
                }
            } else if segmentedControl.selectedSegment == 1 {
                if let hsbColor: NSColor = color.usingColorSpaceName(NSColorSpaceName.calibratedRGB) {
                    colorComponent.fillColor = color
                    hexInput.textField.stringValue = color.hexString
                    
                    sliders[0].floatValue = Float(hsbColor.hueComponent)
                    sliders[1].floatValue = Float(hsbColor.saturationComponent)
                    sliders[2].floatValue = Float(hsbColor.brightnessComponent)
                }
            }
            
            updateLabels()
        }
    }
    
    let colorModeLabel: NSTextField = NSTextField(labelWithString: "Mode")
    let segmentedControl: NSSegmentedControl = NSSegmentedControl(labels: ["RGB", "HSB"], trackingMode: NSSegmentedControl.SwitchTracking.selectOne, target: nil, action: nil)
    
    let labels: [NSTextField] = [NSTextField(labelWithString: "R"), NSTextField(labelWithString: "G"), NSTextField(labelWithString: "B")]
    var sliders: [NSSlider] = []
    let numberLabels: [NSTextField] = [NSTextField(labelWithString: "255"), NSTextField(labelWithString: "255"), NSTextField(labelWithString: "255")]
    
    let colorComponent: ColorComponent = ColorComponent(color: NSColor.white)
    let hexInput: TextInputComponent = TextInputComponent(placeholder: "#FFFFFF")
    
    required init(origin: CGPoint = CGPoint.zero) {
        super.init(origin: origin)
        
        segmentedControl.target = self
        segmentedControl.action = #selector(ColorBlock.segmentSelected)
        
        let l1: BlockLine = BlockLine()
        
        l1.addComponents(colorComponent, hexInput)
        
        for _ in 1...3 {
            sliders.append(NSSlider(value: 1, minValue: 0, maxValue: 1, target: self, action: #selector(ColorBlock.sliderSlid(_:))))
        }
        
        var maxWidth: CGFloat = 0
        
        for label: NSTextField in labels {
            maxWidth = max(maxWidth, label.frame.size.width)
        }
        
        for label: NSTextField in labels {
            label.frame.size.width = maxWidth
        }
        
        for numberLabel: NSTextField in numberLabels {
            numberLabel.sizeToFit()
        }
        
        hexInput.textField.delegate = self
        
        outputType = DataType.color
        
        addLine(l1)
        
        segmentedControl.setSelected(true, forSegment: 0)
        
        fillColor = BlockColor.colorColor
        textColor = BlockColor.lightTextColor
        
        for slider: NSSlider in sliders {
            slider.floatValue = Float(drand48())
        }
        
        updateLabels()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult override func evaluate() -> Any? {
        return color
    }
    
    override func duplicate() -> Block {
        let newBlock: ColorBlock = ColorBlock()
        
        newBlock.color = color
        
        return newBlock
    }
    
    override func applyTypeRelatedProperties(_ data: NSDictionary) {
        if DataManager.dictionary(dictionary: data, hasValueForKey: "hexValue") {
            color = NSColor(hex: data.value(forKey: "hexValue") as! String)
        }
    }
    
    override func typeRelatedProperties() -> NSMutableDictionary {
        let properties: NSMutableDictionary = super.typeRelatedProperties()
        
        properties.setValue(hexInput.textField.stringValue, forKey: "hexValue")
        
        return properties
    }
    
    override func controlTextDidChange(_ obj: Notification) {
        if let textField: ARTextField = obj.object as? ARTextField {
            if textField === hexInput.textField {
                color = NSColor(hex: textField.stringValue)
            }
        }
    }
    
    override func updateBlock() {
        if segmentedControl.selectedSegment == 0 {
            color = NSColor(red: CGFloat(sliders[0].floatValue), green: CGFloat(sliders[1].floatValue), blue: CGFloat(sliders[2].floatValue), alpha: 1)
        } else if segmentedControl.selectedSegment == 1 {
            color = NSColor(calibratedHue: CGFloat(sliders[0].floatValue), saturation: CGFloat(sliders[1].floatValue), brightness: CGFloat(sliders[2].floatValue), alpha: 1)
        }
    }
    
    func updateLabels() {
        if segmentedControl.selectedSegment == 0 {
            for i in 0 ..< sliders.count {
                numberLabels[i].stringValue = "\(Int(sliders[i].floatValue * 255))"
            }
        } else if segmentedControl.selectedSegment == 1 {
            numberLabels[0].stringValue = "\(Int(sliders[0].floatValue * 360))"
            numberLabels[1].stringValue = "\(Int(sliders[1].floatValue * 100))"
            numberLabels[2].stringValue = "\(Int(sliders[2].floatValue * 100))"
        }
    }
    
    @objc func segmentSelected() {
        if segmentedControl.selectedSegment == 0 {
            labels[0].stringValue = "R"
            labels[1].stringValue = "G"
            labels[2].stringValue = "B"
            
            if let rgbColor: NSColor = color.usingColorSpace(NSColorSpace.sRGB) {
                sliders[0].floatValue = Float(rgbColor.redComponent)
                sliders[1].floatValue = Float(rgbColor.greenComponent)
                sliders[2].floatValue = Float(rgbColor.blueComponent)
            }
        } else if segmentedControl.selectedSegment == 1 {
            labels[0].stringValue = "H"
            labels[1].stringValue = "S"
            labels[2].stringValue = "B"
            
            if let hsbColor: NSColor = color.usingColorSpaceName(NSColorSpaceName.calibratedRGB) {
                sliders[0].floatValue = Float(hsbColor.hueComponent)
                sliders[1].floatValue = Float(hsbColor.saturationComponent)
                sliders[2].floatValue = Float(hsbColor.brightnessComponent)
            }
        }
        
        updateLabels()
    }
    
    @objc func sliderSlid(_ sender: NSSlider) {
        updateLabels()
        
        updateBlock()
    }
    
    override func numberOfRows(inRowView rowView: RowView) -> Int {
        return 4
    }
    
    override func viewFor(row: Int, inRowView rowView: RowView) -> NSView? {
        let view: NSView = NSView()
        
        if row == 0 {
            view.addSubview(segmentedControl)
            view.addSubview(colorModeLabel)
            
            colorModeLabel.sizeToFit()
            
            segmentedControl.frame = CGRect(x: rowView.frame.size.width - 10 - segmentedControl.frame.size.width, y: (heightOf(row: row, inRowView: rowView) - segmentedControl.frame.size.height) / 2, width: segmentedControl.frame.size.width, height: segmentedControl.frame.size.height)
            colorModeLabel.frame = CGRect(x: 10, y: (heightOf(row: row, inRowView: rowView) - colorModeLabel.frame.size.height) / 2, width: segmentedControl.frame.origin.x - 10, height: colorModeLabel.frame.size.height)
        } else {
            view.addSubview(labels[row - 1])
            view.addSubview(sliders[row - 1])
            view.addSubview(numberLabels[row - 1])
            
            let label: NSTextField = labels[row - 1]
            let slider: NSSlider = sliders[row - 1]
            let numberLabel: NSTextField = numberLabels[row - 1]
            
            label.frame = CGRect(x: 10, y: (heightOf(row: row, inRowView: rowView) - label.frame.size.height) / 2, width: label.frame.size.width, height: label.frame.size.height)
            
            numberLabel.alignment = NSTextAlignment.right
            
            numberLabel.frame = CGRect(x: rowView.frame.size.width - 10 - numberLabel.frame.size.width, y: (heightOf(row: row, inRowView: rowView) - numberLabel.frame.size.height) / 2, width: numberLabel.frame.size.width, height: numberLabel.frame.size.height)
            
            slider.frame = CGRect(x: label.frame.origin.x + label.frame.size.width + 10, y: (heightOf(row: row, inRowView: rowView) - slider.frame.size.height) / 2, width: numberLabel.frame.origin.x - label.frame.origin.x - label.frame.size.width - 20, height: slider.frame.size.height)
        }
        
        return view
    }
    
}
