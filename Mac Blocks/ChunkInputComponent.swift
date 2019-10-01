//
//  ChunkInputComponent.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/7/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

// Allows the user to input a chunk of blocks (like in IfBlock)
class ChunkInputComponent: BlockComponent {
    
    // The connection to the chunk
    let anchor: VerticalConnection = VerticalConnection()
    var inputPosition: CGPoint {
        get {
            if Block.connectionStyle == Block.ConnectionStyle.puzzlePiece {
                return frameInWorkspace()!.origin
            } else {
                var origin: CGPoint = self.frameInWorkspace()!.origin
                
                origin.y += Block.STUB_HEIGHT
                
                return origin
            }
        }
    }
    
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
        
        fullWidth = true
        borderWidth = max(1.5 / (NSScreen.main?.backingScaleFactor ?? 1), 0.75)
    }
    
    convenience init(placeholder: String) {
        self.init()
        
        self.placeholder = placeholder
        placeholderLabel.stringValue = placeholder
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateStyle() {
        super.updateStyle()
        
        placeholderLabel.font = NSFont(name: Block.FONT.fontName, size: Block.FONT.pointSize * 0.9)
        placeholderLabel.textColor = NSColor.secondaryLabelColor
        
        if container != nil && container!.container != nil && container!.container! is Block {
            if isHighlighted {
                fillColor = container!.container!.fillColor.blended(withFraction: 0.3, of: NSColor.yellow)!
                borderLayer.fillColor = container!.container!.fillColor.blended(withFraction: 0.45, of: NSColor.yellow)!.cgColor
                placeholderLabel.textColor = container!.container!.fillColor.blended(withFraction: 0.6, of: NSColor.yellow)!
            } else {
                fillColor = container!.container!.fillColor.blended(withFraction: 0.3, of: NSColor.black)!
                borderLayer.fillColor = container!.container!.fillColor.blended(withFraction: 0.45, of: NSColor.black)!.cgColor
                placeholderLabel.textColor = container!.container!.fillColor.blended(withFraction: 0.8, of: NSColor.black)!
            }
        }
    }
    
    override func redraw() {
        if anchor.connectedTo == nil {
            let borderPath: CGMutablePath = CGMutablePath()
            let stylePath: CGMutablePath = CGMutablePath()
            
            let cornerRadius: CGFloat = 2
            
            if Block.blockStyle == Block.BlockStyle.rounded {
                // Bottom left starting point
                borderPath.move(to: CGPoint(x: 0, y: cornerRadius))
                stylePath.move(to: CGPoint(x: borderWidth, y: cornerRadius))
                
                // Top left corner
                if Block.connectionStyle == Block.ConnectionStyle.trapezoid {
                    borderPath.addArc(center: CGPoint(x: cornerRadius, y: frame.size.height - SlotInputComponent.STUB_HEIGHT - cornerRadius), radius: cornerRadius, startAngle: CGFloat.pi, endAngle: CGFloat.pi / 2, clockwise: true)
                    stylePath.addArc(center: CGPoint(x: cornerRadius, y: frame.size.height - SlotInputComponent.STUB_HEIGHT - cornerRadius), radius: cornerRadius - borderWidth, startAngle: CGFloat.pi, endAngle: CGFloat.pi / 2, clockwise: true)
                } else if Block.connectionStyle == Block.ConnectionStyle.puzzlePiece {
                    borderPath.addArc(center: CGPoint(x: cornerRadius, y: frame.size.height - cornerRadius), radius: cornerRadius, startAngle: CGFloat.pi, endAngle: CGFloat.pi / 2, clockwise: true)
                    stylePath.addArc(center: CGPoint(x: cornerRadius, y: frame.size.height - cornerRadius), radius: cornerRadius - borderWidth, startAngle: CGFloat.pi, endAngle: CGFloat.pi / 2, clockwise: true)
                }
            } else if Block.blockStyle == Block.BlockStyle.rectangle {
                // Bottom left starting point
                borderPath.move(to: CGPoint(x: 0, y: 0))
                stylePath.move(to: CGPoint(x: borderWidth, y: borderWidth))
                
                // Top left corner
                if Block.connectionStyle == Block.ConnectionStyle.trapezoid {
                    borderPath.addLine(to: CGPoint(x: 0, y: frame.size.height - SlotInputComponent.STUB_HEIGHT))
                    stylePath.addLine(to: CGPoint(x: borderWidth, y: frame.size.height - SlotInputComponent.STUB_HEIGHT - borderWidth))
                } else if Block.connectionStyle == Block.ConnectionStyle.puzzlePiece {
                    borderPath.addLine(to: CGPoint(x: 0, y: frame.size.height))
                    stylePath.addLine(to: CGPoint(x: borderWidth, y: frame.size.height - borderWidth))
                }
            } else if Block.blockStyle == Block.BlockStyle.trapezoid {
                // Bottom left starting point
                borderPath.move(to: CGPoint(x: 0, y: cornerRadius))
                stylePath.move(to: CGPoint(x: borderWidth, y: cornerRadius))
                
                // Top left corner
                if Block.connectionStyle == Block.ConnectionStyle.trapezoid {
                    borderPath.addLine(to: CGPoint(x: 0, y: frame.size.height - SlotInputComponent.STUB_HEIGHT - cornerRadius))
                    borderPath.addLine(to: CGPoint(x: cornerRadius, y: frame.size.height - SlotInputComponent.STUB_HEIGHT))
                    stylePath.addLine(to: CGPoint(x: borderWidth, y: frame.size.height - SlotInputComponent.STUB_HEIGHT - cornerRadius))
                    stylePath.addLine(to: CGPoint(x: cornerRadius, y: frame.size.height - SlotInputComponent.STUB_HEIGHT - borderWidth))
                } else if Block.connectionStyle == Block.ConnectionStyle.puzzlePiece {
                    borderPath.addLine(to: CGPoint(x: 0, y: frame.size.height - cornerRadius))
                    borderPath.addLine(to: CGPoint(x: cornerRadius, y: frame.size.height))
                    stylePath.addLine(to: CGPoint(x: borderWidth, y: frame.size.height - cornerRadius))
                    stylePath.addLine(to: CGPoint(x: cornerRadius, y: frame.size.height - borderWidth))
                }
            }
            
            if Block.connectionStyle == Block.ConnectionStyle.trapezoid {
                borderPath.addLine(to: CGPoint(x: Block.PADDING, y: frame.size.height - SlotInputComponent.STUB_HEIGHT))
                borderPath.addLine(to: CGPoint(x: Block.PADDING + SlotInputComponent.STUB_HEIGHT, y: frame.size.height))
                borderPath.addLine(to: CGPoint(x: Block.PADDING + SlotInputComponent.STUB_WIDTH - SlotInputComponent.STUB_HEIGHT, y: frame.size.height))
                borderPath.addLine(to: CGPoint(x: Block.PADDING + SlotInputComponent.STUB_WIDTH, y: frame.size.height - SlotInputComponent.STUB_HEIGHT))
                
                let dx: CGFloat = borderWidth / CGFloat(tan(3 * Double.pi / 8))
                
                stylePath.addLine(to: CGPoint(x: Block.PADDING + dx, y: frame.size.height - SlotInputComponent.STUB_HEIGHT - borderWidth))
                stylePath.addLine(to: CGPoint(x: Block.PADDING + SlotInputComponent.STUB_HEIGHT + dx, y: frame.size.height - borderWidth))
                stylePath.addLine(to: CGPoint(x: Block.PADDING + SlotInputComponent.STUB_WIDTH - SlotInputComponent.STUB_HEIGHT - dx, y: frame.size.height - borderWidth))
                stylePath.addLine(to: CGPoint(x: Block.PADDING + SlotInputComponent.STUB_WIDTH - dx, y: frame.size.height - SlotInputComponent.STUB_HEIGHT - borderWidth))
            } else if Block.connectionStyle == Block.ConnectionStyle.puzzlePiece {
                let d: CGFloat = SlotInputComponent.STUB_HEIGHT
                let r: CGFloat = ((4 * d) + (d * sqrt(8))) / 4
                let w = (4 * r) / sqrt(2)
                
                let A: CGPoint = CGPoint(x: Block.PADDING, y: frame.size.height - r - borderWidth)
                let B: CGPoint = CGPoint(x: Block.PADDING + (w / 2), y: A.y + (2 * r / sqrt(2)))
                let C: CGPoint = CGPoint(x: Block.PADDING + w, y: A.y)
                
                borderPath.addArc(center: A, radius: r + borderWidth, startAngle: CGFloat.pi * 0.5, endAngle: CGFloat.pi * 0.25, clockwise: true)
                borderPath.addArc(center: B, radius: r - borderWidth, startAngle: CGFloat.pi * 1.25, endAngle: CGFloat.pi * 1.75, clockwise: false)
                borderPath.addArc(center: C, radius: r + borderWidth, startAngle: CGFloat.pi * 0.75, endAngle: CGFloat.pi * 0.5, clockwise: true)
                
                stylePath.addArc(center: A, radius: r, startAngle: CGFloat.pi * 0.5, endAngle: CGFloat.pi * 0.25, clockwise: true)
                stylePath.addArc(center: B, radius: r, startAngle: CGFloat.pi * 1.25, endAngle: CGFloat.pi * 1.75, clockwise: false)
                stylePath.addArc(center: C, radius: r, startAngle: CGFloat.pi * 0.75, endAngle: CGFloat.pi * 0.5, clockwise: true)
            }
            
            if Block.blockStyle == Block.BlockStyle.rounded {
                // Top right corner
                if Block.connectionStyle == Block.ConnectionStyle.trapezoid {
                    borderPath.addArc(center: CGPoint(x: frame.size.width - cornerRadius, y: frame.size.height - SlotInputComponent.STUB_HEIGHT - cornerRadius), radius: cornerRadius, startAngle: CGFloat.pi / 2, endAngle: 0, clockwise: true)
                    stylePath.addArc(center: CGPoint(x: frame.size.width - cornerRadius, y: frame.size.height - SlotInputComponent.STUB_HEIGHT - cornerRadius), radius: cornerRadius - borderWidth, startAngle: CGFloat.pi / 2, endAngle: 0, clockwise: true)
                } else if Block.connectionStyle == Block.ConnectionStyle.puzzlePiece {
                    borderPath.addArc(center: CGPoint(x: frame.size.width - cornerRadius, y: frame.size.height - cornerRadius), radius: cornerRadius, startAngle: CGFloat.pi / 2, endAngle: 0, clockwise: true)
                    stylePath.addArc(center: CGPoint(x: frame.size.width - cornerRadius, y: frame.size.height - cornerRadius), radius: cornerRadius - borderWidth, startAngle: CGFloat.pi / 2, endAngle: 0, clockwise: true)
                }
                
                // Bottom right corner
                borderPath.addArc(center: CGPoint(x: frame.size.width - cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: 0, endAngle: CGFloat.pi / 2 * 3, clockwise: true)
                stylePath.addArc(center: CGPoint(x: frame.size.width - cornerRadius, y: cornerRadius), radius: cornerRadius - borderWidth, startAngle: 0, endAngle: CGFloat.pi / 2 * 3, clockwise: true)
                
                // Bottom left corner
                borderPath.addArc(center: CGPoint(x: cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: CGFloat.pi / 2 * 3, endAngle: CGFloat.pi, clockwise: true)
                stylePath.addArc(center: CGPoint(x: cornerRadius, y: cornerRadius), radius: cornerRadius - borderWidth, startAngle: CGFloat.pi / 2 * 3, endAngle: CGFloat.pi, clockwise: true)
            } else if Block.blockStyle == Block.BlockStyle.rectangle {
                // Top right corner
                if Block.connectionStyle == Block.ConnectionStyle.trapezoid {
                    borderPath.addLine(to: CGPoint(x: frame.size.width, y: frame.size.height - SlotInputComponent.STUB_HEIGHT))
                    stylePath.addLine(to: CGPoint(x: frame.size.width - borderWidth, y: frame.size.height - SlotInputComponent.STUB_HEIGHT - borderWidth))
                } else if Block.connectionStyle == Block.ConnectionStyle.puzzlePiece {
                    borderPath.addLine(to: CGPoint(x: frame.size.width, y: frame.size.height))
                    stylePath.addLine(to: CGPoint(x: frame.size.width - borderWidth, y: frame.size.height - borderWidth))
                }
                
                // Bottom right corner
                borderPath.addLine(to: CGPoint(x: frame.size.width, y: 0))
                stylePath.addLine(to: CGPoint(x: frame.size.width - borderWidth, y: borderWidth))
                
                // Bottom left corner
                borderPath.addLine(to: CGPoint(x: 0, y: 0))
                stylePath.addLine(to: CGPoint(x: borderWidth, y: borderWidth))
            } else if Block.blockStyle == Block.BlockStyle.trapezoid {
                // Top right corner
                if Block.connectionStyle == Block.ConnectionStyle.trapezoid {
                    borderPath.addLine(to: CGPoint(x: frame.size.width - cornerRadius, y: frame.size.height - SlotInputComponent.STUB_HEIGHT))
                    borderPath.addLine(to: CGPoint(x: frame.size.width, y: frame.size.height - SlotInputComponent.STUB_HEIGHT - cornerRadius))
                    stylePath.addLine(to: CGPoint(x: frame.size.width - cornerRadius, y: frame.size.height - SlotInputComponent.STUB_HEIGHT - borderWidth))
                    stylePath.addLine(to: CGPoint(x: frame.size.width - borderWidth, y: frame.size.height - SlotInputComponent.STUB_HEIGHT - cornerRadius))
                } else if Block.connectionStyle == Block.ConnectionStyle.puzzlePiece {
                    borderPath.addLine(to: CGPoint(x: frame.size.width - cornerRadius, y: frame.size.height))
                    borderPath.addLine(to: CGPoint(x: frame.size.width, y: frame.size.height - cornerRadius))
                    stylePath.addLine(to: CGPoint(x: frame.size.width - cornerRadius, y: frame.size.height - borderWidth))
                    stylePath.addLine(to: CGPoint(x: frame.size.width - borderWidth, y: frame.size.height - cornerRadius))
                }
                
                // Bottom right corner
                borderPath.addLine(to: CGPoint(x: frame.size.width, y: cornerRadius))
                borderPath.addLine(to: CGPoint(x: frame.size.width - cornerRadius, y: 0))
                stylePath.addLine(to: CGPoint(x: frame.size.width - borderWidth, y: cornerRadius))
                stylePath.addLine(to: CGPoint(x: frame.size.width - cornerRadius, y: borderWidth))
                
                // Bottom left corner
                borderPath.addLine(to: CGPoint(x: cornerRadius, y: 0))
                borderPath.addLine(to: CGPoint(x: 0, y: cornerRadius))
                stylePath.addLine(to: CGPoint(x: cornerRadius, y: borderWidth))
                stylePath.addLine(to: CGPoint(x: borderWidth, y: cornerRadius))
            }
            
            borderLayer.path = borderPath
            styleLayer.path = stylePath
        } else {
            let pathRect: CGRect = CGRect(
                x: 0,
                y: 0,
                width: frame.size.width,
                height: frame.size.height - Block.STUB_HEIGHT
            )
            
            styleLayer.path = CGPath(roundedRect: pathRect.insetBy(dx: borderWidth, dy: borderWidth), cornerWidth: Block.CORNER_RADIUS - borderWidth, cornerHeight: Block.CORNER_RADIUS - borderWidth, transform: nil)
            borderLayer.path = CGPath(roundedRect: pathRect, cornerWidth: Block.CORNER_RADIUS, cornerHeight: Block.CORNER_RADIUS, transform: nil)
        }
    }
    
    override func layoutObject() {
        frame.origin = CGPoint.zero
        
        if anchor.connectedTo == nil {
            placeholderLabel.isHidden = false
            
            placeholderLabel.sizeToFit()
            placeholderLabel.frame.origin.x = ((SlotInputComponent.SLOT_HEIGHT - placeholderLabel.frame.size.height) / 2) + 0.5
            placeholderLabel.frame.origin.y = placeholderLabel.frame.origin.x
            
            frame.size.width = max(SlotInputComponent.SLOT_WIDTH, placeholderLabel.frame.origin.x + placeholderLabel.frame.size.width + placeholderLabel.frame.origin.x)
            frame.size.height = SlotInputComponent.SLOT_HEIGHT + SlotInputComponent.STUB_HEIGHT
        } else {
            placeholderLabel.isHidden = true
            
            (anchor.connectedTo as! Block).layoutObject()
            
            frame.size = (anchor.connectedTo as! Block).frameWithChildren().size
        }
        
        super.layoutObject()
    }
    
    override func extendFully(componentWidth: CGFloat) {
        if anchor.connectedTo == nil {
            frame.size.width = componentWidth
            
            redraw()
        }
    }
    
}
