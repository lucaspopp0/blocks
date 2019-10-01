//
//  BlockLink.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 5/cornerRadius8/17.
//  Copyright © 2017 Lucas Popp. All rights reserved.
//

import Cocoa

class BlockLink: NSView {
    
    private let button: NSButton = NSButton(title: "Block", target: nil, action: nil)
    
    private var styleLayer: CAShapeLayer = CAShapeLayer()
    private var borderLayer: CAShapeLayer = CAShapeLayer()
    private var borderWidth: CGFloat = 0
    
    private var backgroundLayer: CAShapeLayer = CAShapeLayer()
    
    var block: Block? = nil {
        didSet {
            if let b = block {
                let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = NSTextAlignment.right
                
                button.title = "\(String(describing: type(of: b)))"
                button.attributedTitle = NSAttributedString(string: "\(String(describing: type(of: b)))", attributes: [NSAttributedStringKey.foregroundColor: NSColor.white,
                                                                                                                       NSAttributedStringKey.paragraphStyle: paragraphStyle,
                                                                                                                       NSAttributedStringKey.font: NSFont(name: Block.COMFORTABLE_FONT.fontName, size: Block.COMFORTABLE_FONT.pointSize * 0.85)!])
            }
        }
    }
    
    private func unifiedInit() {
        borderWidth = max(1.5 / (NSScreen.main?.backingScaleFactor ?? 1), 0.75)
        
        button.isBordered = false
        button.bezelStyle = NSButton.BezelStyle.regularSquare
        
        wantsLayer = true
        
        backgroundLayer = CAShapeLayer()
        
        styleLayer = CAShapeLayer()
        borderLayer = CAShapeLayer()
        
        backgroundLayer.position = CGPoint.zero
        styleLayer.position = CGPoint.zero
        borderLayer.position = CGPoint.zero
        
        backgroundLayer.fillColor = NSColor.white.cgColor
        
        layer?.masksToBounds = false
        
        layer?.addSublayer(backgroundLayer)
        layer?.addSublayer(borderLayer)
        layer?.addSublayer(styleLayer)
        
        if block != nil {
            let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = NSTextAlignment.right
            
            button.title = "\(String(describing: type(of: block!)))"
            button.attributedTitle = NSAttributedString(string: "\(String(describing: type(of: block!)))", attributes: [NSAttributedStringKey.foregroundColor: NSColor.white,
                                                                                                                        NSAttributedStringKey.paragraphStyle: paragraphStyle,
                                                                                                                        NSAttributedStringKey.font: NSFont(name: Block.COMFORTABLE_FONT.fontName, size: Block.COMFORTABLE_FONT.pointSize * 0.85)!])
            
            borderLayer.fillColor = block!.borderLayer.fillColor
            styleLayer.fillColor = block!.styleLayer.fillColor
        }
        
        addSubview(button)
        
        button.sizeToFit()
        sizeToFit()
        redraw()
        
        button.target = self
        button.action = #selector(BlockLink.selectBlock)
    }
    
    init(block: Block) {
        super.init(frame: NSRect.zero)
        self.block = block
        
        unifiedInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func sizeToFit() {
        button.sizeToFit()
        
        let cornerRadius: CGFloat = 2
        
        let stubHeight: CGFloat = button.frame.size.height - (cornerRadius * 2)
        let stubWidth: CGFloat = stubHeight / 4
        
        if let block = self.block {
            if block.outputType != DataType.none {
                frame.size.width = button.frame.size.width + stubWidth + (2 * cornerRadius)
                frame.size.height = button.frame.size.height + (2 * cornerRadius)
            } else if block.upperConnection.enabled {
                frame.size.width = button.frame.size.width + (2 * cornerRadius)
                frame.size.height = button.frame.size.height + (2 * cornerRadius) + stubWidth
            } else {
                frame.size.width = button.frame.size.width + (2 * cornerRadius)
                frame.size.height = button.frame.size.height + (2 * cornerRadius)
            }
        }
        
        button.frame.origin.x = frame.size.width - cornerRadius - button.frame.size.width
        button.frame.origin.y = cornerRadius
    }
    
    func redraw() {
        backgroundLayer.path = CGPath(rect: bounds, transform: nil)
        
        let stylePath: CGMutablePath = CGMutablePath()
        let borderPath: CGMutablePath = CGMutablePath()
        
        let cornerRadius: CGFloat = 2
        
        if let block = self.block {
            if block.outputType != DataType.none {
                let stubHeight: CGFloat = bounds.size.height - (cornerRadius * 2)
                let stubWidth: CGFloat = stubHeight / 4
                
                // Bottom left starting point
                borderPath.move(to: CGPoint(x: stubWidth, y: cornerRadius))
                stylePath.move(to: CGPoint(x: stubWidth + borderWidth, y: cornerRadius))
                
                borderPath.addLine(to: CGPoint(x: stubWidth, y: (frame.size.height - stubHeight) / 2))
                borderPath.addLine(to: CGPoint(x: 0, y: (frame.size.height - stubHeight) / 2 + stubWidth))
                borderPath.addLine(to: CGPoint(x: 0, y: (frame.size.height + stubHeight) / 2 - stubWidth))
                borderPath.addLine(to: CGPoint(x: stubWidth, y: (frame.size.height + stubHeight) / 2))
                
                let dy: CGFloat = borderWidth / CGFloat(tan(3 * Double.pi / 8))
                
                stylePath.addLine(to: CGPoint(x: stubWidth + borderWidth, y: (frame.size.height - stubHeight) / 2 + dy))
                stylePath.addLine(to: CGPoint(x: borderWidth, y: (frame.size.height - stubHeight) / 2 + stubWidth + dy))
                stylePath.addLine(to: CGPoint(x: borderWidth, y: (frame.size.height + stubHeight) / 2 - stubWidth - dy))
                stylePath.addLine(to: CGPoint(x: stubWidth + borderWidth, y: (frame.size.height + stubHeight) / 2 - dy))
                
                // Top left corner
                borderPath.addArc(center: CGPoint(x: stubWidth + cornerRadius, y: frame.size.height - cornerRadius), radius: cornerRadius, startAngle: CGFloat.pi, endAngle: CGFloat.pi / 2, clockwise: true)
                stylePath.addArc(center: CGPoint(x: stubWidth + cornerRadius, y: frame.size.height - cornerRadius), radius: cornerRadius - borderWidth, startAngle: CGFloat.pi, endAngle: CGFloat.pi / 2, clockwise: true)
                
                // Top right corner
                borderPath.addArc(center: CGPoint(x: frame.size.width - cornerRadius, y: frame.size.height - cornerRadius), radius: cornerRadius, startAngle: CGFloat.pi / 2, endAngle: 0, clockwise: true)
                stylePath.addArc(center: CGPoint(x: frame.size.width - cornerRadius, y: frame.size.height - cornerRadius), radius: cornerRadius - borderWidth, startAngle: CGFloat.pi / 2, endAngle: 0, clockwise: true)
                
                // Bottom right corner
                borderPath.addArc(center: CGPoint(x: frame.size.width - cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: 0, endAngle: CGFloat.pi / 2 * 3, clockwise: true)
                stylePath.addArc(center: CGPoint(x: frame.size.width - cornerRadius, y: cornerRadius), radius: cornerRadius - borderWidth, startAngle: 0, endAngle: CGFloat.pi / 2 * 3, clockwise: true)
                
                // Bottom left corner
                borderPath.addArc(center: CGPoint(x: stubWidth + cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: CGFloat.pi / 2 * 3, endAngle: CGFloat.pi, clockwise: true)
                stylePath.addArc(center: CGPoint(x: stubWidth + cornerRadius, y: cornerRadius), radius: cornerRadius - borderWidth, startAngle: CGFloat.pi / 2 * 3, endAngle: CGFloat.pi, clockwise: true)
            } else if block.upperConnection.enabled {
                var stubHeight: CGFloat = (bounds.size.height - (cornerRadius * 2)) * 0.75
                let stubWidth: CGFloat = stubHeight / 4
                stubHeight *= 0.95
                
                // Bottom left starting point
                borderPath.move(to: CGPoint(x: 0, y: cornerRadius))
                stylePath.move(to: CGPoint(x: borderWidth, y: cornerRadius))
                
                // Top left corner
                borderPath.addArc(center: CGPoint(x: cornerRadius, y: frame.size.height - stubWidth - cornerRadius), radius: cornerRadius, startAngle: CGFloat.pi, endAngle: CGFloat.pi / 2, clockwise: true)
                stylePath.addArc(center: CGPoint(x: cornerRadius, y: frame.size.height - stubWidth - cornerRadius), radius: cornerRadius - borderWidth, startAngle: CGFloat.pi, endAngle: CGFloat.pi / 2, clockwise: true)
                
                borderPath.addLine(to: CGPoint(x: cornerRadius * 2, y: frame.size.height - stubWidth))
                borderPath.addLine(to: CGPoint(x: (cornerRadius * 2) + stubWidth, y: frame.size.height))
                borderPath.addLine(to: CGPoint(x: (cornerRadius * 2) + stubHeight - stubWidth, y: frame.size.height))
                borderPath.addLine(to: CGPoint(x: (cornerRadius * 2) + stubHeight, y: frame.size.height - stubWidth))
                
                let dx: CGFloat = borderWidth / CGFloat(tan(3 * Double.pi / 8))
                
                stylePath.addLine(to: CGPoint(x: (cornerRadius * 2) + dx, y: frame.size.height - stubWidth - borderWidth))
                stylePath.addLine(to: CGPoint(x: (cornerRadius * 2) + stubWidth + dx, y: frame.size.height - borderWidth))
                stylePath.addLine(to: CGPoint(x: (cornerRadius * 2) + stubHeight - stubWidth - dx, y: frame.size.height - borderWidth))
                stylePath.addLine(to: CGPoint(x: (cornerRadius * 2) + stubHeight - dx, y: frame.size.height - stubWidth - borderWidth))
                
                // Top right corner
                borderPath.addArc(center: CGPoint(x: frame.size.width - cornerRadius, y: frame.size.height - stubWidth - cornerRadius), radius: cornerRadius, startAngle: CGFloat.pi / 2, endAngle: 0, clockwise: true)
                stylePath.addArc(center: CGPoint(x: frame.size.width - cornerRadius, y: frame.size.height - stubWidth - cornerRadius), radius: cornerRadius - borderWidth, startAngle: CGFloat.pi / 2, endAngle: 0, clockwise: true)
                
                // Bottom right corner
                borderPath.addArc(center: CGPoint(x: frame.size.width - cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: 0, endAngle: CGFloat.pi / 2 * 3, clockwise: true)
                stylePath.addArc(center: CGPoint(x: frame.size.width - cornerRadius, y: cornerRadius), radius: cornerRadius - borderWidth, startAngle: 0, endAngle: CGFloat.pi / 2 * 3, clockwise: true)
                
                // Bottom left corner
                borderPath.addArc(center: CGPoint(x: cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: CGFloat.pi / 2 * 3, endAngle: CGFloat.pi, clockwise: true)
                stylePath.addArc(center: CGPoint(x: cornerRadius, y: cornerRadius), radius: cornerRadius - borderWidth, startAngle: CGFloat.pi / 2 * 3, endAngle: CGFloat.pi, clockwise: true)
            } else {
                // Bottom left starting point
                borderPath.move(to: CGPoint(x: 0, y: cornerRadius))
                stylePath.move(to: CGPoint(x: borderWidth, y: cornerRadius))
                
                // Top left corner
                borderPath.addArc(center: CGPoint(x: cornerRadius, y: frame.size.height - cornerRadius), radius: cornerRadius, startAngle: CGFloat.pi, endAngle: CGFloat.pi / 2, clockwise: true)
                stylePath.addArc(center: CGPoint(x: cornerRadius, y: frame.size.height - cornerRadius), radius: cornerRadius - borderWidth, startAngle: CGFloat.pi, endAngle: CGFloat.pi / 2, clockwise: true)
                
                // Top right corner
                borderPath.addArc(center: CGPoint(x: frame.size.width - cornerRadius, y: frame.size.height - cornerRadius), radius: cornerRadius, startAngle: CGFloat.pi / 2, endAngle: 0, clockwise: true)
                stylePath.addArc(center: CGPoint(x: frame.size.width - cornerRadius, y: frame.size.height - cornerRadius), radius: cornerRadius - borderWidth, startAngle: CGFloat.pi / 2, endAngle: 0, clockwise: true)
                
                // Bottom right corner
                borderPath.addArc(center: CGPoint(x: frame.size.width - cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: 0, endAngle: CGFloat.pi / 2 * 3, clockwise: true)
                stylePath.addArc(center: CGPoint(x: frame.size.width - cornerRadius, y: cornerRadius), radius: cornerRadius - borderWidth, startAngle: 0, endAngle: CGFloat.pi / 2 * 3, clockwise: true)
                
                // Bottom left corner
                borderPath.addArc(center: CGPoint(x: cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: CGFloat.pi / 2 * 3, endAngle: CGFloat.pi, clockwise: true)
                stylePath.addArc(center: CGPoint(x: cornerRadius, y: cornerRadius), radius: cornerRadius - borderWidth, startAngle: CGFloat.pi / 2 * 3, endAngle: CGFloat.pi, clockwise: true)
            }
        }
        
        borderLayer.path = borderPath
        styleLayer.path = stylePath
    }
    
    @objc func selectBlock() {
        if let block = self.block {
            block.workspace?.selectBlock(block)
        }
    }
    
}
