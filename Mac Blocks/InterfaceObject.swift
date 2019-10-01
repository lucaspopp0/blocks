//
//  InterfaceObject.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/5/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

// The simplest object, subclassed by all blocks and components
class InterfaceObject: NSView {
    
    internal var styleLayer: CAShapeLayer = CAShapeLayer()
    internal var borderLayer: CAShapeLayer = CAShapeLayer()
    internal var highlightLayer: CAShapeLayer = CAShapeLayer()
    internal var borderWidth: CGFloat = 0
    
    var container: InterfaceObject?
    
    var fillColor: NSColor = NSColor.clear {
        didSet {
            styleLayer.fillColor = fillColor.cgColor
            
            var h: CGFloat = 0
            var s: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            
            fillColor.usingColorSpaceName(NSColorSpaceName.calibratedRGB)?.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
            
            borderLayer.fillColor = NSColor(hue: h, saturation: s, brightness: (b * 0.85), alpha: a).cgColor
        }
    }
    
    override var allowsVibrancy: Bool {
        get {
            return false
        }
    }
    
    override var acceptsFirstResponder: Bool {
        get {
            return true
        }
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        wantsLayer = true
        
        styleLayer = CAShapeLayer()
        borderLayer = CAShapeLayer()
        highlightLayer = CAShapeLayer()
        
        highlightLayer.fillColor = NSColor(red: 1, green: 0.84, blue: 0, alpha: 1).cgColor
        
        layer?.addSublayer(borderLayer)
        layer?.addSublayer(styleLayer)
        layer?.addSublayer(highlightLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Gets the interface object's frame in the workspace
    func frameInWorkspace() -> CGRect? {
        if container != nil {
            if container is Block {
                var output: CGRect = self.frame
                
                output.origin.x += container!.frame.origin.x
                output.origin.y = container!.frame.origin.y + container!.frame.size.height - output.origin.y - output.size.height
                
                return output
            } else {
                var output: CGRect = self.frame
                
                let containerFrame: CGRect! = container!.frameInWorkspace()!
                
                output.origin.x += containerFrame!.origin.x
                output.origin.y += containerFrame!.origin.y
                
                return output
            }
        } else {
            return self.frame
        }
    }
    
    // To be implemented by subclasses
    func updateStyle() {}
    
    // To be implemented by subclasses
    func redraw() {}
    
    // To be implemented largely by subclasses
    func layoutObject() {
        frame = frame.integral
        redraw()
    }
    
    override func keyDown(with event: NSEvent) {
        super.keyDown(with: event)
    }
    
    // Lays out the object, its container, whatever its container is connected to
    @objc func layoutFullObjectHierarchy() {
        var runner: InterfaceObject? = self
        var objectToLayout: InterfaceObject = runner!
        
        while runner!.container != nil || (runner! is Block && ((runner as! Block).inputAnchor != nil || (runner as! Block).upperConnection.connectedTo != nil)) {
            if runner!.container != nil {
                runner = runner!.container
            } else if (runner as! Block).inputAnchor != nil {
                runner = (runner as! Block).inputAnchor
            } else if (runner as! Block).upperConnection.connectedTo != nil {
                runner = (runner as! Block).upperConnection.connectedTo
            }
        }
        
        objectToLayout = runner!
        
        objectToLayout.layoutObject()
    }
    
}
