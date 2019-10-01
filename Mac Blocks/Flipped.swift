//
//  Flipped.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/23/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

// NSView with origin at top left
class FlippedView: NSView {
    
    override var isFlipped: Bool {
        get {
            return true
        }
    }
    
}

// NSScrollView with origin at top left
class FlippedScrollView: NSScrollView {
    
    override var isFlipped: Bool {
        get {
            return true
        }
    }
    
}
