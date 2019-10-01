//
//  ClassData.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/27/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

class Property {
    
    var name: String = ""
    var type: DataType = DataType.any
    
    init(name: String, type: DataType) {
        self.name = name
        self.type = type
    }
    
}

class Method {
    
    var name: String = ""
    var outputType: DataType = DataType.none
    
    init(name: String, outputType: DataType) {
        self.name = name
        self.outputType = outputType
    }
    
}

class ClassData {
    
    var properties: [Property] = [Property(name: "name", type: DataType.string)]
    var methods: [Method] = [Method(name: "smile", outputType: DataType.none)]
    
}
