//
//  File.swift
//  
//
//  Created by Bobbie Markwick on 31/10/21.
//

import SwiftUI

@available (iOS 14, macOS 12, *)
public extension View {
    func window<Root:View>(isPresented:Binding<Bool>, @ViewBuilder content:@escaping ()->Root) -> some View {
        modifier(Window(isPresented: isPresented, content: content))
    }
}
#if os (macOS)
struct Window<Root:View>:ViewModifier{
    @Binding var isPresented:Bool
    var content: ()->Root
    func body(content: Content) -> some View {
        ZStack{
            MakerRep(isPresented: $isPresented, content: self.content)
            content
        }
    }
}

struct MakerRep<Root:View>:NSViewRepresentable {
    
    typealias NSViewType = NSView
    
    var isPresented:Binding<Bool>
    @State var manager : WindowManager<Root>
    
    init(isPresented:Binding<Bool>, content:@escaping ()->Root){
        self.manager = WindowManager(isPresented: isPresented, content: content)
        self.isPresented = isPresented
    }
    func makeNSView(context: Context) -> NSView {
        manager.isPresented = isPresented
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: manager.showWindow)
        return NSView(frame: .zero)//NSViewController()
    }
    func updateNSView(_ nsView: NSView, context: Context) {
        nsView.frame.size = CGSize.zero
        manager.isPresented = isPresented
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: manager.showWindow)
    }
}

class WindowManager<Root:View>: NSObject, NSWindowDelegate {
    var isPresented:Binding<Bool> = Binding<Bool>(get: {false}, set: {_ in})
    var window:NSWindow?
    var content: ()->Root
    
    init(isPresented:Binding<Bool>, content:@escaping ()->Root){
        self.isPresented = isPresented; self.content = content
    }
    
    func showWindow(){
        guard isPresented.wrappedValue else { window?.close(); window = nil; return }
        guard window == nil else { return }
        let view = content()
        let vc = NSHostingController(rootView: view)
        window = NSWindow(contentViewController: vc)
        window!.center()
        window!.contentMinSize = vc.view.intrinsicContentSize
        window!.isReleasedWhenClosed = false
        window!.makeKeyAndOrderFront(nil)
        window!.delegate = self
    }
    func windowWillClose(_ notification: Notification) {
        isPresented.wrappedValue = false
    }
}

#else
//Default to a full screen cover on other platforms
struct Window<Root:View>:ViewModifier{
    var isPresented:Binding<Bool>, content:()->Root
    func body(content: Content) -> some View { content.fullScreenCover(isPresented: isPresented, onDismiss: nil, content: self.content) }
}
#endif



