import SwiftUI

extension Binding {
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


extension String:Identifiable  {
    var hasSpaces:Bool { return self.components(separatedBy: .whitespaces).count > 1 }
    public var id:String { return self }
}
extension Array:Identifiable where Element:Identifiable{
    public var id:String{
        return self.reduce("["){ $0 + ", \($1.id)" }+"]"
    }
}

