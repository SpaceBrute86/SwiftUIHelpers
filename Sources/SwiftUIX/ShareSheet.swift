//
//  File.swift
//  
//
//  Created by Bobbie Markwick on 29/10/21.
//

import SwiftUI


#if os(iOS)


public struct ShareSheet: UIViewControllerRepresentable {
    public typealias Callback = (_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ error: Error?) -> Void
    
    let activityItems: [Any]
    let applicationActivities: [UIActivity]?
    let excludedActivityTypes: [UIActivity.ActivityType]?
    let callback: Callback?
    
    public init(activityItems:[Any]){
        self.activityItems = activityItems
        self.applicationActivities=nil
        self.excludedActivityTypes=nil
        self.callback=nil
    }
    public init(activityItems:[Any], applicationActivities:[UIActivity]? = nil, excludedActivityTypes:[UIActivity.ActivityType]?=nil, callback:Callback? = nil){
        self.activityItems = activityItems
        self.applicationActivities=applicationActivities
        self.excludedActivityTypes=excludedActivityTypes
        self.callback=callback
    }
    
    public func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = callback
        return controller
    }
    
    public func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // nothing to do here
    }
}


#endif
