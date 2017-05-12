//
//  UserCell.swift
//  ReactiveQapital
//
//  Created by Mikael Gransell on 2017-04-29.
//  Copyright © 2017 Qapital Inc. All rights reserved.
//

import UIKit
import Result
import ReactiveSwift
import ReactiveCocoa

protocol UserCellModel {
    var avatar: SignalProducer<UIImage?, NoError> { get }
    var title: String { get }
    var enabled: Bool { get }
}

class UserCell: UITableViewCell {

    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var enabledImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = 16
    }

    func update(withModel model: UserCellModel) {
        avatarImageView.reactive.image <~ model.avatar.take(until: reactive.prepareForReuse)
        titleLabel.text = model.title
        enabledImageView.image = model.enabled ? UIImage(named: "enabled") : UIImage(named: "disabled")
    }
}
