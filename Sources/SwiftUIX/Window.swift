//
//  File.swift
//  
//
//  Created by Bobbie Markwick on 31/10/21.
//

import SwiftUI

extension View {
    func window<Root:View>(isPresented:Binding<Bool>, @ViewBuilder content:@escaping ()->Root) -> some View {
        modifier(Window(isPresented: isPresented, identifier:"Test", content: content))
    }
}
#if os (macOS)
struct Window<Root:View>:ViewModifier{
    var maker:WindowWrapper
    init(isPresented:Binding<Bool>, identifier:String, @ViewBuilder content:@escaping ()->Root){
        if let m = windowWrappers.first(where: {$0.id == identifier}) {
            maker = m
            if maker.state != .presented { maker.content = { AnyView(content())  } }
            maker.shouldPresent = isPresented
        }
        else {
            maker = WindowWrapper(isPresented: isPresented, identifier: identifier){ AnyView(content())  }
            windowWrappers += [maker]
        }
    }
    func body(content: Content) -> some View { content  }
}

class WindowWrapper:ObservableObject{
    var id:String
    var shouldPresent:Binding<Bool> {
        didSet{
            if shouldPresent.wrappedValue && state == .inactive {
                state = .pending
                if let url = URL(string: "stdcrd://ShowWindow") {
                    NSWorkspace.shared.open(url)
                }
            } else if shouldPresent.wrappedValue{
                if state == .presented || state == .pending { dismissFunction() }
            }
        }
    }
    
    enum WindowState { case pending, presented, dismissing, inactive }
    var state:WindowState
    var content:()->AnyView
    
    var dismissFunction:()->() = {}
    func dismiss(){
        state = .pending
        shouldPresent.wrappedValue = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1){ self.state = .inactive }
    }
    
    init(isPresented:Binding<Bool>, identifier:String, @ViewBuilder content:@escaping ()->AnyView){
        self.id = identifier
        self.content = content
        self.state = .inactive
        self.shouldPresent = isPresented
    }
    
    func load()->some View {
        if self.id == "PLACEHOLDER",  let wrapper = windowWrappers.first(where: {$0.state == .pending}) {
            if let idx = windowWrappers.firstIndex(where:  {$0.state == .pending}) {
                windowWrappers[idx] = self
            }
            self.id = wrapper.id
            self.state = wrapper.state
            self.shouldPresent = wrapper.shouldPresent
            self.content = wrapper.content
        }
        return content()
    }
}

@available (macOS 12, *)
func wrappedWindows()->some Scene {
    return WindowGroup{
        ContainerView()
    }.handlesExternalEvents(matching: Set(arrayLiteral: "ShowWindow"))
}
var windowWrappers:[WindowWrapper] = []


@available (macOS 12, *)
struct ContainerView:View{
    var maker:WindowWrapper
    
    @Environment(\.dismiss) var dismiss

    init(){
        if let wrapper = windowWrappers.first(where: {$0.state == .pending}) {
            maker = wrapper
        } else {
            self.maker = WindowWrapper(isPresented:  Binding<Bool>.init(get: {false}, set: {_ in }), identifier: "PLACEHOLDER"){  AnyView(EmptyView())  }
        }
        maker.dismissFunction = dismiss.callAsFunction
    }
    
    var body: some View{
        maker.load().onAppear{  maker.state = .presented  }.onDisappear{ maker.dismiss()  }
    }
}



#else
//Default to a full screen cover on other platforms
struct Window<Root:View>:ViewModifier{
    var isPresented:Binding<Bool>, identifier:String, content:()->Root
    func body(content: Content) -> some View { content.fullScreenCover(isPresented: isPresented, onDismiss: nil, content: self.content) }
}
#endif



