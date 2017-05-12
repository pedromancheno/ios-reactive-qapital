import Result
import ReactiveSwift

public enum SelectionOption {
    /// Normal option to select
    case option(String)
    /// Destructive option
    case destructive(String)
    /// Canceling option
    case canceling(String)

    public var title: String {
        switch self {
        case .option(let t), .destructive(let t), .canceling(let t):
            return t
        }
    }
}

public enum SelectionStyle: Int {
    case alert
    case actionSheet
}

public protocol ViewModelDelegate: class {

    /**
     Ask the user to select from a list of options
     
     - parameters:
        - options: List of options to select from
        - title: Optional title to describe what to select
        - body: Descriptive body
        - style: How this should be presented to the user
     - returns: A SignalProducer that should send the selected option and complete
     */
    func select(from options: [SelectionOption],
                withTitle title: String?,
                body: String?,
                andStyle style: SelectionStyle) -> SignalProducer<SelectionOption, NoError>
}
