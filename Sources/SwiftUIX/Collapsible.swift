//https://gist.github.com/sanzaru/83a6dc8d8c93f267d4a1a258a7a92329#file-collapsible-swift

import SwiftUI

public struct Collapsible<Content: View>: View {
    @State public var label: () -> Text
    @State public var content: () -> Content
    
    public init(label: @autoclosure @escaping () -> Text, @ViewBuilder content: @escaping () -> Content){
        self.label = label
        self.content = content
    }
    
    @State private var collapsed: Bool = true
    
    public var body: some View {
        VStack {
            Button {
                self.collapsed.toggle()
            } label: {
                HStack {
                    self.label()
                    #if os(iOS)
                    Spacer()
                    #endif
                    Image(systemName: self.collapsed ? "chevron.down" : "chevron.up")
                }
                .padding(.bottom, 1)
                //.background(Color.white.opacity(0.01))
            }.buttonStyle(PlainButtonStyle())
            
            VStack { self.content() }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: collapsed ? 0 : .none)
            .clipped()
            .animation(.easeOut)
            .transition(.slide)
        }
    }
}
