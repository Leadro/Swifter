//
//  UserProfile.swift
//  SwifterDemoMac
//
//  Created by Maxim Tartachnik on 3/20/18.
//  Copyright © 2018 Matt Donnelly. All rights reserved.
//

import Foundation
import SwifterMac

struct TwiUser : Codable {
    var userId = String()
    var screenName = String()
}

class UserProfile {
    
    enum SettingsKeys :String {
        case user = "logined_user"
        case accessKey = "accessKey"
        case accessSecret = "accessSecret"
    }
    
    static let shared = UserProfile()
    private let defaults = UserDefaults.standard
    private var accessKey :String? {
        get { return value(forKey: .accessKey) as? String }
        set (newValue) { set(newValue, forKey: .accessKey) }
    }
    
    private var accessSecret :String? {
        get { return value(forKey: .accessSecret) as? String }
        set (newValue) { set(newValue, forKey: .accessSecret) }
    }
    
    var auth_user :TwiUser {
        get{
            let storedObject: Data = value(forKey: .user) as! Data
            return try! PropertyListDecoder().decode(TwiUser.self, from: storedObject)
        }
        set(newValue){
            set(try! PropertyListEncoder().encode(newValue), forKey: .user)
        }
    }
    
    var userIdTag :UserTag { get{ return .id(auth_user.userId) } }
    var userIdString :String { get{ return auth_user.userId } }
    
    var userScreenNameTag :UserTag { get{ return .screenName(auth_user.screenName) } }
    var userScreenName :String { get{ return auth_user.screenName } }
    
    func setUserCredentials(by token :Credential.OAuthAccessToken?) {
        self.accessSecret = token?.secret
        self.accessKey = token?.key
        
        auth_user = TwiUser(userId: token?.userID ?? "",
                            screenName: token?.screenName ?? "")
    }
    
    func getUserCredential() -> Credential? {
        guard let key = self.accessKey, let sec = self.accessSecret else { return nil }
        
        let access = Credential.OAuthAccessToken(key: key , secret: sec)
        return Credential(accessToken: access)
    }
    
    private func set(_ value: Any?, forKey key: SettingsKeys)  {
        defaults.set(value, forKey: key.rawValue)
    }
    
    private func value(forKey key: SettingsKeys) -> Any?  {
        return defaults.value(forKey: key.rawValue)
    }
}
