import UIKit

enum CartSegue {
    case pay
    case choicePayment
    case purchaseResult
}

protocol CartRouter {
    func perform(_ segue: CartSegue, from source: CartViewController)
}

final class DefaultCartRouter: CartRouter {

    private var viewModel: CartViewModelProtocol

    init(viewModel: CartViewModelProtocol = CartViewModel()) {
        self.viewModel = viewModel
    }

    func perform(_ segue: CartSegue, from source: CartViewController) {
        switch segue {
        case .pay:
            let vc = DefaultCartRouter.makePaymentViewController()
            source.navigationController?.present(vc, animated: true)
        case .choicePayment:
            let vc = DefaultCartRouter.makePaymentViewController()
            source.navigationController?.present(vc, animated: true)
        case .purchaseResult:
            let vc = DefaultCartRouter.makePaymentViewController()
            source.navigationController?.present(vc, animated: true)
        }
    }

    static func makeCartViewController() -> UINavigationController {
        let vc = CartViewController()
        let nc = UINavigationController(rootViewController: vc)
        return nc
    }

    static func makePaymentViewController() -> UIViewController {
        let vc = PaymentChoiceViewController()
        vc.modalPresentationStyle = .fullScreen
        return vc
    }

    static func makePurchaseViewController() -> UIViewController {
        let vc = PurchaseResultViewController()
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}
