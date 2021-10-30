
#if os(macOS)
import SwiftUI
import AppKit


public extension NSViewController {
    func addSwiftUI<Content:View>(view:Content){
        let childView = NSHostingController(rootView:  view)
        addChild(childView)
        childView.view.frame = self.view.bounds
        self.view.addConstrained(subview: childView.view)
       // childView.didMove(toParent: self)
    }
}

public extension NSView {
    func addConstrained(subview: NSView) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.topAnchor.constraint(equalTo: topAnchor).isActive = true
        subview.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        subview.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        subview.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}

#endif
