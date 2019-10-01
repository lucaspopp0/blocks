//
//  Document.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/5/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

// The document representation of the file. This is a little messy, because I don't totally have a firm grasp on documents yet
class Document: NSDocument {
    
    var windowControllersMade: Bool = false
    
    override var isDocumentEdited: Bool {
        get {
            let wc: NSWindowController? = getWindowController()
            
            if wc != nil {
                return wc!.window?.isDocumentEdited ?? false
            } else {
                return false
            }
        }
    }
    
    override class var autosavesInPlace: Bool {
        get {
            return true
        }
    }

    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }
    
    override func save(_ sender: Any?) {
        super.save(sender)
        
        let wc: NSWindowController? = getWindowController()
        
        if wc != nil {
            wc!.window?.isDocumentEdited = false
        }
    }

    override func makeWindowControllers() {
        if !windowControllersMade {
            // Returns the Storyboard that contains your Document window.
            let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
            
            let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "Document Window Controller")) as! NSWindowController
            
            self.addWindowController(windowController)
        }
        
        windowControllersMade = false
    }
    
    // Gets the window controller editing the document
    func getWindowController() -> NSWindowController? {
        for windowController: NSWindowController in windowControllers {
            if windowController.document != nil && windowController.document is Document && (windowController.document as! Document) == self {
                return windowController
            }
        }
        
        return nil
    }
    
    // Gets the runner view view controller editing the document
    func getRunnerViewController() -> RunnerViewController? {
        return getWindowController()?.contentViewController as? RunnerViewController
    }
    
    override func data(ofType typeName: String) throws -> Data {
        // Insert code here to write your document to data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning nil.
        // You can also choose to override fileWrapperOfType:error:, writeToURL:ofType:error:, or writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
        
        if let runner: RunnerViewController = getRunnerViewController() {
            return runner.workspaceView.getSaveData()
        }
        
        return Data()
    }

    override func read(from data: Data, ofType typeName: String) throws {
        // Insert code here to read your document from the given data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning false.
        // You can also choose to override readFromFileWrapper:ofType:error: or readFromURL:ofType:error: instead.
        // If you override either of these, you should also override -isEntireFileLoaded to return false if the contents are lazily loaded.
        
        let dataObject: Any? = NSKeyedUnarchiver.unarchiveObject(with: data)
        
        var dataDictionary: NSDictionary?
        
        if dataObject is NSDictionary {
            dataDictionary = dataObject as? NSDictionary
        }
        
        makeWindowControllers()
        windowControllersMade = true
        
        if dataDictionary != nil {
            for windowController: NSWindowController in windowControllers {
                if let document: Document = windowController.document as? Document {
                    if document == self {
                        if let runnerViewController: RunnerViewController = windowController.contentViewController as? RunnerViewController {
                            runnerViewController.workspaceView.loadSaveData(data: dataDictionary!)
                        }
                    }
                }
            }
        }
    }


}

