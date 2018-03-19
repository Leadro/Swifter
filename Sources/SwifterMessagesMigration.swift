//
//  SwifterMessagesMigration.swift
//  SwifterDemoiOS
//
//  Created by Maxim Tartacahnik on 3/20/18.
//  Copyright © 2018 Matt Donnelly. All rights reserved.
//

import Foundation

public extension Swifter {
    public func getDirectEventsList(count: Int? = nil, cursor: String? = nil, success: SuccessHandler? = nil, failure: FailureHandler? = nil) {
        let path = "direct_messages/events/list.json"
        
        var parameters = Dictionary<String, Any>()
        parameters["count"] ??= count
        parameters["cursor"] ??= cursor
        
        self.getJSON(path: path, baseURL: .api, parameters: parameters, success: { json, _ in success?(json) }, failure: failure)
    }
}
