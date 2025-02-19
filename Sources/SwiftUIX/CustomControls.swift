//
//  File.swift
//  
//
//  Created by Bobbie Markwick on 29/10/21.
//

import SwiftUI


@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct CommittingNumberField:View{
    @State var titleKey:LocalizedStringKey
    @State var get:()->Double
    @State var set:(Double, Transaction) -> Void
    @State var onCommit:()->()
    
    private enum Field: Hashable { case selected, deselected }
    @FocusState private var focusedField: Field?
    
    public var body: some View {
        Group{
            TextField(titleKey, value: Binding(get: get, set: set), format: .number)
                .onSubmit { onCommit() }
                .focused($focusedField, equals: .selected)
            //Dummy View
            if focusedField == .selected {  VStack{ }.onDisappear{ onCommit() }  }
        }
    }
}

public struct OptionalNumberTextField:View{
    public var reference:Binding<Double?>
    
    public init(reference:Binding<Double?>) { self.reference = reference }

    public var body: some View { OptionalNumberTextContent(reference: reference, value: { () -> String in
        if let val = reference.wrappedValue { return "\(val)" }
        else {return ""}
    }())}
    fileprivate struct OptionalNumberTextContent:View{
        var reference:Binding<Double?>
        @State var value:String
        
        var body: some View {
            TextField("", text: $value.didSet{ val in
                reference.wrappedValue = Double(val)
            }).multilineTextAlignment(.leading)
        }
    }
    
}


public struct ArrayPicker<T>:View {
    var title:String
    var item:Binding<T>
    var list:[T]
    var names:[String]
    var idx:State<Int>
    
    public init(title:String, item:Binding<T>, list:[T], names:[String], idx:Int){
        self.title = title
        self.item = item
        self.list=list
        self.names = names
        self.idx = State<Int>(wrappedValue: idx)
    }

    public var body: some View {
        Picker(title, selection: idx.projectedValue.didSet{ n in item.wrappedValue = list[n] })
        { ForEach(0..<list.count, id: \.self){ n in Text(names[n]) } }.pickerStyle(DefaultPickerStyle())
    }
}


public struct ToggledItem<Content: View>:View{
    var title:String = ""
    var value:Binding<Bool>
    var content:Content
    
    public init(title:String, value:Binding<Bool>, @ViewBuilder content: () -> Content) { self.title = title; self.value = value; self.content = content()  }
    
    public var body: some View {
        ToggledItemContent(title:title, reference: value, value: value.wrappedValue, content: content)
    }
    
    fileprivate struct ToggledItemContent<Content: View>:View{
        var title:String
        @Binding var reference:Bool
        @State var value:Bool
        var content:Content

        var body: some View {
            HStack(spacing:5.0){
                #if os(macOS) || targetEnvironment(macCatalyst)
                Toggle(title, isOn: $value.didSet{ val in
                    reference = val
                }).padding(.trailing)
                if value { content }
                else { content.hidden() }
                #else
                Text(title).padding(.trailing).lineLimit(1)
                Spacer()
                if value { content }
                else { content.hidden() }
                Toggle("", isOn: $value.didSet{ val in
                    reference = val
                }).labelsHidden()
                #endif
            }
        }
    }
}


public struct SelectableRow:View {
    public var title:String
    @State var selected:Bool{
        didSet { if selected { select() } else { deselect() } }
    }
    public var select:()->()
    public var deselect:()->()
    
    public init(title:String, selected:Bool, select:@escaping ()->(), deselect:@escaping ()->()){
        self.title = title
        self.selected = selected
        self.select = select
        self.deselect = deselect
    }

    public var body: some View{
        Button(action: {selected.toggle()}, label: {  HStack{
            Text(title); Spacer()
            if selected  { Image(systemName: "checkmark").padding(.trailing, 5.0) }
        }}).accentColor(Color.primary)
    }
}

