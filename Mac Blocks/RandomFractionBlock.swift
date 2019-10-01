//
//  RandomFractionBlock.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/9/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

class RandomFractionBlock: Block {
    
    override var blockDescription: String {
        get {
            return "Outputs a random fraction."
        }
    }
    
    required init(origin: CGPoint = CGPoint.zero) {
        super.init(origin: origin)
        
        outputType = DataType.number
        
        let l1: BlockLine = BlockLine()
        
        l1.addComponent(TextComponent(text: "random fraction"))
        
        addLine(l1)
        
        fillColor = BlockColor.mathColor
        textColor = BlockColor.lightTextColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult override func evaluate() -> Any? {
        return drand48()
    }
    
    override func duplicate() -> Block {
        return RandomFractionBlock()
    }
    
}
