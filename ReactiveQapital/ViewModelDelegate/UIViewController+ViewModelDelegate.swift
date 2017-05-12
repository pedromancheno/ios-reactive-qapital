
import UIKit
import Result
import ReactiveSwift

extension SelectionOption {
    var uiStyle: UIAlertActionStyle {
        switch self {
        case .canceling(_):
            return .cancel
        case .destructive(_):
            return .destructive
        case .option(_):
            return .default
        }
    }
}

extension SelectionStyle {
    var uiStyle: UIAlertControllerStyle {
        switch self {
        case .alert:
            return .alert
        case .actionSheet:
            return .actionSheet
        }
    }
}

extension ViewModelDelegate where Self: UIViewController {
    public func select(from options: [SelectionOption], withTitle title: String?, body: String?, andStyle style: SelectionStyle) -> SignalProducer<SelectionOption, NoError> {
        let alert = UIAlertController(title: title, message: body, preferredStyle: style.uiStyle)

        return SignalProducer { (observer, disposable) in

            for option in options {
                alert.addAction(UIAlertAction(title: option.title, style: option.uiStyle, handler: { (_) in
                    observer.send(value: option)
                    observer.sendCompleted()
                }))
            }
        }.on(started: { [unowned self] _ in
            // Present when the producer is started
            self.present(alert, animated: true, completion: nil)
        }, disposed: {
            // If we are still presenting then dismiss
            if alert.presentingViewController != nil {
                alert.dismiss(animated: true, completion: nil)
            }
        })
    }
}
