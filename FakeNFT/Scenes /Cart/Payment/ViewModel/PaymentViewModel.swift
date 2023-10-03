import UIKit

protocol PaymentViewModelProtocol {
    var currencies: [CurrencyModel] { get }
    var isLoading: Bool { get }
    var currenciesObservable: Observable<[CurrencyModel]> { get }
    var paymentStatusObservable: Observable<PaymentStatus> { get }
    var isLoadingObservable: Observable<Bool> { get }
    func selectCurrency(with id: String)
    func didLoad()
    func didTapPaymentButton()
}

final class PaymentViewModel: PaymentViewModelProtocol {

    @Observable
    private (set) var currencies: [CurrencyModel] = []

    @Observable
    private (set) var paymentStatus: PaymentStatus = .notPay

    @Observable
    private (set) var isLoading: Bool = false

    private var selectedCurrency: CurrencyModel?

    var currenciesObservable: Observable<[CurrencyModel]> { $currencies }
    var paymentStatusObservable: Observable<PaymentStatus> { $paymentStatus }
    var isLoadingObservable: Observable<Bool> { $isLoading }

    private let cartLoadService: CartLoadServiceProtocol

    init(model: CartLoadServiceProtocol = CartLoadService()) {
        self.cartLoadService = model
    }

    func didLoad() {
            isLoading = true
            cartLoadService.fetchCurrencies { [weak self] result in
                self?.isLoading = true
                DispatchQueue.main.async {
                       guard let self else { return }
                       switch result {
                       case let .success(currencies):
                           self.currencies = currencies
                           self.isLoading = false
                       case let .failure(error):
                           print(error)
                           self.isLoading = false
                       }
                }
            }
        isLoading = false
    }

    func selectCurrency(with id: String) {
        self.selectedCurrency = currencies.first(where: { $0.id == id })
    }

    func didTapPaymentButton() {
        isLoading = true
        guard let id = selectedCurrency?.id else { return }
        cartLoadService.sendingPaymentInfo(id: id) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.paymentStatus = .pay
                case let .failure(error):
                    print(error)
                    self.isLoading = false
                    self.paymentStatus = .notPay
                    self.selectedCurrency = nil
                }
            }
        }
        isLoading = false
    }
}
