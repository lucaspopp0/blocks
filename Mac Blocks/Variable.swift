//
//  Variable.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/11/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Foundation

// Stores a variable
class Variable {
    
    var name: String
    var value: Any?
    
    init(name: String, value: Any? = nil) {
        self.name = name
        self.value = value
    }
    
}
