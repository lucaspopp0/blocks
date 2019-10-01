//
//  WorkspaceView.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/5/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

protocol WorkspaceDelegate {
    
    func blockSelected(_ block: Block?)
    func didPlaceBlock(_ block: Block)
    
}

// This is where the main "building" takes place
class WorkspaceView: NSView {
    
    // Describes the "padding" around the edges of the workspace (space to display around the furthest blocks)
    static let PADDING: CGFloat = 20
    
    // The id that should be assigned to the next block when/if it's created
    static var NEXT_ID: Int = 0
    
    var delegate: WorkspaceDelegate?
    
    // The scroll view
    let scrollView: FlippedScrollView = FlippedScrollView()
    
    // The contents of the scrll view
    let blocksView: FlippedView = FlippedView()
    
    let console: Console = Console()
    
    // Used to track the mouse
    var currentMousePosition: CGPoint = CGPoint.zero
    
    var lastKey: UInt16?
    var keyCount: Int = 0
    
    var data: WorkspaceData = WorkspaceData() {
        willSet {
            for block: Block in data.blocks {
                block.removeFromSuperview()
            }
        }
        
        didSet {
            if !blocksView.subviews.contains(data.startBlock) || !data.blocks.contains(data.startBlock) {
                addBlock(data.startBlock)
            }
            
            for block: Block in data.blocks {
                addBlock(block)
            }
            
            for block: Block in data.blocks {
                if block.isRoot {
                    block.layoutFullObjectHierarchy()
                }
            }
        }
    }
    
    // Used to determine whether or not a touch was a simple click
    var touchMoved: Bool = true
    
    // Variables for handling dragging a block
    var selectedBlock: Block?
    var blockBeingTouched: Block?
    var touchOffset: CGSize?
    
    // The active input (could be a TextInputComponent)
    var activeInput: TextInputComponent?
    
    // "Global" variable that handles loop breaks
    var shouldBreakOutOfLoop: Bool = false
    
    // Variables for handling placing a new block
    var placingBlock: Bool = false
    var blockToPlace: Block?
    var placingOffset: CGSize?
    var wasPlacingOnMouseDown: Bool = false
    
    // Used to track mouse movement
    var trackingArea: NSTrackingArea = NSTrackingArea()
    
    var finishedLoadingData: Bool = false
    
    override var acceptsFirstResponder: Bool {
        get {
            return true
        }
    }
    
    func unifiedInit() {
        scrollView.hasHorizontalScroller = true
        scrollView.hasVerticalScroller = true
        
        addSubview(scrollView)
        scrollView.documentView = blocksView
        
        blocksView.wantsLayer = true
        
        trackingArea = NSTrackingArea(rect: bounds, options: [NSTrackingArea.Options.mouseMoved, NSTrackingArea.Options.activeInKeyWindow], owner: self, userInfo: nil)
        addTrackingArea(trackingArea)
        
        addBlock(data.startBlock)
        
        finishedLoadingData = true
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        unifiedInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        unifiedInit()
    }
    
    // Notifies the window that the contents of the document have changed
    func documentChanged() {
        if window != nil && finishedLoadingData {
            if !window!.isDocumentEdited {
                window!.isDocumentEdited = true
                window!.title = "\(window!.title) - Edited"
            }
        }
    }
    
    func run() {
        data.run()
    }
    
    override func resize(withOldSuperviewSize oldSize: NSSize) {
        super.resize(withOldSuperviewSize: oldSize)
        
        frame.size = superview!.frame.size
        
        removeTrackingArea(trackingArea)
        trackingArea = NSTrackingArea(rect: bounds, options: [NSTrackingArea.Options.mouseMoved, NSTrackingArea.Options.activeInKeyWindow], owner: self, userInfo: nil)
        addTrackingArea(trackingArea)
        
        resizeViews()
    }
    
    func getBlockById(id: Int) -> Block? {
        for block: Block in data.blocks {
            if block.id == id {
                return block
            }
        }
        
        return nil
    }
    
    func beginPlacingBlock(_ block: Block) {
        if blockToPlace != nil {
            removeBlock(blockToPlace!)
        }
        
        placingBlock = true
        blockToPlace = block
        
        block.alphaValue = 0.5
        placingOffset = CGSize(width: -block.frame.size.width / 2, height: -block.frame.size.height / 2)
        
        block.frame.origin = CGPoint(x: -block.frame.size.width * 2, y: -block.frame.size.height * 2)
        block.frame = block.frame.integral
        
        addBlock(block)
    }
    
    func addBlock(_ newBlock: Block) {
        var addToData: Bool = true
        
        for block: Block in data.blocks {
            if block.isEqual(newBlock) {
                if block.superview != nil && block.superview!.isEqual(blocksView) {
                    Swift.print("Attemped to add block \(newBlock.id) (\(type(of: newBlock))) more than once.")
                    return
                } else {
                    addToData = false
                    break
                }
            }
        }
        
        newBlock.workspace = self
        
        if addToData {
            data.blocks.append(newBlock)
        }
        
        blocksView.addSubview(newBlock)
        
        newBlock.layoutObject()
        
        resizeViews()
        
        documentChanged()
    }
    
    // Removes a single block
    @discardableResult func removeBlock(_ block: Block) -> Block? {
        for i in 0 ..< data.blocks.count {
            if data.blocks[i].isEqual(block) {
                block.removeFromSuperview()
                
                block.inputAnchor?.disconnectInput()
                block.disconnectUpperConnection()
                
                if block.lowerConnection.connectedTo != nil && block.lowerConnection.connectedTo is Block {
                    (block.lowerConnection.connectedTo as! Block).disconnectUpperConnection()
                }
                
                let output: Block = data.blocks.remove(at: i)
                
                resizeViews()
                
                documentChanged()
                
                return output
            }
        }
        
        return nil
    }
    
    // Action performed by right clicking on a block and selecting "Delete"
    func deleteBlock(_ block: Block) {
        if block.deletable {
            if block.lowerConnection.connectedTo != nil {
                deleteBlock(block.lowerConnection.connectedTo as! Block)
            }
            
            for inputBlock: Block in block.inputBlocks {
                deleteBlock(inputBlock)
            }
            
            for line: BlockLine in block.lines {
                for component: BlockComponent in line.components {
                    if component is ChunkInputComponent {
                        if (component as! ChunkInputComponent).anchor.connectedTo is Block {
                            deleteBlock((component as! ChunkInputComponent).anchor.connectedTo as! Block)
                        }
                    }
                }
            }
            
            removeBlock(block)
            
            delegate?.blockSelected(nil)
        }
    }
    
    func blockAt(_ point: CGPoint) -> Block? {
        if blocksView.layer != nil && blocksView.layer!.sublayers != nil {
            for subLayer: CALayer in blocksView.layer!.sublayers!.reversed() {
                if subLayer.delegate != nil && subLayer.delegate is Block && (subLayer.delegate as! Block).styleLayer.path != nil && (subLayer.delegate as! Block).styleLayer.path!.contains(CGPoint(x: point.x - (subLayer.delegate as! Block).frame.origin.x, y: (subLayer.delegate as! Block).frame.size.height - (point.y - (subLayer.delegate as! Block).frame.origin.y))) {
                    return subLayer.delegate as? Block
                }
            }
        }
        
        return nil
    }
    
    func componentAt(_ point: CGPoint) -> BlockComponent? {
        let block: Block? = blockAt(point)
        
        if block != nil {
            for line: BlockLine in block!.lines {
                for component: BlockComponent in line.components {
                    if component.frameInWorkspace()!.contains(point) {
                        return component
                    }
                }
            }
        }
        
        return nil
    }
    
    func eventLocationInSelf(event: NSEvent) -> CGPoint {
        var location: CGPoint = self.convert(event.locationInWindow, from: nil)
        
        location.y = frame.size.height - location.y
        
        location.x += scrollView.documentVisibleRect.origin.x
        location.y += scrollView.documentVisibleRect.origin.y
        
        return location
    }
    
    func bringBlockToFront(_ block: Block, handleConnections: Bool = true) {
        blocksView.bringSubview(toFront: block)
        
        if block.lowerConnection.connectedTo != nil {
            bringBlockToFront(block.lowerConnection.connectedTo as! Block)
        }
        
        for inputBlock: Block in block.inputBlocks {
            bringBlockToFront(inputBlock)
        }
        
        for line: BlockLine in block.lines {
            for component: BlockComponent in line.components {
                if component is ChunkInputComponent {
                    if (component as! ChunkInputComponent).anchor.connectedTo is Block {
                        bringBlockToFront((component as! ChunkInputComponent).anchor.connectedTo as! Block)
                    }
                }
            }
        }
    }
    
    func selectBlock(_ block: Block?) {
        selectedBlock?.highlightStyle = Block.HighlightStyle.none
        
        if block != nil && block!.selectable {
            selectedBlock = block
            selectedBlock?.highlightStyle = Block.HighlightStyle.frame
        } else {
            selectedBlock = nil
        }
        
        delegate?.blockSelected(selectedBlock)
    }
    
    // Handle right click
    override func rightMouseDown(with event: NSEvent) {
        super.rightMouseDown(with: event)
        
        let location: CGPoint = eventLocationInSelf(event: event)
        let blockAtLocation: Block? = blockAt(location)
        
        selectBlock(blockAtLocation)
        
        if blockAtLocation != nil {
            NSMenu.popUpContextMenu(blockAtLocation!.contextMenu, with: event, for: blockAtLocation!)
        }
    }
    
    // Handle left click
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        
        let location: CGPoint = eventLocationInSelf(event: event)
        
        currentMousePosition = location
        
        blockBeingTouched = blockAt(location)
        
        // Deselects whatever was previously the first responder (maybe a TextInutComponent)
        window?.makeFirstResponder(blocksView)
        
        touchMoved = false
        
        wasPlacingOnMouseDown = false
        
        // If a block is being placed, place it!
        // It will already have been added to the workspace
        if placingBlock {
            placingBlock = false
            blockToPlace?.alphaValue = 1
            blockToPlace = nil
            placingOffset = nil
            wasPlacingOnMouseDown = true
            
            delegate?.didPlaceBlock(blockBeingTouched!)
            
            documentChanged()
        }
        
        selectBlock(blockBeingTouched)
        
        if blockBeingTouched != nil {
            if blockBeingTouched!.movable {
                touchOffset = CGSize(width: location.x - blockBeingTouched!.frame.origin.x, height: location.y - blockBeingTouched!.frame.origin.y)
                
                if blockBeingTouched!.upperConnection.enabled {
                    touchOffset!.height -= Block.STUB_HEIGHT
                }
                
                bringBlockToFront(blockBeingTouched!)
            } else {
                blockBeingTouched = nil
            }
        }
    }
    
    // Mouse moved (not dragged)
    // Used in placing blocks
    override func mouseMoved(with event: NSEvent) {
        super.mouseMoved(with: event)
        
        var location: CGPoint = eventLocationInSelf(event: event)
        
        currentMousePosition = location
        
        if placingBlock && blockToPlace != nil && placingOffset != nil {
            location.x += placingOffset!.width
            location.y += placingOffset!.height
            
            blockToPlace!.move(to: location)
            
            window?.makeFirstResponder(self)
        }
    }
    
    // Mouse dragged
    // Used in dragging blocks
    override func mouseDragged(with event: NSEvent) {
        super.mouseDragged(with: event)
        
        touchMoved = true
        
        var location: CGPoint = eventLocationInSelf(event: event)
        
        currentMousePosition = location
        
        if blockBeingTouched != nil && touchOffset != nil {
            location.x -= touchOffset!.width
            location.y -= touchOffset!.height
            
            // Move the block to the correct location (according to the mouse)
            blockBeingTouched!.move(to: location)
            
            // Disconnect from whatever the block is currently anchored to
            if blockBeingTouched!.upperConnection.connectedTo != nil {
                blockBeingTouched!.disconnectUpperConnection()
            } else if blockBeingTouched!.inputAnchor != nil {
                blockBeingTouched!.inputAnchor!.disconnectInput()
            }
            
            var directionalHighlightFound: Bool = false
            var highlightFound: Bool = false
            
            // Loop through all blocks, searching for possible interactions to illustrate
            for block: Block in data.blocks {
                if let loopFrame: CGRect = block.frameInWorkspace(),
                    let blockFrame: CGRect = blockBeingTouched!.frameInWorkspace() {
                    if loopFrame.insetBy(dx: -10, dy: -10).intersects(blockFrame.insetBy(dx: -10, dy: -10)) {
                        if !highlightFound && blockBeingTouched!.outputType != DataType.none {
                            for slot in block.slotInputs {
                                // If a highlight has not be found, check if this slot should be highlighted
                                if !highlightFound {
                                    if slot.input == nil && slot.blockIsEligible(blockBeingTouched!) {
                                        if slot.frameInWorkspace()!.intersects(CGRect(origin: CGPoint(x: blockFrame.origin.x, y: blockFrame.origin.y + blockFrame.size.height / 2), size: CGSize(width: 1, height: 1))) {
                                            // If the block is near an empty slot input, highlight the slot
                                            if !slot.isHighlighted {
                                                slot.isHighlighted = true
                                            }
                                            
                                            highlightFound = true
                                            break
                                        }
                                    }
                                }
                                
                                // If we didn't highlight this, but it had already been highlighted, un-highlight it
                                if slot.isHighlighted {
                                    slot.isHighlighted = false
                                }
                            }
                        }
                        
                        if !highlightFound && blockBeingTouched!.upperConnection.enabled {
                            for chunk in block.chunkInputs {
                                // If a highlight has not been found, check if this chunk input should be highlighted
                                if chunk.anchor.connectedTo == nil && !highlightFound {
                                    let stubRect: CGRect = CGRect(x: blockFrame.origin.x + (2 * Block.PADDING), y: blockFrame.origin.y, width: Block.STUB_WIDTH, height: Block.STUB_HEIGHT)
                                    
                                    if chunk.frameInWorkspace()!.intersects(stubRect) {
                                        chunk.isHighlighted = true
                                        highlightFound = true
                                        break
                                    }
                                }
                                
                                if chunk.isHighlighted {
                                    chunk.isHighlighted = false
                                }
                            }
                        }
                        
                        if !block.isEqual(blockBeingTouched!) {
                            if !directionalHighlightFound {
                                if blockBeingTouched!.upperConnection.enabled && block.lowerConnection.enabled && CGPoint.distanceBetween(blockBeingTouched!.topLeftAlignmentCorner, and: block.bottomLeftAlignmentCorner) <= 10 {
                                    directionalHighlightFound = true
                                    
                                    if block.highlightStyle != Block.HighlightStyle.lower {
                                        block.highlightStyle = Block.HighlightStyle.lower
                                    }
                                    
                                    continue
                                }
                            }
                            
                            if block.highlightStyle != Block.HighlightStyle.none {
                                block.highlightStyle = Block.HighlightStyle.none
                            }
                        }
                    }
                }
            }
            
            resizeViews()
        }
    }
    
    // Handles mouse up events
    override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
        
        let location: CGPoint = eventLocationInSelf(event: event)
        
        currentMousePosition = location
        
        if blockBeingTouched != nil {
            // If the touch was not a click
            if touchMoved {
                // Loop through all blocks, to check if the touched block should be anchored to something
                for block: Block in data.blocks {
                    if !block.isEqual(blockBeingTouched!) {
                        if blockBeingTouched!.upperConnection.enabled && block.lowerConnection.enabled && CGPoint.distanceBetween(blockBeingTouched!.topLeftAlignmentCorner, and: block.bottomLeftAlignmentCorner) <= 10 {
                            // Anchor below a block
                            blockBeingTouched!.formUpperConnection(toBlock: block)
                            break
                        } else {
                            var breakAll: Bool = false
                            
                            for line: BlockLine in block.lines {
                                for component: BlockComponent in line.components {
                                    if component is SlotInputComponent && (component as! SlotInputComponent).input == nil && (component as! SlotInputComponent).blockIsEligible(blockBeingTouched!) {
                                        if component.frameInWorkspace()!.intersects(CGRect(origin: blockBeingTouched!.frame.origin, size: CGSize(width: 1, height: blockBeingTouched!.frame.size.height))) {
                                            // Connect to an input
                                            (component as! SlotInputComponent).connectInput(blockBeingTouched!)
                                            
                                            breakAll = true
                                            
                                            break
                                        }
                                    } else if blockBeingTouched!.upperConnection.enabled && component is ChunkInputComponent && (component as! ChunkInputComponent).anchor.connectedTo == nil {
                                        let stubRect: CGRect = CGRect(x: blockBeingTouched!.frame.origin.x + (2 * Block.PADDING), y: blockBeingTouched!.frame.origin.y, width: Block.STUB_WIDTH, height: Block.STUB_HEIGHT)
                                        
                                        if component.frameInWorkspace()!.intersects(stubRect) {
                                            // Connect to a chunk input
                                            blockBeingTouched!.formUpperConnection(toChunkInput: component as! ChunkInputComponent)
                                            break
                                        }
                                    }
                                }
                                
                                if breakAll {
                                    break
                                }
                            }
                            
                            if breakAll {
                                break
                            }
                        }
                    }
                }
            } else if !wasPlacingOnMouseDown {
                // The mouse event was a click, so the user is probably trying to interact with a component
                let componentAtPoint: BlockComponent? = componentAt(location)
                
                if componentAtPoint != nil {
                    if componentAtPoint! is PickerInputComponent {
                        (componentAtPoint as! PickerInputComponent).openMenu()
                    } else if componentAtPoint! is TextInputComponent {
                        (componentAtPoint as! TextInputComponent).enableEditing()
                        window?.makeFirstResponder((componentAtPoint as! TextInputComponent).textField)
                    }
                }
            }
            
            bringBlockToFront(blockBeingTouched!)
        }
        
        blockBeingTouched = nil
        touchOffset = nil
    }
    
    // Cancel placing block
    override func cancelOperation(_ sender: Any?) {
        if placingBlock && blockToPlace != nil {
            removeBlock(blockToPlace!)
            blockToPlace = nil
            placingBlock = false
            placingOffset = nil
            wasPlacingOnMouseDown = false
        }
    }
    
    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        if event.keyCode == 51 || event.keyCode == 35 || event.keyCode == 17 || event.keyCode == 45 ||
            event.keyCode == 11 || event.keyCode == 9 || event.keyCode == 34 || event.keyCode == 24 {
            return true
        }
        
        return false
    }
    
    private func keyBlock(options: [String]) -> Block? {
        let ind = keyCount % options.count
        
        for i in 0 ..< options.count {
            if i == ind {
                return Block.constructFromType(options[i])
            }
        }
        
        return nil
    }
    
    override func keyDown(with event: NSEvent) {
        super.keyDown(with: event)
        
        let DELETE_KEY: UInt16 = 51
        
        let alreadyPlacingBlock = placingBlock
        
        if !alreadyPlacingBlock {
            lastKey = nil
            keyCount = 0
        }
        
        let repeatKey: Bool = (lastKey != nil && lastKey! == event.keyCode)
        
        if !repeatKey {
            keyCount = 0
        }
        
        lastKey = event.keyCode
        
        if event.keyCode == DELETE_KEY && selectedBlock != nil {
            deleteBlock(selectedBlock!)
        } else if event.keyCode == 35 { // p
            let newBlock = PrintBlock()
            beginPlacingBlock(newBlock)
            newBlock.move(to: CGPoint(x: currentMousePosition.x - newBlock.frame.size.width / 2, y: currentMousePosition.y - newBlock.frame.size.height / 2))
        } else if event.keyCode == 17 { // t
            let newBlock: Block? = keyBlock(options: ["TextInputBlock", "ConcatenateTextBlock", "TextLengthBlock", "FindInTextBlock", "CharAtBlock", "SubstringBlock", "TextCaseBlock", "SplitStringBlock"])
            
            if newBlock != nil {
                beginPlacingBlock(newBlock!)
                newBlock!.move(to: CGPoint(x: currentMousePosition.x - newBlock!.frame.size.width / 2, y: currentMousePosition.y - newBlock!.frame.size.height / 2))
            }
        } else if event.keyCode == 45 { // n
            let newBlock = NumberInputBlock()
            beginPlacingBlock(newBlock)
            newBlock.move(to: CGPoint(x: currentMousePosition.x - newBlock.frame.size.width / 2, y: currentMousePosition.y - newBlock.frame.size.height / 2))
        } else if event.keyCode == 11 { // b
            let newBlock = BooleanBlock()
            beginPlacingBlock(newBlock)
            newBlock.move(to: CGPoint(x: currentMousePosition.x - newBlock.frame.size.width / 2, y: currentMousePosition.y - newBlock.frame.size.height / 2))
        } else if event.keyCode == 9 { // v
            let newBlock: Block? = keyBlock(options: ["VariableInitializerBlock", "VariableInitialValueBlock", "VariableSetterBlock", "VariableGetterBlock"])
            
            if newBlock != nil {
                beginPlacingBlock(newBlock!)
                newBlock!.move(to: CGPoint(x: currentMousePosition.x - newBlock!.frame.size.width / 2, y: currentMousePosition.y - newBlock!.frame.size.height / 2))
            }
        } else if event.keyCode == 34 { // i
            let newBlock = IfBlock()
            beginPlacingBlock(newBlock)
            newBlock.move(to: CGPoint(x: currentMousePosition.x - newBlock.frame.size.width / 2, y: currentMousePosition.y - newBlock.frame.size.height / 2))
        } else if event.keyCode == 24 { // =
            let newBlock = EqualityTestBlock()
            beginPlacingBlock(newBlock)
            newBlock.move(to: CGPoint(x: currentMousePosition.x - newBlock.frame.size.width / 2, y: currentMousePosition.y - newBlock.frame.size.height / 2))
        }
        
        if alreadyPlacingBlock && repeatKey {
            keyCount += 1
        } else {
            keyCount = 1
        }
        
        Swift.print(event.keyCode)
    }
    
    override func layout() {
        super.layout()
        
        scrollView.frame = bounds
        
        resizeViews()
    }
    
    func resizeViews() {
        var rightMost: CGFloat = 0
        var bottomMost: CGFloat = 0
        
        for block: Block in data.blocks {
            rightMost = max(rightMost, block.frame.origin.x + block.frame.size.width)
            bottomMost = max(bottomMost, block.frame.origin.y + block.frame.size.height)
        }
        
        let blocksSize: CGSize = CGSize(width: rightMost - WorkspaceView.PADDING, height: bottomMost - WorkspaceView.PADDING)
        
        blocksView.frame.size = CGSize(width: blocksSize.width + WorkspaceView.PADDING * 2, height: blocksSize.height + WorkspaceView.PADDING * 2)
        
        if blocksView.frame.size.width <= scrollView.frame.size.width {
            if scrollView.horizontalScrollElasticity != NSScrollView.Elasticity.none {
                scrollView.horizontalScrollElasticity = NSScrollView.Elasticity.none
            }
        } else {
            if scrollView.horizontalScrollElasticity == NSScrollView.Elasticity.none {
                scrollView.horizontalScrollElasticity = NSScrollView.Elasticity.allowed
            }
        }
        
        if blocksView.frame.size.height <= scrollView.frame.size.height {
            if scrollView.verticalScrollElasticity != NSScrollView.Elasticity.none {
                scrollView.verticalScrollElasticity = NSScrollView.Elasticity.none
            }
        } else {
            if scrollView.verticalScrollElasticity == NSScrollView.Elasticity.none {
                scrollView.verticalScrollElasticity = NSScrollView.Elasticity.allowed
            }
        }
    }
    
    func getSaveData() -> Data {
        let dataDictionary: NSMutableDictionary = NSMutableDictionary()
        let blocksArray: NSMutableArray = NSMutableArray()
        
        // Loops through each block (except the block being placed) and adds their dictionary values to an array
        for block: Block in data.blocks {
            if !(placingBlock && blockToPlace != nil && blockToPlace!.isEqual(block)) {
                blocksArray.add(block.dictionaryValue())
            }
        }
        
        dataDictionary.setValue(WorkspaceView.NEXT_ID, forKey: "nextId")
        dataDictionary.setValue(blocksArray, forKey: "blocks")
        
        return NSKeyedArchiver.archivedData(withRootObject: dataDictionary)
    }
    
    func loadSaveData(data: NSDictionary) {
        finishedLoadingData = false
        
        removeBlock(self.data.startBlock)
        
        if DataManager.dictionary(dictionary: data, hasValueForKey: "blocks") {
            let blocksArray: NSArray = data.value(forKey: "blocks") as! NSArray
            
            // Loop through all of the blocks in the data
            for object: Any in blocksArray {
                if object is NSDictionary {
                    // Attempt to construct the block from its dictionary representatino
                    let newBlock: Block? = Block.constructFromData(object as! NSDictionary)
                    
                    if newBlock != nil {
                        addBlock(newBlock!)
                        
                        if newBlock! is StartBlock {
                            // Replace the start block from that of the workspace
                            self.data.startBlock = newBlock as! StartBlock
                        }
                    }
                }
            }
            
            // Loop through the blocks array again, to connect the blocks with their upper connections, containing ChunkInputComponents, or containing SlotInputComponents
            for object: Any in blocksArray {
                if object is NSDictionary {
                    let dict: NSDictionary = object as! NSDictionary
                    let id: Int = dict.value(forKey: "id") as! Int
                    let block: Block? = self.getBlockById(id: id)
                    
                    if block != nil {
                        // If a block has an upper connection, find that block and connect to it
                        if DataManager.dictionary(dictionary: dict, hasValueForKey: "upperConnectionId") {
                            let upperBlock: Block? = self.getBlockById(id: dict.value(forKey: "upperConnectionId") as! Int)
                            
                            if upperBlock != nil {
                                block!.formUpperConnection(toBlock: upperBlock!)
                            }
                        }
                        
                        var inputIds: [Int]?
                        var blockInputs: [SlotInputComponent] = []
                        var chunkIds: [Int]?
                        var chunkInputs: [ChunkInputComponent] = []
                        
                        // Populate inputIds
                        if DataManager.dictionary(dictionary: dict, hasValueForKey: "inputIds") {
                            let dictInputIds: NSArray = dict.value(forKey: "inputIds") as! NSArray
                            
                            inputIds = []
                            
                            for item: Any in dictInputIds {
                                inputIds!.append(item as! Int)
                            }
                        }
                        
                        // Populate chunkIds
                        if DataManager.dictionary(dictionary: dict, hasValueForKey: "chunkIds") {
                            let dictChunkIds: NSArray = dict.value(forKey: "chunkIds") as! NSArray
                            
                            chunkIds = []
                            
                            for item: Any in dictChunkIds {
                                chunkIds!.append(item as! Int)
                            }
                        }
                        
                        // Populate blockInputs and chunkInputs
                        for line: BlockLine in block!.lines {
                            for component: BlockComponent in line.components {
                                if inputIds != nil && component is SlotInputComponent {
                                    blockInputs.append(component as! SlotInputComponent)
                                } else if chunkIds != nil && component is ChunkInputComponent {
                                    chunkInputs.append(component as! ChunkInputComponent)
                                }
                            }
                        }
                        
                        // Connect the input blocks
                        if inputIds != nil && inputIds!.count == blockInputs.count {
                            for i in 0 ..< blockInputs.count {
                                let input: SlotInputComponent = blockInputs[i]
                                let id: Int = inputIds![i]
                                
                                if id != -1 {
                                    let inputBlock: Block? = self.getBlockById(id: id)
                                    
                                    if inputBlock != nil {
                                        input.connectInput(inputBlock!)
                                    }
                                }
                            }
                        } else {
                            fatalError("When loading save data to Workspace, \"inputIds\" and \"blockInputs\" do not have the same count, but they should.")
                        }
                        
                        // Connect the chunk input blocks
                        if chunkIds != nil && chunkIds!.count == chunkInputs.count {
                            for i in 0 ..< chunkInputs.count {
                                let input: ChunkInputComponent = chunkInputs[i]
                                let id: Int = chunkIds![i]
                                
                                if id != -1 {
                                    let inputBlock: Block? = self.getBlockById(id: id)
                                    
                                    if inputBlock != nil {
                                        inputBlock!.formUpperConnection(toChunkInput: input)
                                    }
                                }
                            }
                        } else {
                            fatalError("When loading save data to Workspace, \"chunkIds\" and \"chunkInputs\" do not have the same count, but they should.")
                        }
                    }
                }
            }
        }
        
        if DataManager.dictionary(dictionary: data, hasValueForKey: "nextId") {
            WorkspaceView.NEXT_ID = data.value(forKey: "nextId") as! Int
        }
        
        for block: Block in self.data.blocks {
            if block.inputAnchor == nil && block.upperConnection.connectedTo == nil {
                self.bringBlockToFront(block)
            }
        }
        
        finishedLoadingData = true
    }
    
}
