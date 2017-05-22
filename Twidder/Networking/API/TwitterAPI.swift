//
//  OAuthClient.swift
//  Twidder
//
//  Created by Javi Lorbada on 21/05/2017.
//  Copyright © 2017 Javi Lorbada. All rights reserved.
//

import Foundation
import OAuthSwift
import ReactiveSwift
import Unbox

enum NetworkError: Error {
  case failed(reason: String)
  case parsingError
}


/// Protocol to mock tests requests.
protocol TwitterRequest {
  
  var url: String { get }
}

struct GetTweetsRequest: TwitterRequest {
  
  var url: String = "https://api.twitter.com/1.1/search/tweets.json"
}

final class TwitterAPI {

  private static let oauthClient = OAuthSwiftClient(consumerKey: "Q827X2ZyFgPWod7P2DiA561tI",
                                                    consumerSecret: "oIqrFOuqQs77KVwTSv5ZsARcQ36LgzBrrpUsQuHyR9fLVot5J7",
                                                    version: .oauth1)

  static func getTweets(for searchTerm: String,
                        around location: Geolocation,
                        request: TwitterRequest = GetTweetsRequest()) -> SignalProducer<[Tweet], NetworkError> {
    
    return SignalProducer { observer, disposable in
			
      let url = request.url
      let parameters = ["q": searchTerm,
                        "result_type": "mixed",
                        "geocode": "\(location.latitude),\(location.longitude),500km",
                        "count": "100"]
      
      let request = TwitterAPI.oauthClient
        .get(url, parameters: parameters, success: { response in
          
          guard let statuses: Statuses = try? unbox(data: response.data) else {
            observer.send(error: NetworkError.parsingError)
            return
          }
          let locationTweets = statuses.tweets.filter { $0.location != nil }
          observer.send(value: locationTweets)
          observer.sendCompleted()
        }, failure: { error in
          dump(error)
          observer.send(error: NetworkError.failed(reason: error.localizedDescription))
      })
      
      disposable.add {
        request?.cancel()
        observer.sendInterrupted()
      }
    }
  }
}
