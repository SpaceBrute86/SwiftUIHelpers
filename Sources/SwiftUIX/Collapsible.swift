//https://gist.github.com/sanzaru/83a6dc8d8c93f267d4a1a258a7a92329#file-collapsible-swift

import SwiftUI

struct Collapsible<Content: View>: View {
    @State var label: () -> Text
    @State var content: () -> Content
    
    @State private var collapsed: Bool = true
    
    var body: some View {
        VStack {
            Button {
                self.collapsed.toggle()
            } label: {
                HStack {
                    self.label()
                    Spacer()
                    Image(systemName: self.collapsed ? "chevron.down" : "chevron.up")
                }
                .padding(.bottom, 1)
                .background(Color.white.opacity(0.01))
            }.buttonStyle(PlainButtonStyle())
            
            VStack { self.content() }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: collapsed ? 0 : .none)
            .clipped()
            .animation(.easeOut)
            .transition(.slide)
        }
    }
}
