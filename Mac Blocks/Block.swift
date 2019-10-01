//
//  Block.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/5/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

// A generic block (to be subclassed)
class Block: InterfaceObject, RowViewDelegate {
    
    var rowViews: [RowView] = []
    
    enum Sizing: String {
        case comfortable = "comfortable"
        case compact = "compact"
    }
    
    enum ConnectionStyle: String {
        case trapezoid = "trapezoid"
        case puzzlePiece = "puzzle piece"
    }
    
    enum BlockStyle: String {
        case rounded = "rounded"
        case rectangle = "rectangle"
        case circle = "circle"
        case trapezoid = "trapezoid"
    }
    
    enum HighlightStyle {
        case none
        case frame
        case lower
    }
    
    // MARK: - Static -
    
    static let COMFORTABLE_PADDING: CGFloat = 6
    static let COMFORTABLE_LINE_SPACING: CGFloat = 3
    
    static let COMPACT_PADDING: CGFloat = 4
    static let COMPACT_LINE_SPACING: CGFloat = 2
    
    static let CORNER_RADIUS: CGFloat = 3
    
    static var PADDING: CGFloat {
        get {
            switch sizing {
            case Sizing.comfortable:
                return COMFORTABLE_PADDING
            case Sizing.compact:
                return COMPACT_PADDING
            }
        }
    }
    
    static var LINE_SPACING: CGFloat {
        get {
            switch sizing {
            case Sizing.comfortable:
                return COMFORTABLE_LINE_SPACING
            case Sizing.compact:
                return COMPACT_LINE_SPACING
            }
        }
    }
    
    static let STUB_HEIGHT: CGFloat = 4
    static let STUB_WIDTH: CGFloat = 16
    
    static let PIECE_HEIGHT: CGFloat = 12
    static let PIECE_WIDTH: CGFloat = 12
    
    static let COMFORTABLE_FONT: NSFont = NSFont.systemFont(ofSize: 13)
    static let COMFORTABLE_BOLD_FONT: NSFont = NSFont.boldSystemFont(ofSize: 13)
    
    static let COMPACT_FONT: NSFont = NSFont.systemFont(ofSize: 12)
    static let COMPACT_BOLD_FONT: NSFont = NSFont.boldSystemFont(ofSize: 12)
    
    static var FONT: NSFont {
        get {
            switch sizing {
            case Sizing.comfortable:
                return COMFORTABLE_FONT
            case Sizing.compact:
                return COMPACT_FONT
            }
        }
    }
    
    static var BOLD_FONT: NSFont {
        get {
            switch sizing {
            case Sizing.comfortable:
                return COMFORTABLE_BOLD_FONT
            case Sizing.compact:
                return COMPACT_BOLD_FONT
            }
        }
    }
    
    static var connectionStyle: ConnectionStyle = ConnectionStyle.trapezoid {
        didSet {
            for window: NSWindow in NSApplication.shared.windows {
                if let runnerController: RunnerViewController = window.windowController?.contentViewController as? RunnerViewController {
                    for block: Block in runnerController.workspaceView.data.blocks {
                        block.layoutObject()
                    }
                    
                    for block: Block in runnerController.sidebarBlocks {
                        block.layoutObject()
                    }
                }
            }
        }
    }
    
    static var blockStyle: BlockStyle = BlockStyle.rounded {
        didSet {
            for window: NSWindow in NSApplication.shared.windows {
                if let runnerController: RunnerViewController = window.windowController?.contentViewController as? RunnerViewController {
                    for block: Block in runnerController.workspaceView.data.blocks {
                        block.layoutObject()
                    }
                    
                    for block: Block in runnerController.sidebarBlocks {
                        block.layoutObject()
                    }
                }
            }
        }
    }
    
    static var sizing: Sizing = Sizing.comfortable {
        didSet {
            for window: NSWindow in NSApplication.shared.windows {
                if let runnerController: RunnerViewController = window.windowController?.contentViewController as? RunnerViewController {
                    for block: Block in runnerController.workspaceView.data.blocks {
                        block.updateStyle()
                        block.layoutObject()
                    }
                    
                    for block: Block in runnerController.sidebarBlocks {
                        block.updateStyle()
                        block.layoutObject()
                    }
                }
            }
        }
    }
    
    // Construct a general block of a specific type {
    static func constructFromType(_ type: String) -> Block? {
        if type == "Block" {
            return Block()
        } else if type == "StartBlock" {
            return StartBlock()
        } else if type == "PrintBlock" {
            return PrintBlock()
        } else if type == "PromptBlock" {
            return PromptBlock()
        } else if type == "BooleanBlock" {
            return BooleanBlock()
        } else if type == "EqualityTestBlock" {
            return EqualityTestBlock()
        } else if type == "AndOrBlock" {
            return AndOrBlock()
        } else if type == "IfBlock" {
            return IfBlock()
        } else if type == "NotBlock" {
            return NotBlock()
        } else if type == "CountLoopBlock" {
            return CountLoopBlock()
        } else if type == "WhileUntilLoopBlock" {
            return WhileUntilLoopBlock()
        } else if type == "SkipLoopBlock" {
            return SkipLoopBlock()
        } else if type == "NumberInputBlock" {
            return NumberInputBlock()
        } else if type == "ArithmeticBlock" {
            return ArithmeticBlock()
        } else if type == "ComplexOperationBlock" {
            return ComplexOperationBlock()
        } else if type == "TrigOperationBlock" {
            return TrigOperationBlock()
        } else if type == "ConstantBlock" {
            return ConstantBlock()
        } else if type == "EvenOddBlock" {
            return EvenOddBlock()
        } else if type == "RoundBlock" {
            return RoundBlock()
        } else if type == "RandomFractionBlock" {
            return RandomFractionBlock()
        } else if type == "RandomBetweenBlock" {
            return RandomBetweenBlock()
        } else if type == "TextInputBlock" {
            return TextInputBlock()
        } else if type == "TextLengthBlock" {
            return TextLengthBlock()
        } else if type == "FindInTextBlock" {
            return FindInTextBlock()
        } else if type == "CharAtBlock" {
            return CharAtBlock()
        } else if type == "SubstringBlock" {
            return SubstringBlock()
        } else if type == "TextCaseBlock" {
            return TextCaseBlock()
        } else if type == "ConcatenateTextBlock" {
            return ConcatenateTextBlock()
        } else if type == "SplitStringBlock" {
            return SplitStringBlock()
        } else if type == "TypeBlock" {
            return TypeBlock()
        } else if type == "TypeOfBlock" {
            return TypeOfBlock()
        } else if type == "TypeIsBlock" {
            return TypeIsBlock()
        } else if type == "AsBlock" {
            return AsBlock()
        } else if type == "ObjectBlock" {
            return ObjectBlock()
        } else if type == "GetObjectPropertyBlock" {
            return GetObjectPropertyBlock()
        } else if type == "SetObjectPropertyBlock" {
            return SetObjectPropertyBlock()
        } else if type == "RemoveObjectPropertyBlock" {
            return RemoveObjectPropertyBlock()
        } else if type == "ListBlock" {
            return ListBlock()
        } else if type == "ListLengthBlock" {
            return ListLengthBlock()
        } else if type == "FindInListBlock" {
            return FindInListBlock()
        } else if type == "ListItemAtIndexBlock" {
            return ListItemAtIndexBlock()
        } else if type == "SetItemInListBlock" {
            return SetItemInListBlock()
        } else if type == "InsertItemInListBlock" {
            return InsertItemInListBlock()
        } else if type == "AddToListBlock" {
            return AddToListBlock()
        } else if type == "VariableInitializerBlock" {
            return VariableInitializerBlock()
        } else if type == "VariableInitialValueBlock" {
            return VariableInitialValueBlock()
        } else if type == "VariableSetterBlock" {
            return VariableSetterBlock()
        } else if type == "VariableGetterBlock" {
            return VariableGetterBlock()
        } else if type == "WindowBlock" {
            return WindowBlock()
        } else if type == "OpenWindowBlock" {
            return OpenWindowBlock()
        } else if type == "ColorBlock" {
            return ColorBlock()
        } else if type == "PresetColorBlock" {
            return PresetColorBlock()
        } else if type == "RGBColorBlock" {
            return RGBColorBlock()
        }
        
        return nil
    }
    
    // Constructs a new block from an NSDictionary
    static func constructFromData(_ data: NSDictionary) -> Block? {
        if data.value(forKey: "type") != nil {
            let type: String = data.value(forKey: "type") as! String
            
            // TODO: Use a switch statement for this
            
            if type == "Block" {
                return Block(data: data)
            } else if type == "StartBlock" {
                return StartBlock(data: data)
            } else if type == "PrintBlock" {
                return PrintBlock(data: data)
            } else if type == "PromptBlock" {
                return PromptBlock(data: data)
            } else if type == "BooleanBlock" {
                return BooleanBlock(data: data)
            } else if type == "EqualityTestBlock" {
                return EqualityTestBlock(data: data)
            } else if type == "AndOrBlock" {
                return AndOrBlock(data: data)
            } else if type == "IfBlock" {
                return IfBlock(data: data)
            } else if type == "NotBlock" {
                return NotBlock(data: data)
            } else if type == "CountLoopBlock" {
                return CountLoopBlock(data: data)
            } else if type == "WhileUntilLoopBlock" {
                return WhileUntilLoopBlock(data: data)
            } else if type == "SkipLoopBlock" {
                return SkipLoopBlock(data: data)
            } else if type == "NumberInputBlock" {
                return NumberInputBlock(data: data)
            } else if type == "ArithmeticBlock" {
                return ArithmeticBlock(data: data)
            } else if type == "ComplexOperationBlock" {
                return ComplexOperationBlock(data: data)
            } else if type == "TrigOperationBlock" {
                return TrigOperationBlock(data: data)
            } else if type == "ConstantBlock" {
                return ConstantBlock(data: data)
            } else if type == "EvenOddBlock" {
                return EvenOddBlock(data: data)
            } else if type == "RoundBlock" {
                return RoundBlock(data: data)
            } else if type == "RandomFractionBlock" {
                return RandomFractionBlock(data: data)
            } else if type == "RandomBetweenBlock" {
                return RandomBetweenBlock(data: data)
            } else if type == "TextInputBlock" {
                return TextInputBlock(data: data)
            } else if type == "TextLengthBlock" {
                return TextLengthBlock(data: data)
            } else if type == "FindInTextBlock" {
                return FindInTextBlock(data: data)
            } else if type == "CharAtBlock" {
                return CharAtBlock(data: data)
            } else if type == "SubstringBlock" {
                return SubstringBlock(data: data)
            } else if type == "TextCaseBlock" {
                return TextCaseBlock(data: data)
            } else if type == "ConcatenateTextBlock" {
                return ConcatenateTextBlock(data: data)
            } else if type == "SplitStringBlock" {
                return SplitStringBlock(data: data)
            } else if type == "TypeBlock" {
                return TypeBlock(data: data)
            } else if type == "TypeOfBlock" {
                return TypeOfBlock(data: data)
            } else if type == "TypeIsBlock" {
                return TypeIsBlock(data: data)
            } else if type == "AsBlock" {
                return AsBlock(data: data)
            } else if type == "ObjectBlock" {
                return ObjectBlock(data: data)
            } else if type == "GetObjectPropertyBlock" {
                return GetObjectPropertyBlock(data: data)
            } else if type == "SetObjectPropertyBlock" {
                return SetObjectPropertyBlock(data: data)
            } else if type == "RemoveObjectPropertyBlock" {
                return RemoveObjectPropertyBlock(data: data)
            } else if type == "ListBlock" {
                return ListBlock(data: data)
            } else if type == "ListLengthBlock" {
                return ListLengthBlock(data: data)
            } else if type == "FindInListBlock" {
                return FindInListBlock(data: data)
            } else if type == "ListItemAtIndexBlock" {
                return ListItemAtIndexBlock(data: data)
            } else if type == "SetItemInListBlock" {
                return SetItemInListBlock(data: data)
            } else if type == "InsertItemInListBlock" {
                return InsertItemInListBlock(data: data)
            } else if type == "AddToListBlock" {
                return AddToListBlock(data: data)
            } else if type == "VariableInitializerBlock" {
                return VariableInitializerBlock(data: data)
            } else if type == "VariableInitialValueBlock" {
                return VariableInitialValueBlock(data: data)
            } else if type == "VariableSetterBlock" {
                return VariableSetterBlock(data: data)
            } else if type == "VariableGetterBlock" {
                return VariableGetterBlock(data: data)
            } else if type == "WindowBlock" {
                return WindowBlock(data: data)
            } else if type == "OpenWindowBlock" {
                return OpenWindowBlock(data: data)
            } else if type == "ColorBlock" {
                return ColorBlock(data: data)
            } else if type == "PresetColorBlock" {
                return PresetColorBlock(data: data)
            } else if type == "RGBColorBlock" {
                return RGBColorBlock(data: data)
            }
        }
        
        return nil
    }
    
    // MARK: - Instance -
    
    // MARK: Properties -
    
    // MARK: Basic properties
    
    // The containing workspace, if there is one
    var workspace: WorkspaceView?
    
    // The lines that make up the block (read only)
    private(set) var lines: [BlockLine] = []
    
    var id: Int = -1
    
    var movable: Bool = true
    var selectable: Bool = true
    var deletable: Bool = true
    
    var outputType: DataType = DataType.none
    
    var blockDescription: String {
        get {
            return ""
        }
    }
    
    // The context menu to be shown if the block was right-clicked
    let contextMenu: NSMenu = NSMenu(title: "Context Menu")
    
    override var fillColor: NSColor {
        didSet {
            super.fillColor = fillColor
            
            updateStyle()
        }
    }
    
    var textColor: NSColor = BlockColor.darkTextColor {
        didSet {
            updateStyle()
        }
    }
    
    var highlightStyle: HighlightStyle = HighlightStyle.none {
        didSet {
            redraw()
        }
    }
    
    // MARK: Inputs & connections
    
    // The input component containing the block, if there is one
    var inputAnchor: BlockInputComponent?
    
    // A list of all the inputs connected to this block
    var inputBlocks: [Block] = []
    
    var upperConnection: VerticalConnection = VerticalConnection()
    var lowerConnection: VerticalConnection = VerticalConnection()
    
    // Updated as components are added/removed
    var slotInputs: [SlotInputComponent] = []
    var chunkInputs: [ChunkInputComponent] = []
    
    // MARK: Computed properties
    
    var topLeftAlignmentCorner: CGPoint {
        get {
            if upperConnection.enabled {
                switch Block.connectionStyle {
                case ConnectionStyle.trapezoid:
                    return CGPoint(x: frame.origin.x, y: frame.origin.y + Block.STUB_HEIGHT)
                case ConnectionStyle.puzzlePiece:
                    return frame.origin
                }
            } else {
                return frame.origin
            }
        }
    }
    
    var bottomLeftAlignmentCorner: CGPoint {
        get {
            if Block.connectionStyle == ConnectionStyle.trapezoid {
                return CGPoint(x: frame.origin.x, y: frame.origin.y + frame.size.height - borderWidth)
            } else {
                if lowerConnection.enabled {
                    return CGPoint(x: frame.origin.x, y: frame.origin.y + frame.size.height - borderWidth - (Block.STUB_HEIGHT * 1.5) - 2 * borderWidth)
                } else {
                    return CGPoint(x: frame.origin.x, y: frame.origin.y + frame.size.height - borderWidth)
                }
            }
        }
    }
    
    // True if the block is not a child of any other block
    var isRoot: Bool {
        get {
            return (upperConnection.connectedTo == nil && inputAnchor == nil)
        }
    }
    
    // MARK: - Methods -
    
    // MARK: Initializers
    
    required init(origin: CGPoint = CGPoint.zero) {
        super.init(frame: CGRect(origin: origin, size: CGSize.zero))
        
        id = WorkspaceView.NEXT_ID
        WorkspaceView.NEXT_ID += 1
        
        borderWidth = max(1.5 / (NSScreen.main?.backingScaleFactor ?? 1), 0.75)
        
        upperConnection.enabled = false
        lowerConnection.enabled = false
        
        buildContextMenu()
    }
    
    // Initializes a block from data
    convenience init(data: NSDictionary) {
        self.init()
        
        if DataManager.dictionary(dictionary: data, hasValuesForKeys: "x", "y") {
            frame.origin = CGPoint(x: data.value(forKey: "x") as! CGFloat, y: data.value(forKey: "y") as! CGFloat)
        }
        
        if DataManager.dictionary(dictionary: data, hasValueForKey: "id") {
            id = data.value(forKey: "id") as! Int
        }
        
        applyTypeRelatedProperties(data)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Data
    
    // To be overwritten by subclasses. Applies the specific properties of a block
    func applyTypeRelatedProperties(_ data: NSDictionary) {}
    
    // Outputs the data necessary to replicate the block
    func dictionaryValue() -> NSDictionary {
        let output: NSMutableDictionary = NSMutableDictionary()
        
        output.setValue(frame.origin.x, forKey: "x")
        output.setValue(frame.origin.y, forKey: "y")
        output.setValue(String(describing: type(of: self)), forKey: "type")
        output.setValue(id, forKey: "id")
        
        if upperConnection.connectedTo != nil && upperConnection.connectedTo is Block {
            output.setValue((upperConnection.connectedTo as! Block).id, forKey: "upperConnectionId")
        }
        
        let inputIds: NSMutableArray = NSMutableArray()
        let chunkIds: NSMutableArray = NSMutableArray()
        
        for line: BlockLine in lines {
            for component: BlockComponent in line.components {
                if component is SlotInputComponent {
                    if (component as! SlotInputComponent).input == nil {
                        inputIds.add(-1)
                    } else {
                        inputIds.add((component as! SlotInputComponent).input!.id)
                    }
                } else if component is ChunkInputComponent {
                    if (component as! ChunkInputComponent).anchor.connectedTo == nil {
                        chunkIds.add(-1)
                    } else {
                        chunkIds.add(((component as! ChunkInputComponent).anchor.connectedTo as! Block).id)
                    }
                }
            }
        }
        
        output.setValue(inputIds, forKey: "inputIds")
        output.setValue(chunkIds, forKey: "chunkIds")
        
        // Gets the properties of the specific block (specified by subclass)
        let properties: NSDictionary = typeRelatedProperties()
        
        for key: Any in properties.allKeys {
            output.setValue(properties.object(forKey: key), forKey: key as! String)
        }
        
        return output
    }
    
    // To overwritten by subclasses to provide the necessary data to replicate the block
    func typeRelatedProperties() -> NSMutableDictionary {
        return NSMutableDictionary()
    }
    
    // MARK: Context menu functions
    
    func buildContextMenu() {
        let duplicateItem: NSMenuItem = NSMenuItem(title: "Duplicate", action: nil, keyEquivalent: "")
        let duplicateMenu: NSMenu = NSMenu(title: "Duplicate")
        duplicateMenu.addItem(withTitle: "This block", action: #selector(Block.duplicateSelf), keyEquivalent: "")
        duplicateMenu.addItem(withTitle: "This block with connected block", action: #selector(Block.duplicateGroup), keyEquivalent: "")
        
        duplicateItem.submenu = duplicateMenu
        
        contextMenu.addItem(duplicateItem)
        contextMenu.addItem(withTitle: "Delete", action: #selector(Block.deleteSelf), keyEquivalent: "")
    }
    
    // MARK: Interaction with workspace
    
    func move(to point: CGPoint) {
        if upperConnection.enabled {
            switch Block.connectionStyle {
            case ConnectionStyle.trapezoid:
                frame.origin = CGPoint(x: point.x, y: point.y - Block.STUB_HEIGHT)
                break
            case ConnectionStyle.puzzlePiece:
                frame.origin = point
                break
            }
        } else {
            frame.origin = point
        }
        
        positionInputs()
        positionConnections()
        
        workspace?.resizeViews()
        
        workspace?.documentChanged()
    }
    
    @objc func deleteSelf() {
        if workspace != nil && deletable {
            workspace!.deleteBlock(self)
        }
    }
    
    @objc func duplicateSelf() {
        let ownDuplicate: Block = self.duplicate()
        var newOrigin: CGPoint = frame.origin
        
        newOrigin.x += WorkspaceView.PADDING
        newOrigin.y += WorkspaceView.PADDING
        
        workspace?.addBlock(ownDuplicate)
        ownDuplicate.move(to: newOrigin)
        workspace?.bringBlockToFront(ownDuplicate)
    }
    
    @objc func duplicateGroup() -> Block {
        let ownDuplicate: Block = self.duplicate()
        
        workspace?.addBlock(ownDuplicate)
        
        if lowerConnection.connectedTo != nil {
            let lowerGroup: Block = (lowerConnection.connectedTo as! Block).duplicateGroup()
            lowerGroup.formUpperConnection(toBlock: ownDuplicate)
        }
        
        var newOrigin: CGPoint = frame.origin
        
        newOrigin.x += WorkspaceView.PADDING
        newOrigin.y += WorkspaceView.PADDING
        
        ownDuplicate.move(to: newOrigin)
        
        return ownDuplicate
    }
    
    func duplicate() -> Block {
        fatalError("duplicate() has not been implemented")
    }
    
    // MARK: Lines
    
    func added(component: BlockComponent, to line: BlockLine) {
        if component is SlotInputComponent {
            slotInputs.append(component as! SlotInputComponent)
        } else if component is ChunkInputComponent {
            chunkInputs.append(component as! ChunkInputComponent)
        }
    }
    
    func removed(component: BlockComponent, from line: BlockLine) {
        if component is SlotInputComponent {
            if let ind: Int = slotInputs.index(of: component as! SlotInputComponent) {
                slotInputs.remove(at: ind)
            }
        } else if component is ChunkInputComponent {
            if let ind: Int = chunkInputs.index(of: component as! ChunkInputComponent) {
                chunkInputs.remove(at: ind)
            }
        }
    }
    
    func addLine(_ newLine: BlockLine, at index: Int? = nil) {
        for line: BlockLine in lines {
            if line.isEqual(newLine) {
                Swift.print("Attempted to add duplicated BlockLine in block \(id).")
                return
            }
        }
        
        if index != nil && index! >= 0 && index! < lines.count {
            lines.insert(newLine, at: index!)
        } else {
            lines.append(newLine)
        }
        
        newLine.container = self
        addSubview(newLine)
        
        newLine.updateStyle()
        
        for component: BlockComponent in newLine.components {
            if component is SlotInputComponent {
                slotInputs.append(component as! SlotInputComponent)
            } else if component is ChunkInputComponent {
                chunkInputs.append(component as! ChunkInputComponent)
            }
        }
        
        layoutObject()
    }
    
    func addLines(_ lines: BlockLine...) {
        for line: BlockLine in lines {
            addLine(line)
        }
    }
    
    @discardableResult func removeLine(_ line: BlockLine) -> BlockLine? {
        for i in 0 ..< lines.count {
            if lines[i].isEqual(line) {
                line.removeFromSuperview()
                
                let output: BlockLine = lines.remove(at: i)
                
                for component in output.components {
                    if component is SlotInputComponent {
                        if let ind: Int = slotInputs.index(of: component as! SlotInputComponent) {
                            slotInputs.remove(at: ind)
                        }
                    } else if component is ChunkInputComponent {
                        if let ind: Int = chunkInputs.index(of: component as! ChunkInputComponent) {
                            chunkInputs.remove(at: ind)
                        }
                    }
                }
                
                layoutObject()
                
                return output
            }
        }
        
        return nil
    }
    
    @discardableResult func removeLine(at index: Int) -> BlockLine? {
        if index < lines.count {
            return removeLine(lines[index])
        } else {
            return nil
        }
    }
    
    // MARK: Inputs
    
    func addInput(_ newInput: Block) {
        for block: Block in inputBlocks {
            if block.isEqual(newInput) {
                return
            }
        }
        
        inputBlocks.append(newInput)
        
        layoutObject()
    }
    
    @discardableResult func removeInput(_ input: Block) -> Block? {
        for i in 0 ..< inputBlocks.count {
            if inputBlocks[i].isEqual(input) {
                let output: Block = inputBlocks.remove(at: i)
                
                layoutObject()
                
                return output
            }
        }
        
        return nil
    }
    
    // MARK: Connections
    
    // Gets the lowest connection from a chain of blocks
    func lowestConnection() -> Block {
        if lowerConnection.connectedTo == nil {
            return self
        } else {
            return (lowerConnection.connectedTo as! Block).lowestConnection()
        }
    }
    
    func formUpperConnection(toBlock block: Block) {
        if upperConnection.enabled {
            var shouldRearrange: Bool = false
            
            if block.lowerConnection.connectedTo != nil {
                let previousLower: Block = (block.lowerConnection.connectedTo as! Block)
                previousLower.disconnectUpperConnection()
                
                previousLower.formUpperConnection(toBlock: lowestConnection())
                shouldRearrange = true
            }
            
            upperConnection.connectedTo = block
            
            move(to: block.bottomLeftAlignmentCorner)
            
            block.formLowerConnection(to: self)
            
            layoutFullObjectHierarchy()
            
            if shouldRearrange {
                workspace?.bringBlockToFront(self)
            }
        }
    }
    
    func formUpperConnection(toChunkInput input: ChunkInputComponent) {
        if upperConnection.enabled {
            upperConnection.connectedTo = input
            move(to: input.inputPosition)
            
            input.isHighlighted = false
            
            input.anchor.connectedTo = self
            
            layoutFullObjectHierarchy()
        }
    }
    
    func formLowerConnection(to block: Block) {
        if lowerConnection.enabled {
            lowerConnection.connectedTo = block
            
            highlightStyle = HighlightStyle.none
            
            redraw()
        }
    }
    
    func disconnectUpperConnection() {
        if upperConnection.connectedTo != nil {
            if upperConnection.connectedTo is Block {
                (upperConnection.connectedTo as! Block).disconnectLowerConnection()
                upperConnection.connectedTo = nil
            } else if upperConnection.connectedTo is ChunkInputComponent {
                let component: ChunkInputComponent = (upperConnection.connectedTo as! ChunkInputComponent)
                
                component.anchor.connectedTo = nil
                upperConnection.connectedTo = nil
                
                component.layoutFullObjectHierarchy()
            }
        }
        
        redraw()
    }
    
    func disconnectLowerConnection() {
        lowerConnection.connectedTo = nil
        
        layoutFullObjectHierarchy()
    }
    
    // MARK: Positioning, layout, and drawing
    
    func frameWithChildren() -> CGRect {
        var frames: [CGRect] = []
        
        frames.append(self.frame)
        
        if lowerConnection.connectedTo != nil {
            frames.append((lowerConnection.connectedTo as! Block).frameWithChildren())
        }
        
        var minX: CGFloat = self.frame.origin.x
        var minY: CGFloat = self.frame.origin.y
        var maxWidth: CGFloat = self.frame.size.width
        var maxHeight: CGFloat = self.frame.size.height
        
        for frame: CGRect in frames {
            minX = min(minX, frame.origin.x)
            minY = min(minY, frame.origin.y)
        }
        
        for frame : CGRect in frames {
            maxWidth = max(maxWidth, frame.origin.x + frame.size.width - minX)
            maxHeight = max(maxHeight, frame.origin.y + frame.size.height - minY)
        }
        
        return CGRect(x: minX, y: minY, width: maxWidth, height: maxHeight)
    }
    
    // Moves all of the connected inputs to their correct positions
    func positionInputs() {
        for block: Block in inputBlocks {
            let anchorComponent: BlockInputComponent = block.inputAnchor!
            
            block.move(to: anchorComponent.frameInWorkspace()!.origin)
        }
    }
    
    // Moves all connections to their correct positions
    func positionConnections() {
        (lowerConnection.connectedTo as! Block?)?.move(to: self.bottomLeftAlignmentCorner)
        
        for line: BlockLine in lines {
            for component: BlockComponent in line.components {
                if component is ChunkInputComponent && (component as! ChunkInputComponent).anchor.connectedTo != nil {
                    ((component as! ChunkInputComponent).anchor.connectedTo as! Block).move(to: (component as! ChunkInputComponent).inputPosition)
                }
            }
        }
    }
    
    override func updateStyle() {
        super.updateStyle()
        
        for line: BlockLine in lines {
            line.updateStyle()
        }
    }
    
    override func layoutObject() {
        var topOffset: CGFloat = 0
        var bottomOffset: CGFloat = 0
        var leftOffset: CGFloat = 0
        
        if upperConnection.enabled {
            switch Block.connectionStyle {
            case ConnectionStyle.trapezoid:
                topOffset = Block.STUB_HEIGHT
                break
            case ConnectionStyle.puzzlePiece:
                topOffset = Block.PIECE_HEIGHT / 2
                break
            }
        }
        
        if lowerConnection.enabled {
            switch Block.connectionStyle {
            case ConnectionStyle.trapezoid:
                bottomOffset = Block.STUB_HEIGHT
                break
            case ConnectionStyle.puzzlePiece:
                bottomOffset = Block.PIECE_HEIGHT / 2
                break
            }
        }
        
        if outputType != DataType.none {
            switch Block.connectionStyle {
            case ConnectionStyle.trapezoid:
                leftOffset = Block.STUB_HEIGHT
                break
            case ConnectionStyle.puzzlePiece:
                leftOffset = Block.PIECE_HEIGHT
                break
            }
        }
        
        var totalHeight: CGFloat = 0
        var currentTop: CGFloat = 0
        var maxWidth: CGFloat = 0
        
        for line: BlockLine in lines {
            line.layoutObject()
            line.frame.origin.x = leftOffset + Block.PADDING
            
            maxWidth = max(maxWidth, leftOffset + line.frame.size.width + (2 * Block.PADDING))
            totalHeight += line.frame.size.height
        }
        
        totalHeight += 2 * Block.PADDING
        totalHeight += bottomOffset
        totalHeight += topOffset
        totalHeight += CGFloat(lines.count - 1) * Block.LINE_SPACING
        
        currentTop = totalHeight - Block.PADDING - topOffset
        
        for line: BlockLine in lines {
            currentTop -= line.frame.size.height
            
            line.frame.origin.y = currentTop
            
            currentTop -= Block.LINE_SPACING
            
            if line.fullWidth {
                line.extendFully(lineWidth: maxWidth - (2 * Block.PADDING) - leftOffset)
            }
        }
        
        frame.size = CGSize(width: maxWidth, height: totalHeight)
        
        super.layoutObject()
        
        positionInputs()
        positionConnections()
        
        lowerConnection.connectedTo?.layoutObject()
        
        workspace?.resizeViews()
    }
    
    override func redraw() {
        super.redraw()
        
        var topOffset: CGFloat = 0
        var bottomOffset: CGFloat = 0
        var leftOffset: CGFloat = 0
        
        if upperConnection.enabled {
            switch Block.connectionStyle {
            case ConnectionStyle.trapezoid:
                topOffset = Block.STUB_HEIGHT
                break
            case ConnectionStyle.puzzlePiece:
                topOffset = Block.PIECE_HEIGHT / 2
                break
            }
        }
        
        if lowerConnection.enabled {
            switch Block.connectionStyle {
            case ConnectionStyle.trapezoid:
                bottomOffset = Block.STUB_HEIGHT
                break
            case ConnectionStyle.puzzlePiece:
                bottomOffset = Block.PIECE_HEIGHT / 2
                break
            }
        }
        
        if outputType != DataType.none {
            switch Block.connectionStyle {
            case ConnectionStyle.trapezoid:
                leftOffset = Block.STUB_HEIGHT
                break
            case ConnectionStyle.puzzlePiece:
                leftOffset = Block.PIECE_HEIGHT
                break
            }
        }
        
        var borderPath: CGMutablePath = CGMutablePath()
        let stylePath: CGMutablePath = CGMutablePath()
        
        let highlightWidth: CGFloat = 1
        
        let highlightPath: CGMutablePath = CGMutablePath()
        let outerHighlightPath: CGMutablePath = CGMutablePath()
        let innerHighlightPath: CGMutablePath = CGMutablePath()
        
        let borderRadius: CGFloat = Block.CORNER_RADIUS
        let styleRadius: CGFloat = Block.CORNER_RADIUS - borderWidth

        var borderY: CGFloat = bounds.size.height
        var styleY: CGFloat = borderY - borderWidth
        
        // If the connections aren't puzzle pieces, shift the drawing down to accomodate the connection type
        if Block.connectionStyle != ConnectionStyle.puzzlePiece {
            borderY -= topOffset
            styleY -= topOffset
        }
        
        // Draws the upper left corner of the block
        if !(upperConnection.connectedTo is Block) {
            if Block.blockStyle == Block.BlockStyle.rounded {
                borderPath.move(to: CGPoint(x: leftOffset, y: borderY - borderRadius))
                stylePath.move(to: CGPoint(x: leftOffset + borderWidth, y: styleY - styleRadius))
                
                borderPath.addArc(center: CGPoint(x: leftOffset + borderRadius, y: borderY - borderRadius), radius: borderRadius, startAngle: CGFloat.pi, endAngle: CGFloat.pi * 0.5, clockwise: true)
                stylePath.addArc(center: CGPoint(x: leftOffset + borderRadius, y: styleY - styleRadius), radius: styleRadius, startAngle: CGFloat.pi, endAngle: CGFloat.pi * 0.5, clockwise: true)
                
                if highlightStyle == HighlightStyle.frame {
                    outerHighlightPath.move(to: CGPoint(x: leftOffset, y: borderY - borderRadius))
                    innerHighlightPath.move(to: CGPoint(x: leftOffset + highlightWidth, y: borderY - borderRadius))
                    
                    outerHighlightPath.addArc(center: CGPoint(x: leftOffset + borderRadius, y: borderY - borderRadius), radius: borderRadius, startAngle: CGFloat.pi, endAngle: CGFloat.pi * 0.5, clockwise: true)
                    innerHighlightPath.addArc(center: CGPoint(x: leftOffset + borderRadius, y: borderY - borderRadius), radius: borderRadius - highlightWidth, startAngle: CGFloat.pi, endAngle: CGFloat.pi * 0.5, clockwise: true)
                }
            } else if Block.blockStyle == Block.BlockStyle.rectangle {
                borderPath.move(to: CGPoint(x: leftOffset, y: borderY))
                stylePath.move(to: CGPoint(x: leftOffset + borderWidth, y: styleY))
                
                if highlightStyle == HighlightStyle.frame {
                    outerHighlightPath.move(to: CGPoint(x: leftOffset, y: borderY))
                    innerHighlightPath.move(to: CGPoint(x: leftOffset + highlightWidth, y: borderY - highlightWidth))
                }
            } else if Block.blockStyle == Block.BlockStyle.trapezoid {
                borderPath.move(to: CGPoint(x: leftOffset, y: borderY - borderRadius))
                borderPath.addLine(to: CGPoint(x: leftOffset + borderRadius, y: borderY))
                
                let d: CGFloat = borderWidth / CGFloat(tan(67.5 * CGFloat.pi / 180))
                
                stylePath.move(to: CGPoint(x: leftOffset + borderWidth, y: borderY - borderRadius - d))
                stylePath.addLine(to: CGPoint(x: leftOffset + borderRadius + d, y: styleY))
                
                if highlightStyle == HighlightStyle.frame {
                    let hd: CGFloat = highlightWidth / CGFloat(tan(67.5 * CGFloat.pi / 180))
                    
                    outerHighlightPath.move(to: CGPoint(x: leftOffset, y: borderY - borderRadius))
                    outerHighlightPath.addLine(to: CGPoint(x: leftOffset + borderRadius, y: borderY))
                    
                    innerHighlightPath.move(to: CGPoint(x: leftOffset + highlightWidth, y: borderY - borderRadius - hd))
                    innerHighlightPath.addLine(to: CGPoint(x: leftOffset + borderRadius + hd, y: borderY - highlightWidth))
                }
            }
        } else {
            borderPath.move(to: CGPoint(x: leftOffset, y: borderY))
            stylePath.move(to: CGPoint(x: leftOffset + borderWidth, y: styleY))
            
            if highlightStyle == HighlightStyle.frame {
                outerHighlightPath.move(to: CGPoint(x: leftOffset, y: borderY))
                innerHighlightPath.move(to: CGPoint(x: leftOffset + highlightWidth, y: borderY - highlightWidth))
            }
        }
        
        // Draws the connection (if there is one)
        if upperConnection.enabled {
            if Block.connectionStyle == ConnectionStyle.trapezoid {
                let dx: CGFloat = borderWidth / CGFloat(tan(3 * Double.pi / 8))
                
                stylePath.addLine(to: CGPoint(x: leftOffset + (2 * Block.PADDING) + dx, y: styleY))
                stylePath.addLine(to: CGPoint(x: leftOffset + (2 * Block.PADDING) + Block.STUB_HEIGHT + dx, y: styleY + Block.STUB_HEIGHT))
                stylePath.addLine(to: CGPoint(x: leftOffset + (2 * Block.PADDING) + Block.STUB_WIDTH - Block.STUB_HEIGHT - dx, y: styleY + Block.STUB_HEIGHT))
                stylePath.addLine(to: CGPoint(x: leftOffset + (2 * Block.PADDING) + Block.STUB_WIDTH - dx, y: styleY))
                
                if highlightStyle == HighlightStyle.frame {
                    let dh: CGFloat = highlightWidth / CGFloat(tan(3 * Double.pi / 8))
                    
                    outerHighlightPath.addLine(to: CGPoint(x: leftOffset + (2 * Block.PADDING), y: borderY))
                    outerHighlightPath.addLine(to: CGPoint(x: leftOffset + (2 * Block.PADDING) + Block.STUB_HEIGHT, y: borderY + Block.STUB_HEIGHT))
                    outerHighlightPath.addLine(to: CGPoint(x: leftOffset + (2 * Block.PADDING) + Block.STUB_WIDTH - Block.STUB_HEIGHT, y: borderY + Block.STUB_HEIGHT))
                    outerHighlightPath.addLine(to: CGPoint(x: leftOffset + (2 * Block.PADDING) + Block.STUB_WIDTH, y: borderY))
                    
                    innerHighlightPath.addLine(to: CGPoint(x: leftOffset + (2 * Block.PADDING) + dh, y: borderY - highlightWidth))
                    innerHighlightPath.addLine(to: CGPoint(x: leftOffset + (2 * Block.PADDING) + Block.STUB_HEIGHT + dh, y: borderY - highlightWidth + Block.STUB_HEIGHT))
                    innerHighlightPath.addLine(to: CGPoint(x: leftOffset + (2 * Block.PADDING) + Block.STUB_WIDTH - Block.STUB_HEIGHT - dx, y: borderY - highlightWidth + Block.STUB_HEIGHT))
                    innerHighlightPath.addLine(to: CGPoint(x: leftOffset + (2 * Block.PADDING) + Block.STUB_WIDTH - dh, y: borderY - highlightWidth))
                } else {
                    borderPath.addLine(to: CGPoint(x: leftOffset + (2 * Block.PADDING), y: borderY))
                    borderPath.addLine(to: CGPoint(x: leftOffset + (2 * Block.PADDING) + Block.STUB_HEIGHT, y: borderY + Block.STUB_HEIGHT))
                    borderPath.addLine(to: CGPoint(x: leftOffset + (2 * Block.PADDING) + Block.STUB_WIDTH - Block.STUB_HEIGHT, y: borderY + Block.STUB_HEIGHT))
                    borderPath.addLine(to: CGPoint(x: leftOffset + (2 * Block.PADDING) + Block.STUB_WIDTH, y: borderY))
                }
            } else if Block.connectionStyle == ConnectionStyle.puzzlePiece {
                let d: CGFloat = Block.STUB_HEIGHT
                let r: CGFloat = ((4 * d) + (d * sqrt(8))) / 4
                let w = (4 * r) / sqrt(2)
                
                let A: CGPoint = CGPoint(x: leftOffset + (2 * Block.PADDING), y: styleY - r)
                let B: CGPoint = CGPoint(x: leftOffset + (2 * Block.PADDING) + (w / 2), y: A.y + (2 * r / sqrt(2)))
                let C: CGPoint = CGPoint(x: leftOffset + (2 * Block.PADDING) + w, y: A.y)
                
                stylePath.addArc(center: A, radius: r, startAngle: CGFloat.pi * 0.5, endAngle: CGFloat.pi * 0.25, clockwise: true)
                stylePath.addArc(center: B, radius: r, startAngle: CGFloat.pi * 1.25, endAngle: CGFloat.pi * 1.75, clockwise: false)
                stylePath.addArc(center: C, radius: r, startAngle: CGFloat.pi * 0.75, endAngle: CGFloat.pi * 0.5, clockwise: true)
            }
        }
        
        // Draws each line
        for i in 0 ..< lines.count {
            // Align styleY with the top of the line
            if i == 0 {
                // First line
                if Block.blockStyle == Block.BlockStyle.rounded {
                    let arcCenter: CGPoint = CGPoint(x: leftOffset + Block.PADDING + lines[i].frame.size.width + Block.PADDING - borderRadius, y: borderY - borderRadius)
                    
                    borderPath.addArc(center: arcCenter, radius: borderRadius, startAngle: CGFloat.pi * 0.5, endAngle: 0, clockwise: true)
                    stylePath.addArc(center: arcCenter, radius: borderRadius - borderWidth, startAngle: CGFloat.pi * 0.5, endAngle: 0, clockwise: true)
                    
                    if highlightStyle == HighlightStyle.frame {
                        outerHighlightPath.addArc(center: arcCenter, radius: borderRadius, startAngle: CGFloat.pi * 0.5, endAngle: 0, clockwise: true)
                        innerHighlightPath.addArc(center: arcCenter, radius: borderRadius - highlightWidth, startAngle: CGFloat.pi * 0.5, endAngle: 0, clockwise: true)
                    }
                } else if Block.blockStyle == Block.BlockStyle.rectangle {
                    borderPath.addLine(to: CGPoint(x: leftOffset + Block.PADDING + lines[i].frame.size.width + Block.PADDING, y: borderY))
                    stylePath.addLine(to: CGPoint(x: leftOffset + Block.PADDING + lines[i].frame.size.width + Block.PADDING - borderWidth, y: borderY - borderWidth))
                    
                    if highlightStyle == HighlightStyle.frame {
                        outerHighlightPath.addLine(to: CGPoint(x: leftOffset + Block.PADDING + lines[i].frame.size.width + Block.PADDING, y: borderY))
                        innerHighlightPath.addLine(to: CGPoint(x: leftOffset + Block.PADDING + lines[i].frame.size.width + Block.PADDING - borderWidth, y: borderY - borderWidth))
                    }
                } else if Block.blockStyle == Block.BlockStyle.trapezoid {
                    borderPath.addLine(to: CGPoint(x: leftOffset + Block.PADDING + lines[i].frame.size.width + Block.PADDING - borderRadius, y: borderY))
                    borderPath.addLine(to: CGPoint(x: leftOffset + Block.PADDING + lines[i].frame.size.width + Block.PADDING, y: borderY - borderRadius))
                    
                    let d: CGFloat = borderWidth / CGFloat(tan(67.5 * CGFloat.pi / 180))
                    
                    stylePath.addLine(to: CGPoint(x: leftOffset + Block.PADDING + lines[i].frame.size.width + Block.PADDING - borderRadius - d, y: borderY - borderWidth))
                    stylePath.addLine(to: CGPoint(x: leftOffset + Block.PADDING + lines[i].frame.size.width + Block.PADDING - borderWidth, y: borderY - borderRadius - d))
                    
                    if highlightStyle == HighlightStyle.frame {
                        outerHighlightPath.addLine(to: CGPoint(x: leftOffset + Block.PADDING + lines[i].frame.size.width + Block.PADDING - borderRadius, y: borderY))
                        outerHighlightPath.addLine(to: CGPoint(x: leftOffset + Block.PADDING + lines[i].frame.size.width + Block.PADDING, y: borderY - borderRadius))
                        
                        let hd: CGFloat = highlightWidth / CGFloat(tan(67.5 * CGFloat.pi / 180))
                        
                        innerHighlightPath.addLine(to: CGPoint(x: leftOffset + Block.PADDING + lines[i].frame.size.width + Block.PADDING - borderRadius - hd, y: borderY - highlightWidth))
                        innerHighlightPath.addLine(to: CGPoint(x: leftOffset + Block.PADDING + lines[i].frame.size.width + Block.PADDING - highlightWidth, y: borderY - borderRadius - hd))
                    }
                }
                
                borderY -= Block.PADDING
            } else {
                if lines[i - 1].frame.size.width < lines[i].frame.size.width {
                    // Any line longer than that before it
                    if Block.blockStyle == Block.BlockStyle.rounded {
                        let r: CGFloat = min(borderRadius, lines[i].frame.size.width - lines[i - 1].frame.size.width)
                        
                        let arcCenter: CGPoint = CGPoint(x: leftOffset + Block.PADDING + lines[i].frame.size.width + Block.PADDING - r, y: borderY - r)
                        
                        borderPath.addArc(center: arcCenter, radius: r, startAngle: CGFloat.pi * 0.5, endAngle: 0, clockwise: true)
                        stylePath.addArc(center: arcCenter, radius: r - borderWidth, startAngle: CGFloat.pi * 0.5, endAngle: 0, clockwise: true)
                        
                        if highlightStyle == HighlightStyle.frame {
                            outerHighlightPath.addArc(center: arcCenter, radius: r, startAngle: CGFloat.pi * 0.5, endAngle: 0, clockwise: true)
                            innerHighlightPath.addArc(center: arcCenter, radius: r - highlightWidth, startAngle: CGFloat.pi * 0.5, endAngle: 0, clockwise: true)
                        }
                    } else if Block.blockStyle == Block.BlockStyle.rectangle {
                        let point: CGPoint = CGPoint(x: leftOffset + Block.PADDING + lines[i].frame.size.width + Block.PADDING, y: borderY)
                        
                        borderPath.addLine(to: point)
                        stylePath.addLine(to: CGPoint(x: point.x - borderWidth, y: point.y - borderWidth))
                        
                        if highlightStyle == HighlightStyle.frame {
                            outerHighlightPath.addLine(to: point)
                            innerHighlightPath.addLine(to: CGPoint(x: point.x - borderWidth, y: point.y - borderWidth))
                        }
                    } else if Block.blockStyle == Block.BlockStyle.trapezoid {
                        borderPath.addLine(to: CGPoint(x: leftOffset + Block.PADDING + lines[i].frame.size.width + Block.PADDING - borderRadius, y: borderY))
                        borderPath.addLine(to: CGPoint(x: leftOffset + Block.PADDING + lines[i].frame.size.width + Block.PADDING, y: borderY - borderRadius))
                        
                        let d: CGFloat = borderWidth / CGFloat(tan(67.5 * CGFloat.pi / 180))
                        
                        stylePath.addLine(to: CGPoint(x: leftOffset + Block.PADDING + lines[i].frame.size.width + Block.PADDING - borderRadius - d, y: borderY - borderWidth))
                        stylePath.addLine(to: CGPoint(x: leftOffset + Block.PADDING + lines[i].frame.size.width + Block.PADDING - borderWidth, y: borderY - borderRadius - d))
                        
                        if highlightStyle == HighlightStyle.frame {
                            outerHighlightPath.addLine(to: CGPoint(x: leftOffset + Block.PADDING + lines[i].frame.size.width + Block.PADDING - borderRadius, y: borderY))
                            outerHighlightPath.addLine(to: CGPoint(x: leftOffset + Block.PADDING + lines[i].frame.size.width + Block.PADDING, y: borderY - borderRadius))
                            
                            let hd: CGFloat = highlightWidth / CGFloat(tan(67.5 * CGFloat.pi / 180))
                            
                            innerHighlightPath.addLine(to: CGPoint(x: leftOffset + Block.PADDING + lines[i].frame.size.width + Block.PADDING - borderRadius - hd, y: borderY - highlightWidth))
                            innerHighlightPath.addLine(to: CGPoint(x: leftOffset + Block.PADDING + lines[i].frame.size.width + Block.PADDING - highlightWidth, y: borderY - borderRadius - hd))
                        }
                    }
                    
                    borderY -= Block.PADDING
                } else {
                    // Any line shorter than that before it
                    borderPath.addLine(to: CGPoint(x: leftOffset + lines[i].frame.size.width + (2 * Block.PADDING), y: borderY))
                    stylePath.addLine(to: CGPoint(x: leftOffset + lines[i].frame.size.width + (2 * Block.PADDING) - borderWidth, y: styleY))
                    
                    if highlightStyle == HighlightStyle.frame {
                        outerHighlightPath.addLine(to: CGPoint(x: leftOffset + lines[i].frame.size.width + (2 * Block.PADDING), y: borderY))
                        innerHighlightPath.addLine(to: CGPoint(x: leftOffset + lines[i].frame.size.width + (2 * Block.PADDING) - highlightWidth, y: borderY + highlightWidth))
                    }
                    
                    borderY += Block.PADDING
                    borderY -= Block.LINE_SPACING
                }
            }
            
            // Move styleY to the bottom of the line
            borderY -= lines[i].frame.size.height
            styleY = borderY
            
            // Move styleY back up to the appropriate padding for the next line {
            if i == lines.count - 1 {
                // Last line
                borderY = 0
                
                if Block.connectionStyle == ConnectionStyle.puzzlePiece {
                    borderY += bottomOffset
                }
                
                styleY = borderY + borderWidth
                
                if Block.blockStyle == Block.BlockStyle.rounded {
                    let arcCenter: CGPoint = CGPoint(x: leftOffset + Block.PADDING + lines[i].frame.size.width + Block.PADDING - borderRadius, y: borderY + borderRadius)
                    
                    borderPath.addArc(center: arcCenter, radius: borderRadius, startAngle: 0, endAngle: CGFloat.pi * 1.5, clockwise: true)
                    stylePath.addArc(center: arcCenter, radius: borderRadius - borderWidth, startAngle: 0, endAngle: CGFloat.pi * 1.5, clockwise: true)
                    
                    if highlightStyle == HighlightStyle.frame {
                        outerHighlightPath.addArc(center: arcCenter, radius: borderRadius, startAngle: 0, endAngle: CGFloat.pi * 1.5, clockwise: true)
                        innerHighlightPath.addArc(center: arcCenter, radius: borderRadius - highlightWidth, startAngle: 0, endAngle: CGFloat.pi * 1.5, clockwise: true)
                    }
                } else if Block.blockStyle == Block.BlockStyle.rectangle {
                    let point: CGPoint = CGPoint(x: leftOffset + Block.PADDING + lines[i].frame.size.width + Block.PADDING, y: borderY)
                    
                    borderPath.addLine(to: point)
                    stylePath.addLine(to: CGPoint(x: point.x - borderWidth, y: point.y + borderWidth))
                    
                    if highlightStyle == HighlightStyle.frame {
                        outerHighlightPath.addLine(to: point)
                        innerHighlightPath.addLine(to: CGPoint(x: point.x - borderWidth, y: point.y + highlightWidth))
                    }
                } else if Block.blockStyle == Block.BlockStyle.trapezoid {
                    let point: CGPoint = CGPoint(x: leftOffset + Block.PADDING + lines[i].frame.size.width + Block.PADDING, y: borderY)
                    
                    borderPath.addLine(to: CGPoint(x: point.x, y: point.y + borderRadius))
                    borderPath.addLine(to: CGPoint(x: point.x - borderRadius, y: point.y))
                    
                    let d: CGFloat = borderWidth / CGFloat(tan(67.5 * CGFloat.pi / 180))
                    
                    stylePath.addLine(to: CGPoint(x: point.x - borderWidth, y: point.y + borderRadius + d))
                    stylePath.addLine(to: CGPoint(x: point.x - borderRadius - d, y: point.y + borderWidth))
                    
                    if highlightStyle == HighlightStyle.frame {
                        outerHighlightPath.addLine(to: CGPoint(x: point.x, y: point.y + borderRadius))
                        outerHighlightPath.addLine(to: CGPoint(x: point.x - borderRadius, y: point.y))
                        
                        let hd: CGFloat = highlightWidth / CGFloat(tan(67.5 * CGFloat.pi / 180))
                        
                        innerHighlightPath.addLine(to: CGPoint(x: point.x - highlightWidth, y: point.y + borderRadius + hd))
                        innerHighlightPath.addLine(to: CGPoint(x: point.x - borderRadius - hd, y: point.y + highlightWidth))
                    }
                }
            } else {
                if lines[i].frame.size.width < lines[i + 1].frame.size.width {
                    // Any line shorter than that after it
                    borderY -= Block.LINE_SPACING
                    borderY += Block.PADDING
                    styleY = borderY - borderWidth
                    
                    borderPath.addLine(to: CGPoint(x: leftOffset + lines[i].frame.size.width + (2 * Block.PADDING), y: borderY))
                    stylePath.addLine(to: CGPoint(x: leftOffset + lines[i].frame.size.width + (2 * Block.PADDING) - borderWidth, y: styleY))
                    
                    if highlightStyle == HighlightStyle.frame {
                        outerHighlightPath.addLine(to: CGPoint(x: leftOffset + lines[i].frame.size.width + (2 * Block.PADDING), y: borderY))
                        innerHighlightPath.addLine(to: CGPoint(x: leftOffset + lines[i].frame.size.width + (2 * Block.PADDING) - highlightWidth, y: borderY - highlightWidth))
                    }
                } else if lines[i].frame.size.width > lines[i + 1].frame.size.width {
                    // Any line longer than that after it
                    borderY -= Block.PADDING
                    styleY = borderY + borderWidth
                    
                    if Block.blockStyle == Block.BlockStyle.rounded {
                        let r: CGFloat = min(borderRadius, lines[i].frame.size.width - lines[i + 1].frame.size.width)
                        
                        let arcCenter: CGPoint = CGPoint(x: leftOffset + Block.PADDING + lines[i].frame.size.width + Block.PADDING - r, y: borderY + r)
                        
                        borderPath.addArc(center: arcCenter, radius: r, startAngle: 0, endAngle: CGFloat.pi * 1.5, clockwise: true)
                        stylePath.addArc(center: arcCenter, radius: r - borderWidth, startAngle: 0, endAngle: CGFloat.pi * 1.5, clockwise: true)
                        
                        if highlightStyle == HighlightStyle.frame {
                            outerHighlightPath.addArc(center: arcCenter, radius: r, startAngle: 0, endAngle: CGFloat.pi * 1.5, clockwise: true)
                            innerHighlightPath.addArc(center: arcCenter, radius: r - highlightWidth, startAngle: 0, endAngle: CGFloat.pi * 1.5, clockwise: true)
                        }
                    } else if Block.blockStyle == Block.BlockStyle.rectangle {
                        let point: CGPoint = CGPoint(x: leftOffset + Block.PADDING + lines[i].frame.size.width + Block.PADDING, y: borderY)
                        
                        borderPath.addLine(to: point)
                        stylePath.addLine(to: CGPoint(x: point.x - borderWidth, y: point.y + borderWidth))
                        
                        if highlightStyle == HighlightStyle.frame {
                            outerHighlightPath.addLine(to: point)
                            innerHighlightPath.addLine(to: CGPoint(x: point.x - borderWidth, y: point.y + highlightWidth))
                        }
                    } else if Block.blockStyle == Block.BlockStyle.trapezoid {
                        let point: CGPoint = CGPoint(x: leftOffset + Block.PADDING + lines[i].frame.size.width + Block.PADDING, y: borderY)
                        
                        borderPath.addLine(to: CGPoint(x: point.x, y: point.y + borderRadius))
                        borderPath.addLine(to: CGPoint(x: point.x - borderRadius, y: point.y))
                        
                        let d: CGFloat = borderWidth / CGFloat(tan(67.5 * CGFloat.pi / 180))
                        
                        stylePath.addLine(to: CGPoint(x: point.x - borderWidth, y: point.y + borderRadius + d))
                        stylePath.addLine(to: CGPoint(x: point.x - borderRadius - d, y: point.y + borderWidth))
                        
                        if highlightStyle == HighlightStyle.frame {
                            outerHighlightPath.addLine(to: CGPoint(x: point.x, y: point.y + borderRadius))
                            outerHighlightPath.addLine(to: CGPoint(x: point.x - borderRadius, y: point.y))
                            
                            let hd: CGFloat = highlightWidth / CGFloat(tan(67.5 * CGFloat.pi / 180))
                            
                            innerHighlightPath.addLine(to: CGPoint(x: point.x - highlightWidth, y: point.y + borderRadius + hd))
                            innerHighlightPath.addLine(to: CGPoint(x: point.x - borderRadius - hd, y: point.y + highlightWidth))
                        }
                    }
                } else {
                    // Any line equal in length to than that after it
                    borderY -= Block.PADDING
                    styleY = borderY + borderWidth
                    
                    borderPath.addLine(to: CGPoint(x: leftOffset + lines[i].frame.size.width + (2 * Block.PADDING), y: borderY))
                    stylePath.addLine(to: CGPoint(x: leftOffset + lines[i].frame.size.width + (2 * Block.PADDING) - borderWidth, y: styleY))
                    
                    if highlightStyle == HighlightStyle.frame {
                        outerHighlightPath.addLine(to: CGPoint(x: leftOffset + lines[i].frame.size.width + (2 * Block.PADDING), y: borderY))
                        innerHighlightPath.addLine(to: CGPoint(x: leftOffset + lines[i].frame.size.width + (2 * Block.PADDING) - highlightWidth, y: borderY + highlightWidth))
                    }
                }
            }
        }
        
        // Draws the lower connection (if there is one)
        if lowerConnection.enabled {
            if Block.connectionStyle == ConnectionStyle.trapezoid {
                stylePath.addLine(to: CGPoint(x: leftOffset + (2 * Block.PADDING) + Block.STUB_WIDTH, y: styleY))
                stylePath.addLine(to: CGPoint(x: leftOffset + (2 * Block.PADDING) + Block.STUB_WIDTH - Block.STUB_HEIGHT, y: styleY + Block.STUB_HEIGHT))
                stylePath.addLine(to: CGPoint(x: leftOffset + (2 * Block.PADDING) + Block.STUB_HEIGHT, y: styleY + Block.STUB_HEIGHT))
                stylePath.addLine(to: CGPoint(x: leftOffset + (2 * Block.PADDING), y: styleY))
            } else if Block.connectionStyle == ConnectionStyle.puzzlePiece {
                let d: CGFloat = Block.STUB_HEIGHT
                let r: CGFloat = ((4 * d) + (d * sqrt(8))) / 4
                let w = (4 * r) / sqrt(2)
                
                let A: CGPoint = CGPoint(x: leftOffset + (2 * Block.PADDING) + w, y: borderY - r)
                let B: CGPoint = CGPoint(x: leftOffset + (2 * Block.PADDING) + (w / 2), y: A.y + (2 * r / sqrt(2)))
                let C: CGPoint = CGPoint(x: leftOffset + (2 * Block.PADDING), y: borderY - r)
                
                borderPath.addArc(center: A, radius: r, startAngle: CGFloat.pi * 0.5, endAngle: CGFloat.pi * 0.75, clockwise: false)
                borderPath.addArc(center: B, radius: r, startAngle: CGFloat.pi * 1.75, endAngle: CGFloat.pi * 1.25, clockwise: true)
                borderPath.addArc(center: C, radius: r, startAngle: CGFloat.pi * 0.25, endAngle: CGFloat.pi * 0.5, clockwise: false)
                
                stylePath.addArc(center: A, radius: r + borderWidth, startAngle: CGFloat.pi * 0.5, endAngle: CGFloat.pi * 0.75, clockwise: false)
                stylePath.addArc(center: B, radius: r - borderWidth, startAngle: CGFloat.pi * 1.75, endAngle: CGFloat.pi * 1.25, clockwise: true)
                stylePath.addArc(center: C, radius: r + borderWidth, startAngle: CGFloat.pi * 0.25, endAngle: CGFloat.pi * 0.5, clockwise: false)
                
                if highlightStyle == HighlightStyle.frame {
                    outerHighlightPath.addArc(center: A, radius: r, startAngle: CGFloat.pi * 0.5, endAngle: CGFloat.pi * 0.75, clockwise: false)
                    outerHighlightPath.addArc(center: B, radius: r, startAngle: CGFloat.pi * 1.75, endAngle: CGFloat.pi * 1.25, clockwise: true)
                    outerHighlightPath.addArc(center: C, radius: r, startAngle: CGFloat.pi * 0.25, endAngle: CGFloat.pi * 0.5, clockwise: false)
                    
                    innerHighlightPath.addArc(center: A, radius: r + highlightWidth, startAngle: CGFloat.pi * 0.5, endAngle: CGFloat.pi * 0.75, clockwise: false)
                    innerHighlightPath.addArc(center: B, radius: r - highlightWidth, startAngle: CGFloat.pi * 1.75, endAngle: CGFloat.pi * 1.25, clockwise: true)
                    innerHighlightPath.addArc(center: C, radius: r + highlightWidth, startAngle: CGFloat.pi * 0.25, endAngle: CGFloat.pi * 0.5, clockwise: false)
                }
            }
        }
        
        if lowerConnection.connectedTo == nil {
            // If the block does not have something connected below it, draw a corner in the bottom left corner
            if Block.blockStyle == Block.BlockStyle.rounded {
                borderPath.addArc(center: CGPoint(x: leftOffset + borderRadius, y: borderY + borderRadius), radius: borderRadius, startAngle: CGFloat.pi * 1.5, endAngle: CGFloat.pi, clockwise: true)
                stylePath.addArc(center: CGPoint(x: leftOffset + borderRadius, y: borderY + borderRadius), radius: styleRadius, startAngle: CGFloat.pi * 1.5, endAngle: CGFloat.pi, clockwise: true)
                
                if highlightStyle == HighlightStyle.frame {
                    outerHighlightPath.addArc(center: CGPoint(x: leftOffset + borderRadius, y: borderY + borderRadius), radius: borderRadius, startAngle: CGFloat.pi * 1.5, endAngle: CGFloat.pi, clockwise: true)
                    innerHighlightPath.addArc(center: CGPoint(x: leftOffset + borderRadius, y: borderY + borderRadius), radius: borderRadius - highlightWidth, startAngle: CGFloat.pi * 1.5, endAngle: CGFloat.pi, clockwise: true)
                }
            } else if Block.blockStyle == Block.BlockStyle.rectangle {
                borderPath.addLine(to: CGPoint(x: leftOffset, y: borderY))
                stylePath.addLine(to: CGPoint(x: leftOffset + borderWidth, y: borderY + borderWidth))
                
                if highlightStyle == HighlightStyle.frame {
                    outerHighlightPath.addLine(to: CGPoint(x: leftOffset, y: borderY))
                    innerHighlightPath.addLine(to: CGPoint(x: leftOffset + highlightWidth, y: borderY + highlightWidth))
                }
            } else if Block.blockStyle == Block.BlockStyle.trapezoid {
                borderPath.addLine(to: CGPoint(x: leftOffset + borderRadius, y: borderY))
                borderPath.addLine(to: CGPoint(x: leftOffset, y: borderY + borderRadius))
                
                let d: CGFloat = borderWidth / CGFloat(tan(67.5 * CGFloat.pi / 180))
                
                stylePath.addLine(to: CGPoint(x: leftOffset + borderRadius + d, y: borderY + borderWidth))
                stylePath.addLine(to: CGPoint(x: leftOffset + borderWidth, y: borderY + borderRadius + d))
                
                if highlightStyle == HighlightStyle.frame {
                    outerHighlightPath.addLine(to: CGPoint(x: leftOffset + borderRadius, y: borderY))
                    outerHighlightPath.addLine(to: CGPoint(x: leftOffset, y: borderY + borderRadius))
                
                    let hd: CGFloat = highlightWidth / CGFloat(tan(67.5 * CGFloat.pi / 180))
                    
                    innerHighlightPath.addLine(to: CGPoint(x: leftOffset + borderRadius + hd, y: borderY + highlightWidth))
                    innerHighlightPath.addLine(to: CGPoint(x: leftOffset + highlightWidth, y: borderY + borderRadius + hd))
                }
            }
        } else {
            // Otherwise, leave a rectangular corner on the bottom left edge
            borderPath.addLine(to: CGPoint(x: leftOffset, y: borderY))
            stylePath.addLine(to: CGPoint(x: leftOffset + borderWidth, y: styleY))
            
            if highlightStyle == HighlightStyle.frame {
                outerHighlightPath.addLine(to: CGPoint(x: leftOffset, y: borderY))
                innerHighlightPath.addLine(to: CGPoint(x: leftOffset + highlightWidth, y: borderY + highlightWidth))
            }
        }
        
        if lowerConnection.enabled && highlightStyle == HighlightStyle.lower {
            if lowerConnection.connectedTo == nil {
                let dx: CGFloat = borderWidth / CGFloat(tan(3 * Double.pi / 8))
                
                highlightPath.move(to: CGPoint(x: leftOffset + (2 * Block.PADDING) + Block.STUB_WIDTH - dx, y: borderY))
                highlightPath.addLine(to: CGPoint(x: leftOffset + (2 * Block.PADDING) + Block.STUB_WIDTH - Block.STUB_HEIGHT - dx, y: borderY + Block.STUB_HEIGHT))
                highlightPath.addLine(to: CGPoint(x: leftOffset + (2 * Block.PADDING) + Block.STUB_HEIGHT + dx, y: borderY + Block.STUB_HEIGHT))
                highlightPath.addLine(to: CGPoint(x: leftOffset + (2 * Block.PADDING) + dx, y: borderY))
            } else {
                let dx: CGFloat = highlightWidth * CGFloat(tan(Double.pi / 8))
                
                highlightPath.move(to: CGPoint(x: 0, y: borderWidth))
                highlightPath.addLine(to: CGPoint(x: leftOffset + (2 * Block.PADDING), y: borderWidth))
                highlightPath.addLine(to: CGPoint(x: leftOffset + (2 * Block.PADDING) + Block.STUB_HEIGHT, y: borderWidth + Block.STUB_HEIGHT))
                highlightPath.addLine(to: CGPoint(x: leftOffset + (2 * Block.PADDING) + Block.STUB_WIDTH - Block.STUB_HEIGHT, y: borderWidth + Block.STUB_HEIGHT))
                highlightPath.addLine(to: CGPoint(x: leftOffset + (2 * Block.PADDING) + Block.STUB_WIDTH, y: borderWidth))
                highlightPath.addLine(to: CGPoint(x: leftOffset + (2 * Block.PADDING) - (Block.CORNER_RADIUS / 2) + (lines.last?.frame.size.width ?? 0), y: borderWidth))
                
                // Double back around
                highlightPath.addLine(to: CGPoint(x: leftOffset + (2 * Block.PADDING) - (Block.CORNER_RADIUS / 2) + (lines.last?.frame.size.width ?? 0), y: borderWidth + highlightWidth))
                highlightPath.addLine(to: CGPoint(x: leftOffset + (2 * Block.PADDING) + Block.STUB_WIDTH + dx, y: borderWidth + highlightWidth))
                highlightPath.addLine(to: CGPoint(x: leftOffset + (2 * Block.PADDING) + Block.STUB_WIDTH - Block.STUB_HEIGHT + dx, y: (borderWidth + highlightWidth) + Block.STUB_HEIGHT))
                highlightPath.addLine(to: CGPoint(x: leftOffset + (2 * Block.PADDING) + Block.STUB_HEIGHT - dx, y: (borderWidth + highlightWidth) + Block.STUB_HEIGHT))
                highlightPath.addLine(to: CGPoint(x: leftOffset + (2 * Block.PADDING) - dx, y: borderWidth + highlightWidth))
                highlightPath.addLine(to: CGPoint(x: 0, y: borderWidth + highlightWidth))
            }
        }
        
        // Draws the output connection, if applicable
        if outputType != DataType.none {
            if Block.connectionStyle == ConnectionStyle.trapezoid {
                borderPath.addLine(to: CGPoint(x: leftOffset, y: bottomOffset + (frame.size.height - topOffset - bottomOffset - Block.STUB_WIDTH) / 2))
                borderPath.addLine(to: CGPoint(x: 0, y: bottomOffset + (frame.size.height - topOffset - bottomOffset - Block.STUB_WIDTH) / 2 + Block.STUB_HEIGHT))
                borderPath.addLine(to: CGPoint(x: 0, y: bottomOffset + (frame.size.height - topOffset - bottomOffset + Block.STUB_WIDTH) / 2 - Block.STUB_HEIGHT))
                borderPath.addLine(to: CGPoint(x: leftOffset, y: bottomOffset + (frame.size.height - topOffset - bottomOffset + Block.STUB_WIDTH) / 2))
                
                let dy: CGFloat = borderWidth / CGFloat(tan(3 * Double.pi / 8))
                
                stylePath.addLine(to: CGPoint(x: leftOffset + borderWidth, y: bottomOffset + (frame.size.height - topOffset - bottomOffset - Block.STUB_WIDTH) / 2 + dy))
                stylePath.addLine(to: CGPoint(x: borderWidth, y: bottomOffset + (frame.size.height - topOffset - bottomOffset - Block.STUB_WIDTH) / 2 + Block.STUB_HEIGHT + dy))
                stylePath.addLine(to: CGPoint(x: borderWidth, y: bottomOffset + (frame.size.height - topOffset - bottomOffset + Block.STUB_WIDTH) / 2 - Block.STUB_HEIGHT - dy))
                stylePath.addLine(to: CGPoint(x: leftOffset + borderWidth, y: bottomOffset + (frame.size.height - topOffset - bottomOffset + Block.STUB_WIDTH) / 2 - dy))
                
                if highlightStyle == HighlightStyle.frame {
                    let dh: CGFloat = highlightWidth / CGFloat(tan(3 * Double.pi / 8))
                    
                    outerHighlightPath.addLine(to: CGPoint(x: leftOffset, y: bottomOffset + (frame.size.height - topOffset - bottomOffset - Block.STUB_WIDTH) / 2))
                    outerHighlightPath.addLine(to: CGPoint(x: 0, y: bottomOffset + (frame.size.height - topOffset - bottomOffset - Block.STUB_WIDTH) / 2 + Block.STUB_HEIGHT))
                    outerHighlightPath.addLine(to: CGPoint(x: 0, y: bottomOffset + (frame.size.height - topOffset - bottomOffset + Block.STUB_WIDTH) / 2 - Block.STUB_HEIGHT))
                    outerHighlightPath.addLine(to: CGPoint(x: leftOffset, y: bottomOffset + (frame.size.height - topOffset - bottomOffset + Block.STUB_WIDTH) / 2))
                    
                    innerHighlightPath.addLine(to: CGPoint(x: leftOffset + highlightWidth, y: bottomOffset + (frame.size.height - topOffset - bottomOffset - Block.STUB_WIDTH) / 2 + dh))
                    innerHighlightPath.addLine(to: CGPoint(x: highlightWidth, y: bottomOffset + (frame.size.height - topOffset - bottomOffset - Block.STUB_WIDTH) / 2 + Block.STUB_HEIGHT + dh))
                    innerHighlightPath.addLine(to: CGPoint(x: highlightWidth, y: bottomOffset + (frame.size.height - topOffset - bottomOffset + Block.STUB_WIDTH) / 2 - Block.STUB_HEIGHT - dh))
                    innerHighlightPath.addLine(to: CGPoint(x: leftOffset + highlightWidth, y: bottomOffset + (frame.size.height - topOffset - bottomOffset + Block.STUB_WIDTH) / 2 - dh))
                }
            } else if Block.connectionStyle == ConnectionStyle.puzzlePiece {
                var pieceCenter: CGPoint = CGPoint(x: leftOffset, y: bottomOffset + (frame.size.height - topOffset - bottomOffset) / 2)
                
                borderPath.addLine(to: CGPoint(x: pieceCenter.x, y: pieceCenter.y - Block.PIECE_WIDTH / 2))
                
                borderPath.addCurve(to: CGPoint(x: pieceCenter.x - Block.PIECE_HEIGHT, y: pieceCenter.y), control1: CGPoint(x: pieceCenter.x - Block.PIECE_HEIGHT / 3, y: pieceCenter.y - Block.PIECE_WIDTH / 5), control2: CGPoint(x: pieceCenter.x - Block.PIECE_HEIGHT, y: pieceCenter.y - (Block.PIECE_WIDTH * 1.25)))
                borderPath.addCurve(to: CGPoint(x: pieceCenter.x, y: pieceCenter.y + Block.PIECE_WIDTH / 2), control1: CGPoint(x: pieceCenter.x - Block.PIECE_HEIGHT, y: pieceCenter.y + (Block.PIECE_WIDTH * 1.25)), control2: CGPoint(x: pieceCenter.x - Block.PIECE_HEIGHT / 3, y: pieceCenter.y + Block.PIECE_WIDTH / 5))
                
                pieceCenter.x += borderWidth
                
                stylePath.addLine(to: CGPoint(x: pieceCenter.x, y: pieceCenter.y - (Block.PIECE_WIDTH - (2 * borderWidth)) / 2))
                
                stylePath.addCurve(to: CGPoint(x: pieceCenter.x - Block.PIECE_HEIGHT, y: pieceCenter.y), control1: CGPoint(x: pieceCenter.x - borderWidth - Block.PIECE_HEIGHT / 3, y: pieceCenter.y + borderWidth - (Block.PIECE_WIDTH - (2 * borderWidth)) / 5), control2: CGPoint(x: pieceCenter.x - borderWidth - Block.PIECE_HEIGHT, y: pieceCenter.y - borderWidth - ((Block.PIECE_WIDTH - (2 * borderWidth)) * 1.25)))
                stylePath.addCurve(to: CGPoint(x: pieceCenter.x, y: pieceCenter.y + (Block.PIECE_WIDTH - (2 * borderWidth)) / 2), control1: CGPoint(x: pieceCenter.x - borderWidth - Block.PIECE_HEIGHT, y: pieceCenter.y + borderWidth + ((Block.PIECE_WIDTH - (2 * borderWidth)) * 1.25)), control2: CGPoint(x: pieceCenter.x - borderWidth - Block.PIECE_HEIGHT / 3, y: pieceCenter.y - borderWidth + (Block.PIECE_WIDTH - (2 * borderWidth)) / 5))
                
                if highlightStyle == HighlightStyle.frame {
                    pieceCenter.x -= borderWidth
                    
                    outerHighlightPath.addLine(to: CGPoint(x: pieceCenter.x, y: pieceCenter.y - Block.PIECE_WIDTH / 2))
                    
                    outerHighlightPath.addCurve(to: CGPoint(x: pieceCenter.x - Block.PIECE_HEIGHT, y: pieceCenter.y), control1: CGPoint(x: pieceCenter.x - Block.PIECE_HEIGHT / 3, y: pieceCenter.y - Block.PIECE_WIDTH / 5), control2: CGPoint(x: pieceCenter.x - Block.PIECE_HEIGHT, y: pieceCenter.y - (Block.PIECE_WIDTH * 1.25)))
                    outerHighlightPath.addCurve(to: CGPoint(x: pieceCenter.x, y: pieceCenter.y + Block.PIECE_WIDTH / 2), control1: CGPoint(x: pieceCenter.x - Block.PIECE_HEIGHT, y: pieceCenter.y + (Block.PIECE_WIDTH * 1.25)), control2: CGPoint(x: pieceCenter.x - Block.PIECE_HEIGHT / 3, y: pieceCenter.y + Block.PIECE_WIDTH / 5))
                    
                    pieceCenter.x += highlightWidth
                    
                    innerHighlightPath.addLine(to: CGPoint(x: pieceCenter.x, y: pieceCenter.y - (Block.PIECE_WIDTH - (2 * highlightWidth)) / 2))
                    
                    innerHighlightPath.addCurve(to: CGPoint(x: pieceCenter.x - Block.PIECE_HEIGHT, y: pieceCenter.y), control1: CGPoint(x: pieceCenter.x - highlightWidth - Block.PIECE_HEIGHT / 3, y: pieceCenter.y + highlightWidth - (Block.PIECE_WIDTH - (2 * highlightWidth)) / 5), control2: CGPoint(x: pieceCenter.x - highlightWidth - Block.PIECE_HEIGHT, y: pieceCenter.y - highlightWidth - ((Block.PIECE_WIDTH - (2 * highlightWidth)) * 1.25)))
                    innerHighlightPath.addCurve(to: CGPoint(x: pieceCenter.x, y: pieceCenter.y + (Block.PIECE_WIDTH - (2 * highlightWidth)) / 2), control1: CGPoint(x: pieceCenter.x - highlightWidth - Block.PIECE_HEIGHT, y: pieceCenter.y + highlightWidth + ((Block.PIECE_WIDTH - (2 * highlightWidth)) * 1.25)), control2: CGPoint(x: pieceCenter.x - highlightWidth - Block.PIECE_HEIGHT / 3, y: pieceCenter.y - highlightWidth + (Block.PIECE_WIDTH - (2 * highlightWidth)) / 5))
                }
            }
        }
        
        // Draw a border path for the transparent parts of the block, when highlighted
        if highlightStyle == HighlightStyle.frame {
            highlightPath.addPath(outerHighlightPath)
            highlightPath.addPath(innerHighlightPath)
            
            borderPath = CGMutablePath()
            
            if Block.connectionStyle == ConnectionStyle.trapezoid {
                borderPath.move(to: CGPoint(x: leftOffset + (2 * Block.PADDING) + Block.STUB_WIDTH + borderWidth, y: styleY))
                borderPath.addLine(to: CGPoint(x: leftOffset + (2 * Block.PADDING) + Block.STUB_WIDTH + borderWidth, y: styleY + Block.STUB_HEIGHT + borderWidth))
                borderPath.addLine(to: CGPoint(x: leftOffset + (2 * Block.PADDING) - borderWidth, y: styleY + Block.STUB_HEIGHT + borderWidth))
                borderPath.addLine(to: CGPoint(x: leftOffset + (2 * Block.PADDING) - borderWidth, y: styleY))
            } else if Block.connectionStyle == ConnectionStyle.puzzlePiece {
                let width: CGFloat = ((4 + sqrt(8)) * Block.STUB_HEIGHT)
                
                borderPath.move(to: CGPoint(x: leftOffset + (2 * Block.PADDING) + width + borderWidth, y: frame.size.height))
                borderPath.addLine(to: CGPoint(x: leftOffset + (2 * Block.PADDING) + width + borderWidth, y: frame.size.height - Block.STUB_HEIGHT - 2 * borderWidth))
                borderPath.addLine(to: CGPoint(x: leftOffset + (2 * Block.PADDING) - borderWidth, y: frame.size.height - Block.STUB_HEIGHT - 2 * borderWidth))
                borderPath.addLine(to: CGPoint(x: leftOffset + (2 * Block.PADDING) - borderWidth, y: frame.size.height))
            }
        } else {
            borderLayer.isHidden = false
        }
        
        styleLayer.path = stylePath
        borderLayer.path = borderPath
        
        highlightLayer.path = highlightPath
        highlightLayer.fillRule = kCAFillRuleEvenOdd
    }
    
    // MARK: Evaluate
    
    @discardableResult func evaluate() -> Any? {
        if lowerConnection.connectedTo != nil {
            (lowerConnection.connectedTo as! Block).evaluate()
        }
        
        return nil
    }
    
    // MARK: RowViewDelegate
    
    func updateBlock() {}
    
    func numberOfRows(inRowView rowView: RowView) -> Int {
        return 0
    }
    
    func heightOf(row: Int, inRowView rowView: RowView) -> CGFloat {
        return 30
    }
    
    func viewFor(row: Int, inRowView rowView: RowView) -> NSView? {
        return nil
    }
    
}
