//
//  UsersViewModel.swift
//  ReactiveQapital
//
//  Created by Mikael Gransell on 2017-04-29.
//  Copyright © 2017 Qapital Inc. All rights reserved.
//

import UIKit
import Result
import ReactiveSwift
import ReactiveCocoa

class UserItemViewModel: UserCellModel {
    let user: User

    let title: String
    let avatar: SignalProducer<UIImage?, NoError>
    let enabled: Bool

    init(with user: User) {
        self.user = user

        title = user.displayName
        avatar = API.shared.image(at: user.avatarURL) // -> SignalProducer<UIImage?, APIError>
            .flatMapError { (_) -> SignalProducer<UIImage?, NoError> in
                return SignalProducer(value: nil)
        } // -> SignalProducer<UIImage?, NoError>
        enabled = user.enabled
    }
}


class UsersViewModel: NSObject, Activatable, ListViewModel, UpdatableListViewModel {

    let active = MutableProperty(false)

    typealias _Section = BasicListViewSection<UserItemViewModel>
    var updatableSections: Property<[_Section]> {
        return Property(_updatableSections)
    }
    private let _updatableSections = MutableProperty<[_Section]>([])

    let selectedItem = MutableProperty<UserItemViewModel?>(nil)

    let toggleAction: Action<(), (), APIError>

    init(withDelegate delegate: ViewModelDelegate) {

        let state = selectedItem.map { (itemModel) -> User? in
            return itemModel?.user
        }
        let enabled = { (user: User?) -> Bool in
            return user != nil
        }

        toggleAction = Action(state: state, enabledIf: enabled) { (selected, _) in
            let toggled = User(id: selected!.id,
                               displayName: selected!.displayName,
                               avatarURL: selected!.avatarURL,
                               enabled: !(selected!.enabled))
            return delegate
                .select(from: [.canceling("Cancel"), .option("Continue")],
                        withTitle: "Toggle State",
                        body: "Are you sure you want to toggle the state of this user",
                        andStyle: .alert)
                .flatMap(.latest) { (option) -> SignalProducer<(), APIError> in
                    if case .canceling(_) = option {
                        return .empty
                    }
                    return API.shared.store(user: toggled)
            }
        }

        selectedItem <~ toggleAction.values.map { _ in
            return nil
        }

        super.init()

        setupSections()
    }

    private func setupSections() {

        let reloadTrigger: Signal<(), NoError> = Signal.merge([didBecomeActive, toggleAction.values])

        _updatableSections <~ reloadTrigger
            .flatMap(.latest) { _ in
                return API.shared.users()
            } // -> [User]
            .map { (users) -> [_Section] in
                let userItems = users.map { UserItemViewModel(with: $0) }
                return [BasicListViewSection(items: userItems)]
            } // -> [BasicListViewSection<UserItemViewModel>]
            .flatMapError { (_) -> SignalProducer<[_Section], NoError> in
                return .empty
        } // -> SignalProducer<[_Section], NoError>
    }

}
