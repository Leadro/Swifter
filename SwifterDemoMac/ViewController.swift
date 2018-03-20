//
//  ViewController.swift
//  SwifterDemoMac
//
//  Copyright (c) 2014 Matt Donnelly.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Cocoa
import Accounts
import SwifterMac



class ViewController: NSViewController {

    let useACAccount = false
    @objc dynamic var tweets: [Tweet] = []
    let swifter = Swifter(consumerKey: "RErEmzj7ijDkJr60ayE2gjSHT", consumerSecret: "SbS0CHk11oJdALARa7NDik0nty4pXvAxdt7aj0R5y1gNzWaNEx")
    override func viewDidLoad() {
        super.viewDidLoad()

        let failureHandler: (Error) -> Void = { print($0.localizedDescription) }

        guard let auth_user = UserProfile.shared.getUserCredential() else {
            
            swifter.authorize(with: URL(string: "swifter://success")!, success: { credentials, response in
                UserProfile.shared.setUserCredentials(by: credentials)
                self.swifter.getHomeTimeline(count: 100, success: { statuses in
                    guard let tweets = statuses.array else { return }
                    self.tweets = tweets.map {
                        let tweet = Tweet()
                        tweet.text = $0["text"].string!
                        tweet.name = $0["user"]["name"].string!
                        return tweet
                    }
                }, failure: failureHandler)
            }, failure: failureHandler)
            return
        }
        
        swifter.client.credential = auth_user
        self.swifter.getHomeTimeline(count: 100, success: { statuses in
            guard let tweets = statuses.array else { return }
            self.tweets = tweets.map {
                let tweet = Tweet()
                tweet.text = $0["text"].string!
                tweet.name = $0["user"]["name"].string!
                return tweet
            }
        }, failure: failureHandler)
    }

}

@objcMembers
class Tweet: NSObject {
    
    var name: String!
    var text: String!
    
}
