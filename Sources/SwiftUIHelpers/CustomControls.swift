//
//  File.swift
//  
//
//  Created by Bobbie Markwick on 29/10/21.
//

import SwiftUI


public struct OptionalNumberTextField:View{
    public var reference:Binding<Double?>

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
    public var title:String
    @Binding public var item:T
    public var list:[T]
    public var names:[String]
    @State public var idx:Int

    public var body: some View {
        Picker(title, selection: $idx.didSet{ n in item = list[n] })
        { ForEach(0..<list.count){ n in Text(names[n]) } }.pickerStyle(DefaultPickerStyle())
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
                Text(title).padding(.trailing).lineLimit(1)
                Spacer()
                if value { content }
                else { content.hidden() }
                Toggle("", isOn: $value.didSet{ val in
                    reference = val
                }).labelsHidden()
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

