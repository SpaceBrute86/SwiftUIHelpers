import SwiftUI

//MARK: Bindings
public extension Binding {
    func willSet(_ willSet: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { wrappedValue },
            set: { newValue in
                willSet(wrappedValue)
                self.wrappedValue = newValue
            }
        )
    }
    func didSet(_ didSet: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                didSet(newValue)
            }
        )
    }
}

//MARK: Strings and Arrays with ForEach
extension String:Identifiable  {
    public var hasSpaces:Bool { return self.components(separatedBy: .whitespaces).count > 1 }
    public var id:String { return self }
}
extension Array:Identifiable where Element:Identifiable{
    public var id:String{
        return self.reduce("["){ $0 + ", \($1.id)" }+"]"
    }
}


//MARK: Image + Color Types
#if os(macOS)
import AppKit
public typealias SuiImage = NSImage
public extension Image { init(image:SuiImage){ self.init(nsImage: image) } }

@available(macOS 12.0, *)
public extension Color {
    static var background:Color{ Color(nsColor:NSColor.textBackgroundColor) }
    static var label:Color{ Color(nsColor:NSColor.textColor) }
}
#else
import UIKit
public typealias SuiImage = UIImage
public extension Image { init(image:SuiImage){ self.init(uiImage:image) } }
@available(iOS 15.0, *)
public extension Color {
    #if !os(watchOS)
    static var background:Color{ Color(uiColor:UIColor.systemBackground) }
    static var label:Color{ Color(uiColor:UIColor.label) }
    #else
    static var background:Color{ Color.black }
    static var label:Color{ Color.white }
    #endif
}
#endif
