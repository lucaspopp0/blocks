//
//  Extensions.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/23/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

// Adds support for tinting images that are templates
extension NSImage {
    
    func tinted(with color: NSColor) -> NSImage {
        if isTemplate {
            let size: NSSize = self.size
            let imageBounds: NSRect = NSRect(origin: CGPoint.zero, size: size)
            
            let output: NSImage = self.copy() as! NSImage
            
            output.lockFocus()
            
            color.set()
            
            imageBounds.fill(using: NSCompositingOperation.sourceAtop)
            
            output.unlockFocus()
            
            return output
        } else {
            return self
        }
    }
    
}

// Adds support for colors from hex values
extension NSColor {
    
    public convenience init(hex: String) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 1
        
        var str: String = hex
        
        str = str.lowercased()
        
        if str.hasPrefix("#") {
            str = str.substring(from: 1)
        }
        
        if str.length == 8 {
            let scanner: Scanner = Scanner(string: str)
            var num: UInt64 = 0
            
            if scanner.scanHexInt64(&num) {
                r = CGFloat((num & 0xff000000) >> 24) / 255
                g = CGFloat((num & 0x00ff0000) >> 16) / 255
                b = CGFloat((num & 0x0000ff00) >> 8) / 255
                a = CGFloat(num & 0x000000ff) / 255
            }
        } else if str.length == 6 {
            let scanner: Scanner = Scanner(string: str)
            var num: UInt64 = 0
            
            if scanner.scanHexInt64(&num) {
                r = CGFloat((num & 0xff0000) >> 16) / 255
                g = CGFloat((num & 0x00ff00) >> 8) / 255
                b = CGFloat((num & 0x0000ff)) / 255
                a = 1
            }
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    var hexString: String {
        get {
            if let rgbColor: NSColor = self.usingColorSpace(NSColorSpace.sRGB) {
                return String(format: "%02X%02X%02X", Int(rgbColor.redComponent * 0xff), Int(rgbColor.greenComponent * 0xff), Int(rgbColor.blueComponent * 0xff))
            } else {
                return "#000000"
            }
        }
    }
    
}

// Adds support for ordering subviews
extension NSView {
    
    func bringSubview(toFront subview: NSView) {
        if subviews.contains(subview) {
            let superlayer: CALayer = subview.layer!.superlayer!
            subview.layer?.removeFromSuperlayer()
            
            superlayer.addSublayer(subview.layer!)
        }
    }
    
}

// Adds support for distance between points
extension CGPoint {
    
    static func distanceBetween(_ point1: CGPoint, and point2: CGPoint) -> CGFloat {
        return CGFloat(sqrt(pow(point2.x - point1.x, 2) + pow(point2.y - point1.y, 2)))
    }
    
    func distanceTo(_ point: CGPoint) -> CGFloat {
        return CGFloat(sqrt(pow(x - point.x, 2) + pow(self.y - point.y, 2)))
    }
    
}

// Adds convenient functions for substring and length to strings
// Adds function to get size of string
extension String {
    
    var length: Int {
        get {
            return characters.count
        }
    }
    
    func substring(from: Int, to: Int) -> String {
        return substring(with: index(startIndex, offsetBy: from) ..< index(startIndex, offsetBy: to))
    }
    
    func substring(from: Int) -> String {
        return substring(from: from, to: length)
    }
    
    func substring(to: Int) -> String {
        return substring(from: 0, to: to)
    }
    
    func substring(start: Int, length: Int) -> String {
        return substring(from: start, to: start + length)
    }
    
    func characterAt(index: Int) -> String {
        return substring(start: index, length: 1)
    }
    
    func size(withAttributes attributes: [NSAttributedStringKey: Any]?) -> CGSize {
        let text: NSAttributedString = NSAttributedString(string: self, attributes: attributes)
        
        return text.size()
    }
    
}

// Adds row click support
protocol ExtendedTableViewDelegate: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, didClickRow row: Int)
    
}

// Enables gesture support
extension NSTableView {
    
    func setupGestures() {
        let recognizer: NSClickGestureRecognizer = NSClickGestureRecognizer(target: self, action: #selector(NSTableView.handleClick(sender:)))
        addGestureRecognizer(recognizer)
    }
    
    @objc func handleClick(sender: NSClickGestureRecognizer) {
        let location: CGPoint = sender.location(in: self)
        let clickedRow: Int = self.row(at: location)
        
        if clickedRow != -1 && delegate is ExtendedTableViewDelegate {
            (delegate as! ExtendedTableViewDelegate).tableView(self, didClickRow: clickedRow)
        }
    }
    
}
