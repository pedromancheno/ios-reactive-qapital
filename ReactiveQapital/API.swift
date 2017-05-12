//
//  API.swift
//  ReactiveQapital
//
//  Created by Mikael Gransell on 2017-04-29.
//  Copyright © 2017 Qapital Inc. All rights reserved.
//

import UIKit
import Argo
import Alamofire
import ReactiveSwift

enum APIError: Error {
    case failed
}

final class API {

    static let shared = API()

    func image(at url: URL) -> SignalProducer<UIImage?, APIError> {
        return SignalProducer { (observer, disposable) in
            let req = Alamofire
                .request(url)
                .responseData(completionHandler: { (response) in
                    guard let data = response.value, let image = UIImage(data: data) else {
                        observer.send(error: .failed)
                        return
                    }

                    observer.send(value: image)
                    observer.sendCompleted()
                })

            disposable.add {
                req.cancel()
            }
        }
    }

    func users() -> SignalProducer<[User], APIError> {
        return SignalProducer { (observer, disposable) in
            let req = Alamofire
                .request("http://localhost:4567/users")
                .responseJSON(completionHandler: { (response) in
                    guard let json = response.result.value, let users: [User] = decode(json) else {
                        observer.send(error: .failed)
                        return
                    }
                    observer.send(value: users)
                    observer.sendCompleted()
                })

            disposable.add {
                req.cancel()
            }
        }
    }

    func store(user: User) -> SignalProducer<(), APIError> {

        return SignalProducer { (observer, disposable) in
            let req = Alamofire
                .request("http://localhost:4567/user", method: HTTPMethod.post, parameters: user.toJSON(), encoding: JSONEncoding.default)
                .response(completionHandler: { (response) in
                    if response.error != nil {
                        observer.send(error: .failed)
                        return
                    }
                    observer.send(value: ())
                    observer.sendCompleted()
                })

            disposable.add {
                req.cancel()
            }
        }
    }

    private init() {
    }
}
