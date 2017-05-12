//
//  UsersViewController.swift
//  ReactiveQapital
//
//  Created by Mikael Gransell on 2017-04-29.
//  Copyright © 2017 Qapital Inc. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class UsersViewController: UIViewController, ViewModelDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var toggleButton: UIButton!

    var viewModel: UsersViewModel!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.active.value = true
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        viewModel.active.value = false
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = UsersViewModel(withDelegate: self)

        title = "Reactive Qapital"

        setupButton()
        setupTableView()
    }

    private func setupButton() {
        toggleButton.reactive.pressed = CocoaAction(viewModel.toggleAction)
    }

    private func setupTableView() {

        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 72

        tableView.delegate = self
        tableView.dataSource = self

        viewModel.updatableSections.signal.observeValues { [unowned self] (_) in
            self.tableView.reloadData()
        }
    }

    // MARK: - UITableViewDataSource/Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = viewModel.sections[section]
        return section.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellItem = item(at: indexPath)

        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
        cell.update(withModel: cellItem)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellItem = item(at: indexPath)
        viewModel.selectedItem.value = cellItem
    }

    private func item(at indexPath: IndexPath) -> UserItemViewModel {
        let section = viewModel.sections[indexPath.section]
        return section.items[indexPath.row]
    }
}
