//
//  ConsoleView.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/24/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

// The console view
class ConsoleView: NSView {
    
    @IBOutlet weak var clearButton: NSButton!
    
    static let PADDING: CGFloat = 8
    
    let scrollView: NSScrollView = NSScrollView()
    let linesContainer: NSView = NSView()
    
    var lines: [GenericConsoleLine] = []
    
    func unifiedInit() {
        wantsLayer = true
        layer?.backgroundColor = NSColor.white.cgColor
        
        scrollView.hasVerticalScroller = true
        
        addSubview(scrollView)
        scrollView.documentView = linesContainer
    }
    
    override init(frame frameRect: NSRect = CGRect.zero) {
        super.init(frame: frameRect)
        
        unifiedInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        unifiedInit()
    }
    
    override func resize(withOldSuperviewSize oldSize: NSSize) {
        super.resize(withOldSuperviewSize: oldSize)
        
        frame.size = superview!.frame.size
    }
    
    override func resizeSubviews(withOldSize oldSize: NSSize) {
        super.resizeSubviews(withOldSize: oldSize)
        
        scrollView.frame = bounds
    }
    
    func addLine(_ line: GenericConsoleLine) {
        lines.append(line)
        organizeLines()
    }
    
    func clear() {
        while lines.count > 0 {
            lines.removeFirst().removeFromSuperview()
        }
        
        lines.append(ConsoleLine(printString: NSAttributedString(string: "Console cleared", attributes: [NSAttributedStringKey.font: NSFont(name: "Menlo-Italic", size: NSFont.systemFontSize)!,
                                                                                                         NSAttributedStringKey.foregroundColor: NSColor.gray])))
        
        organizeLines()
    }
    
    func organizeLines() {
        var totalHeight: CGFloat = 0
        
        for line in lines {
            if line.superview != nil {
                line.removeFromSuperview()
            }
            
            line.frame.origin.x = ConsoleView.PADDING
            line.frame.size.width = scrollView.frame.size.width - (2 * ConsoleView.PADDING)
            
            line.layoutSubviews()
            
            line.frame.size.height = max(line.frame.size.height, 20)
            
            totalHeight += line.frame.size.height
            
            totalHeight += 4
        }
        
        var currentTop: CGFloat = totalHeight
        
        for line in lines {
            currentTop -= line.frame.size.height
            
            line.frame.origin.y = currentTop + ConsoleView.PADDING
            
            currentTop -= 4
            
            linesContainer.addSubview(line)
        }
        
        linesContainer.frame.size = CGSize(width: scrollView.frame.size.width, height: totalHeight + (2 * ConsoleView.PADDING))
    }
    
}
