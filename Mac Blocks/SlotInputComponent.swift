//
//  SlotInputComponent.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/6/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

// Input a single block
class SlotInputComponent: BlockInputComponent {
    
    static let SLOT_CORNER: CGFloat = Block.CORNER_RADIUS / 1.5
    static let SLOT_WIDTH: CGFloat = Block.STUB_WIDTH
    static let SLOT_HEIGHT: CGFloat = Block.STUB_WIDTH
    static let STUB_WIDTH: CGFloat = Block.STUB_WIDTH / 1.5
    static let STUB_HEIGHT: CGFloat = Block.STUB_HEIGHT / 1.5
    
    var allowedInputTypes: [DataType] = DataType.all()
    
    // Data to be used to initialize a default block if the slot is double-clicked
    var doubleClickData: NSDictionary?
    
    var isHighlighted: Bool = false {
        didSet {
            updateStyle()
        }
    }
    
    var placeholder: String? = nil {
        didSet {
            placeholderLabel.stringValue = placeholder ?? ""
            layoutFullObjectHierarchy()
        }
    }
    
    var placeholderLabel: NSTextField = NSTextField(labelWithString: "")
    
    override init() {
        super.init()
        
        addSubview(placeholderLabel)
        
        borderWidth = max(1.5 / (NSScreen.main?.backingScaleFactor ?? 1), 0.75)
    }
    
    convenience init(placeholder: String? = nil, doubleClickData: NSDictionary? = nil) {
        self.init()
        
        self.placeholder = placeholder
        placeholderLabel.stringValue = placeholder ?? ""
        
        self.doubleClickData = doubleClickData
    }
    
    convenience init(placeholder: String? = nil, doubleClickData: NSDictionary? = nil, allowedInputTypes: DataType...) {
        self.init(placeholder: placeholder, doubleClickData: doubleClickData)
        
        self.allowedInputTypes = allowedInputTypes
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func connectInput(_ input: Block) {
        super.connectInput(input)
        
        isHighlighted = false
    }
    
    func blockIsEligible(_ block: Block) -> Bool {
        if block.outputType == DataType.any || allowedInputTypes.contains(block.outputType) {
            return true
        }
        
        return false
    }
    
    override func updateStyle() {
        super.updateStyle()
        
        placeholderLabel.font = NSFont(name: Block.FONT.fontName, size: Block.FONT.pointSize * 0.9)
        placeholderLabel.textColor = NSColor.secondaryLabelColor
        
        if container != nil && container!.container != nil && container!.container! is Block {
            if isHighlighted {
                fillColor = container!.container!.fillColor.blended(withFraction: 0.3, of: NSColor.yellow)!
                borderLayer.fillColor = container!.container!.fillColor.blended(withFraction: 0.45, of: NSColor.yellow)!.cgColor
                placeholderLabel.textColor = container!.container!.fillColor.blended(withFraction: 0.8, of: NSColor.yellow)!
            } else {
                fillColor = container!.container!.fillColor.blended(withFraction: 0.3, of: NSColor.black)!
                borderLayer.fillColor = container!.container!.fillColor.blended(withFraction: 0.45, of: NSColor.black)!.cgColor
                
                if container!.container!.fillColor == BlockColor.mathColor {
                    placeholderLabel.textColor = container!.container!.fillColor.blended(withFraction: 0.5, of: NSColor.white)!
                } else {
                    placeholderLabel.textColor = container!.container!.fillColor.blended(withFraction: 0.8, of: NSColor.black)!
                }
            }
        }
    }
    
    override func redraw() {
        super.redraw()
        
        if input != nil {
            borderLayer.path = nil
            styleLayer.path = nil
        } else {
            let borderPath: CGMutablePath = CGMutablePath()
            let stylePath: CGMutablePath = CGMutablePath()
            
            if Block.blockStyle == Block.BlockStyle.rounded {
                // Bottom left starting point
                borderPath.move(to: CGPoint(x: SlotInputComponent.STUB_HEIGHT, y: SlotInputComponent.SLOT_CORNER))
                stylePath.move(to: CGPoint(x: SlotInputComponent.STUB_HEIGHT + borderWidth, y: SlotInputComponent.SLOT_CORNER))
            } else if Block.blockStyle == Block.BlockStyle.rectangle {
                // Bottom left starting point
                borderPath.move(to: CGPoint(x: SlotInputComponent.STUB_HEIGHT, y: 0))
                stylePath.move(to: CGPoint(x: SlotInputComponent.STUB_HEIGHT + borderWidth, y: borderWidth))
            } else if Block.blockStyle == Block.BlockStyle.trapezoid {
                // Bottom left starting point
                borderPath.move(to: CGPoint(x: SlotInputComponent.STUB_HEIGHT, y: SlotInputComponent.SLOT_CORNER))
                stylePath.move(to: CGPoint(x: SlotInputComponent.STUB_HEIGHT + borderWidth, y: SlotInputComponent.SLOT_CORNER))
            }
            
            borderPath.addLine(to: CGPoint(x: SlotInputComponent.STUB_HEIGHT, y: (frame.size.height - SlotInputComponent.STUB_WIDTH) / 2))
            borderPath.addLine(to: CGPoint(x: 0, y: (frame.size.height - SlotInputComponent.STUB_WIDTH) / 2 + SlotInputComponent.STUB_HEIGHT))
            borderPath.addLine(to: CGPoint(x: 0, y: (frame.size.height + SlotInputComponent.STUB_WIDTH) / 2 - SlotInputComponent.STUB_HEIGHT))
            borderPath.addLine(to: CGPoint(x: SlotInputComponent.STUB_HEIGHT, y: (frame.size.height + SlotInputComponent.STUB_WIDTH) / 2))
            
            let dy: CGFloat = borderWidth / CGFloat(tan(3 * Double.pi / 8))
            
            stylePath.addLine(to: CGPoint(x: SlotInputComponent.STUB_HEIGHT + borderWidth, y: (frame.size.height - SlotInputComponent.STUB_WIDTH) / 2 + dy))
            stylePath.addLine(to: CGPoint(x: borderWidth, y: (frame.size.height - SlotInputComponent.STUB_WIDTH) / 2 + SlotInputComponent.STUB_HEIGHT + dy))
            stylePath.addLine(to: CGPoint(x: borderWidth, y: (frame.size.height + SlotInputComponent.STUB_WIDTH) / 2 - SlotInputComponent.STUB_HEIGHT - dy))
            stylePath.addLine(to: CGPoint(x: SlotInputComponent.STUB_HEIGHT + borderWidth, y: (frame.size.height + SlotInputComponent.STUB_WIDTH) / 2 - dy))
            
            if Block.blockStyle == Block.BlockStyle.rounded {
                // Top left corner
                borderPath.addArc(center: CGPoint(x: SlotInputComponent.STUB_HEIGHT + SlotInputComponent.SLOT_CORNER, y: frame.size.height - SlotInputComponent.SLOT_CORNER), radius: SlotInputComponent.SLOT_CORNER, startAngle: CGFloat.pi, endAngle: CGFloat.pi / 2, clockwise: true)
                stylePath.addArc(center: CGPoint(x: SlotInputComponent.STUB_HEIGHT + SlotInputComponent.SLOT_CORNER, y: frame.size.height - SlotInputComponent.SLOT_CORNER), radius: SlotInputComponent.SLOT_CORNER - borderWidth, startAngle: CGFloat.pi, endAngle: CGFloat.pi / 2, clockwise: true)
                
                // Top right corner
                borderPath.addArc(center: CGPoint(x: frame.size.width - SlotInputComponent.SLOT_CORNER, y: frame.size.height - SlotInputComponent.SLOT_CORNER), radius: SlotInputComponent.SLOT_CORNER, startAngle: CGFloat.pi / 2, endAngle: 0, clockwise: true)
                stylePath.addArc(center: CGPoint(x: frame.size.width - SlotInputComponent.SLOT_CORNER, y: frame.size.height - SlotInputComponent.SLOT_CORNER), radius: SlotInputComponent.SLOT_CORNER - borderWidth, startAngle: CGFloat.pi / 2, endAngle: 0, clockwise: true)
                
                // Bottom right corner
                borderPath.addArc(center: CGPoint(x: frame.size.width - SlotInputComponent.SLOT_CORNER, y: SlotInputComponent.SLOT_CORNER), radius: SlotInputComponent.SLOT_CORNER, startAngle: 0, endAngle: CGFloat.pi / 2 * 3, clockwise: true)
                stylePath.addArc(center: CGPoint(x: frame.size.width - SlotInputComponent.SLOT_CORNER, y: SlotInputComponent.SLOT_CORNER), radius: SlotInputComponent.SLOT_CORNER - borderWidth, startAngle: 0, endAngle: CGFloat.pi / 2 * 3, clockwise: true)
                
                // Bottom left corner
                borderPath.addArc(center: CGPoint(x: SlotInputComponent.STUB_HEIGHT + SlotInputComponent.SLOT_CORNER, y: SlotInputComponent.SLOT_CORNER), radius: SlotInputComponent.SLOT_CORNER, startAngle: CGFloat.pi / 2 * 3, endAngle: CGFloat.pi, clockwise: true)
                stylePath.addArc(center: CGPoint(x: SlotInputComponent.STUB_HEIGHT + SlotInputComponent.SLOT_CORNER, y: SlotInputComponent.SLOT_CORNER), radius: SlotInputComponent.SLOT_CORNER - borderWidth, startAngle: CGFloat.pi / 2 * 3, endAngle: CGFloat.pi, clockwise: true)
            } else if Block.blockStyle == Block.BlockStyle.rectangle {
                // Top left corner
                borderPath.addLine(to: CGPoint(x: SlotInputComponent.STUB_HEIGHT, y: frame.size.height))
                stylePath.addLine(to: CGPoint(x: SlotInputComponent.STUB_HEIGHT + borderWidth, y: frame.size.height - borderWidth))
                
                // Top right corner
                borderPath.addLine(to: CGPoint(x: frame.size.width, y: frame.size.height))
                stylePath.addLine(to: CGPoint(x: frame.size.width - borderWidth, y: frame.size.height - borderWidth))
                
                // Bottom right corner
                borderPath.addLine(to: CGPoint(x: frame.size.width, y: 0))
                stylePath.addLine(to: CGPoint(x: frame.size.width - borderWidth, y: borderWidth))
                
                // Bottom left corner
                borderPath.addLine(to: CGPoint(x: SlotInputComponent.STUB_HEIGHT, y: 0))
                stylePath.addLine(to: CGPoint(x: SlotInputComponent.STUB_HEIGHT + borderWidth, y: borderWidth))
            } else if Block.blockStyle == Block.BlockStyle.trapezoid {
                // Top left corner
                borderPath.addLine(to: CGPoint(x: SlotInputComponent.STUB_HEIGHT, y: frame.size.height - SlotInputComponent.SLOT_CORNER))
                borderPath.addLine(to: CGPoint(x: SlotInputComponent.STUB_HEIGHT + SlotInputComponent.SLOT_CORNER, y: frame.size.height))
                stylePath.addLine(to: CGPoint(x: SlotInputComponent.STUB_HEIGHT + borderWidth, y: frame.size.height - SlotInputComponent.SLOT_CORNER))
                stylePath.addLine(to: CGPoint(x: SlotInputComponent.STUB_HEIGHT + SlotInputComponent.SLOT_CORNER, y: frame.size.height - borderWidth))
                
                // Top right corner
                borderPath.addLine(to: CGPoint(x: frame.size.width - SlotInputComponent.SLOT_CORNER, y: frame.size.height))
                borderPath.addLine(to: CGPoint(x: frame.size.width, y: frame.size.height - SlotInputComponent.SLOT_CORNER))
                stylePath.addLine(to: CGPoint(x: frame.size.width - SlotInputComponent.SLOT_CORNER, y: frame.size.height - borderWidth))
                stylePath.addLine(to: CGPoint(x: frame.size.width - borderWidth, y: frame.size.height - SlotInputComponent.SLOT_CORNER))
                
                // Bottom right corner
                borderPath.addLine(to: CGPoint(x: frame.size.width, y: SlotInputComponent.SLOT_CORNER))
                borderPath.addLine(to: CGPoint(x: frame.size.width - SlotInputComponent.SLOT_CORNER, y: 0))
                stylePath.addLine(to: CGPoint(x: frame.size.width - borderWidth, y: SlotInputComponent.SLOT_CORNER))
                stylePath.addLine(to: CGPoint(x: frame.size.width - SlotInputComponent.SLOT_CORNER, y: borderWidth))
                
                // Bottom left corner
                borderPath.addLine(to: CGPoint(x: SlotInputComponent.STUB_HEIGHT + SlotInputComponent.SLOT_CORNER, y: 0))
                borderPath.addLine(to: CGPoint(x: SlotInputComponent.STUB_HEIGHT, y: SlotInputComponent.SLOT_CORNER))
                stylePath.addLine(to: CGPoint(x: SlotInputComponent.STUB_HEIGHT + SlotInputComponent.SLOT_CORNER, y: borderWidth))
                stylePath.addLine(to: CGPoint(x: SlotInputComponent.STUB_HEIGHT + borderWidth, y: borderWidth))
            }
            
            borderLayer.path = borderPath
            styleLayer.path = stylePath
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
        
        if event.clickCount == 2 && input == nil {
            if let dcd: NSDictionary = doubleClickData {
                if let newBlock: Block = Block.constructFromData(dcd) {
                    var runner: InterfaceObject? = self
                    var containingBlock: Block?
                    
                    while runner!.container != nil {
                        runner = runner!.container
                        
                        if runner! is Block {
                            containingBlock = runner as? Block
                            break
                        }
                    }
                    
                    containingBlock?.workspace?.addBlock(newBlock)
                    containingBlock?.workspace?.selectBlock(newBlock)
                    
                    self.connectInput(newBlock)
                    layoutFullObjectHierarchy()
                    
                    var shouldBreak: Bool = false
                    
                    for line: BlockLine in newBlock.lines {
                        for component: BlockComponent in line.components {
                            if component is TextInputComponent {
                                (component as! TextInputComponent).enableEditing()
                                window?.makeFirstResponder((component as! TextInputComponent).textField)
                                
                                shouldBreak = true
                                break
                            }
                        }
                        
                        if shouldBreak {
                            break
                        }
                    }
                }
            }
        }
    }
    
    override func layoutObject() {
        if input != nil {
            placeholderLabel.isHidden = true
            input!.layoutObject()
            
            frame.size = input!.frame.size
        } else {
            placeholderLabel.isHidden = false
            
            if placeholder == nil || placeholder!.isEmpty {
                frame.size.width = max(SlotInputComponent.SLOT_WIDTH + SlotInputComponent.STUB_HEIGHT, placeholderLabel.frame.origin.x + placeholderLabel.frame.size.width + placeholderLabel.frame.origin.y)
                frame.size.height = SlotInputComponent.SLOT_HEIGHT
            } else {
                placeholderLabel.sizeToFit()
                placeholderLabel.frame.origin.y = ((SlotInputComponent.SLOT_HEIGHT - placeholderLabel.frame.size.height) / 2) + 0.5
                placeholderLabel.frame.origin.x = SlotInputComponent.STUB_HEIGHT + placeholderLabel.frame.origin.y
                
                frame.size.width = placeholderLabel.frame.origin.x + placeholderLabel.frame.size.width + placeholderLabel.frame.origin.y
                frame.size.height = SlotInputComponent.SLOT_HEIGHT
            }
        }
        
        super.layoutObject()
    }
    
}
