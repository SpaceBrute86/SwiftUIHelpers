#if os(iOS) || os(tvOS)
import SwiftUI
import UIKit


extension UIViewController {
    @IBAction func dismiss(){
        self.dismiss(animated: true, completion: nil)
    }
    func addSwiftUI<Content:View>(view:Content){
        let childView = UIHostingController(rootView:  view)
        addChild(childView)
        childView.view.frame = self.view.bounds
        self.view.addConstrained(subview: childView.view)
        childView.didMove(toParent: self)
    }
}

extension UIView {
    func addConstrained(subview: UIView) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.topAnchor.constraint(equalTo: topAnchor).isActive = true
        subview.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        subview.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        subview.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}

#endif
