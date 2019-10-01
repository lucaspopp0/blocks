//
//  CustomPicker.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/24/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

class CustomPicker: NSPopUpButton {
    
    override func select(_ item: NSMenuItem?) {
        super.select(item)
        
        if target != nil && action != nil {
            let _ = target!.perform(action!)
        }
    }
    
    override func selectItem(at index: Int) {
        super.selectItem(at: index)
        
        if target != nil && action != nil {
            let _ = target!.perform(action!)
        }
    }
    
    override func selectItem(withTitle title: String) {
        super.selectItem(withTitle: title)
        
        if target != nil && action != nil {
            let _ = target!.perform(action!)
        }
    }
    
    override func selectItem(withTag tag: Int) -> Bool {
        let result: Bool = super.selectItem(withTag: tag)
        
        if target != nil && action != nil {
            let _ = target!.perform(action!)
        }
        
        return result
    }
    
}
