//
//  BlockLine.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/5/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

// A line containing several block components
class BlockLine: InterfaceObject {
    
    static let COMPONENT_SPACING: CGFloat = 6
    
    private(set) var components: [BlockComponent] = []
    var fullWidth: Bool = false
    
    init() {
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addComponent(_ newComponent: BlockComponent, at index: Int? = nil) {
        for component: BlockComponent in components {
            if component.isEqual(newComponent) {
                Swift.print("Attempted to add duplicate BlockComponent.")
            }
        }
        
        if index != nil && index! >= 0 && index! < components.count {
            components.insert(newComponent, at: index!)
        } else {
            components.append(newComponent)
        }
        
        newComponent.container = self
        newComponent.updateStyle()
        addSubview(newComponent)
        
        if container is Block {
            (container as! Block).added(component: newComponent, to: self)
        }
        
        layoutObject()
    }
    
    func addComponents(_ newComponents: BlockComponent...) {
        for newComponent: BlockComponent in newComponents {
            addComponent(newComponent)
        }
    }
    
    @discardableResult func removeComponent(_ component: BlockComponent) -> BlockComponent? {
        for i in 0 ..< components.count {
            if components[i].isEqual(component) {
                component.removeFromSuperview()
                
                let out = components.remove(at: i)
                
                if container is Block {
                    (container as! Block).removed(component: out, from: self)
                }
                
                return out
            }
        }
        
        return nil
    }
    
    @discardableResult func removeComponent(at index: Int) -> BlockComponent? {
        if index < components.count {
            return removeComponent(components[index])
        } else {
            return nil
        }
    }
    
    override func updateStyle() {
        super.updateStyle()
        
        for component: BlockComponent in components {
            component.updateStyle()
        }
    }
    
    override func layoutObject() {
        var totalWidth: CGFloat = 0
        var maxHeight: CGFloat = 0
        
        for component: BlockComponent in components {
            component.layoutObject()
            
            maxHeight = max(maxHeight, component.frame.size.height)
            totalWidth += component.frame.size.width + BlockLine.COMPONENT_SPACING
        }
        
        totalWidth -= BlockLine.COMPONENT_SPACING
        
        var currentLeft: CGFloat = 0
        var currentRight: CGFloat = totalWidth
        
        for component: BlockComponent in components {
            component.frame.origin.y = (maxHeight - component.frame.size.height) / 2
            
            if component.alignment == BlockComponent.Alignment.left {
                component.frame.origin.x = currentLeft
                currentLeft += component.frame.size.width + BlockLine.COMPONENT_SPACING
            } else if component.alignment == BlockComponent.Alignment.right {
                currentRight -= component.frame.size.width
                component.frame.origin.x = currentRight
                currentRight -= BlockLine.COMPONENT_SPACING
            }
        }
        
        frame = CGRect(x: 0, y: 0, width: totalWidth, height: maxHeight)
        
        super.layoutObject()
    }
    
    func extendFully(lineWidth: CGFloat) {
        frame.size.width = lineWidth
        
        var currentLeft: CGFloat = 0
        var currentRight: CGFloat = lineWidth
        
        for component: BlockComponent in components {
            if component.alignment == BlockComponent.Alignment.left {
                component.frame.origin.x = currentLeft
                currentLeft += component.frame.size.width + BlockLine.COMPONENT_SPACING
            } else if component.alignment == BlockComponent.Alignment.right {
                currentRight -= component.frame.size.width
                component.frame.origin.x = currentRight
                currentRight -= BlockLine.COMPONENT_SPACING
            }
        }
    }
    
}
