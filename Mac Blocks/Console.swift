//
//  Console.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/9/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

// An object that represents the console
class Console {
    
    var view: ConsoleView?
    
    init(view: ConsoleView? = nil) {
        self.view = view
    }
    
    func error(message: String, sourceBlock: Block? = nil) {
        if view != nil {
            view!.addLine(ConsoleLine(errorMessage: message, blockReference: sourceBlock))
        } else {
            Swift.print("Error: \(message)")
        }
    }
    
    func warning(message: String, sourceBlock: Block? = nil) {
        if view != nil {
            view!.addLine(ConsoleLine(warningMessage: message, blockReference: sourceBlock))
        } else {
            Swift.print("Warning: \(message)")
        }
    }
    
    func print(_ item: Any) {
        if view != nil {
            view!.addLine(ConsoleLine(printMessage: String(describing: item)))
        } else {
            Swift.print(item)
        }
    }
    
    func clear() {
        view?.clear()
    }
    
    func promptForInput() -> InputLine {
        let newLine: InputLine = InputLine()
        
        view?.addLine(newLine)
        
        return newLine
    }
    
}
