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
    func body(content: Content) -> some View { HStack{ content; MakerRep(isPresented: $isPresented, content: self.content) } }
}

struct MakerRep<Root:View>:NSViewControllerRepresentable {
    @Binding var isPresented:Bool
    var content: ()->Root
    @State var window:NSWindow?
    
    func showWindow(){
        guard window == nil else { return }
        window = NSWindow(contentViewController: NSHostingController(rootView: content()))
        window!.center()
        window!.isReleasedWhenClosed = false
        window!.makeKeyAndOrderFront(nil)
    }
    func makeNSViewController(context: Context) -> NSViewController {
        if isPresented { showWindow() }
        else { window?.close(); window = nil }
        return NSViewController()
    }
    func updateNSViewController(_ nsViewController: NSViewController, context: Context) {
        nsViewController.view.frame.size = CGSize.zero
        if isPresented { showWindow() }
        else { window?.close(); window = nil }
    }
}

#else
//Default to a full screen cover on other platforms
struct Window<Root:View>:ViewModifier{
    var isPresented:Binding<Bool>, content:()->Root
    func body(content: Content) -> some View { content.fullScreenCover(isPresented: isPresented, onDismiss: nil, content: self.content) }
}
#endif



