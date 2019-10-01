//
//  VerticalConnection.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/24/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

// Represents a vertical connection between two blocks
class VerticalConnection {
    
    var enabled: Bool = true
    var connectedTo: InterfaceObject?
    
    var isOpen: Bool {
        return enabled && connectedTo == nil
    }
    
    init() {}
    
}
