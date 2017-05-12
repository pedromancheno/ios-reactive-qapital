//
//  ListModel.swift
//  QapitalDataSource
//
//  Created by Mikael Gransell on 2017-01-06.
//  Copyright © 2017 Qapital Inc. All rights reserved.
//

import Foundation
import ReactiveSwift

public protocol Section {
    associatedtype Element

    var items: [Element] { get }
}

public protocol ListViewModel {
    associatedtype _Section: Section

    var sections: [_Section] { get }
}

public protocol UpdatableListViewModel {
    associatedtype _Section: Section

    var updatableSections: Property<[_Section]> { get }
}

extension UpdatableListViewModel {
    public var sections: [_Section] {
        return updatableSections.value
    }
}

public struct BasicListViewSection<T>: Section {
    public var items: [T]

    public init(items: [T]) {
        self.items = items
    }
}
