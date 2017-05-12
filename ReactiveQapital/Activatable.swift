//
//  Activatable.swift
//  ReactiveQapital
//
//  Created by Mikael Gransell on 2017-05-10.
//  Copyright © 2017 Qapital Inc. All rights reserved.
//

import Foundation
import Result
import ReactiveSwift

protocol Activatable {
    var active: MutableProperty<Bool> { get }
}

extension Activatable {
    /// Signal that will send the active state when it changes
    var activeStateChanaged: Signal<Bool, NoError> {
        return active.signal.skipRepeats()
    }
}

extension Activatable where Self: NSObject {

    /// Signal that will trigger each time the ViewModel becomes active as well as if the
    /// ViewModel is active while the app is foregrounded, i.e. its view is visible while foregrounding
    var didBecomeActive: Signal<(), NoError> {

        let foregrounded = NotificationCenter
            .default
            .reactive.notifications(forName: .UIApplicationWillEnterForeground, object: nil)
            .take(during: reactive.lifetime)
            .filter { [unowned self] _ in self.active.value }
            .map { _ in () }
        let active = activeStateChanaged.filter { $0 }.take(during: reactive.lifetime).map { _ in () }

        return Signal.merge([active, foregrounded])
    }

    /// Signal that will trigger once each time the app is opened or foregrounded
    var firstActiveAfterOpen: Signal<(), NoError> {

        let foregroundTrigger = NotificationCenter
            .default
            .reactive.notifications(forName: .UIApplicationWillEnterForeground, object: nil)
            .map { _ in () }
        let initialTrigger = didBecomeActive.take(first: 1).take(until: foregroundTrigger)

        let activeAfterForground = foregroundTrigger
            .flatMap(.latest) { [unowned self] _ in self.didBecomeActive.take(first: 1) }

        return Signal.merge([initialTrigger, activeAfterForground]).take(during: reactive.lifetime)
    }
}
