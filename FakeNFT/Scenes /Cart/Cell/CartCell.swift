import UIKit
import Kingfisher

protocol CartCellDelegate: AnyObject {
    func showDeleteView(index: Int)
}

final class CartCell: UITableViewCell {

    static let identifier = "NFTTableViewCell"

    var imageURL: URL? {
        didSet {
            guard let url = imageURL else {
                return nftImageView.kf.cancelDownloadTask()
            }

            nftImageView.kf.setImage(with: url)
        }
    }

    weak var delegate: CartCellDelegate?
    var indexCell: Int?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: CartCell.identifier)
        addViews()
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    private lazy var formattedPrice: NumberFormatter = {
        let formatted = NumberFormatter()
        formatted.locale = Locale(identifier: "ru_RU")
        formatted.numberStyle = .decimal
        return formatted
    }()

    private lazy var nftImageView: UIImageView = {
        let nftImageView = UIImageView()
        nftImageView.layer.cornerRadius = 16
        nftImageView.layer.masksToBounds = true
        nftImageView.image = UIImage(named: "mockImageNft")
        return nftImageView
    }()

    private lazy var nftNameLabel: UILabel = {
        let nftNameLabel = UILabel()
        nftNameLabel.text = "April"
        nftNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return nftNameLabel
    }()

    private lazy var nftRatingLabel: UIImageView = {
        let nftRatingLabel = UIImageView()
        return nftRatingLabel
    }()

    private lazy var nftRatingStack: UIStackView = {
        let nftRatingStack = UIStackView()
        nftRatingStack.axis = .horizontal
        nftRatingStack.spacing = 4
        return nftRatingStack
    }()

    private lazy var nftPriceLabel: UILabel = {
        let nftPriceLabel = UILabel()
        nftPriceLabel.text = "Цена"
        nftPriceLabel.font = UIFont.systemFont(ofSize: 13)
        return nftPriceLabel
    }()

    private lazy var nftPrice: UILabel = {
        let nftPrice = UILabel()
        nftPrice.text = "1,78 ETH"
        nftPrice.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return nftPrice
    }()

    private lazy var deleteFromBasketButton: UIButton = {
        let deleteFromBasketButton = UIButton(type: .custom)
        deleteFromBasketButton.setImage(UIImage(named: "inCart"), for: .normal)
        deleteFromBasketButton.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        return deleteFromBasketButton
    }()

    private func addViews() {
        [nftImageView, nftNameLabel, nftPriceLabel, nftPrice, nftRatingStack].forEach(setupView(_:))
        [deleteFromBasketButton].forEach(contentView.setupView(_:))
    }

    private func setupUI() {
        NSLayoutConstraint.activate([
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            nftNameLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            nftRatingStack.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            nftRatingStack.topAnchor.constraint(equalTo: nftNameLabel.bottomAnchor, constant: 4),
            nftPriceLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            nftPriceLabel.topAnchor.constraint(equalTo: nftRatingStack.bottomAnchor, constant: 12),
            nftPrice.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            nftPrice.topAnchor.constraint(equalTo: nftPriceLabel.bottomAnchor, constant: 2),
            deleteFromBasketButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            deleteFromBasketButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func configureCell(model: NFTModel) {
        imageURL = model.images.first
        if let formattedPrice = formattedPrice.string(from: NSNumber(value: model.price)) {
            nftPrice.text = "\(formattedPrice) ETH"
        }
        nftNameLabel.text = model.name

        for rating in nftRatingStack.arrangedSubviews {
            rating.removeFromSuperview()
        }

        let rating = model.rating

        for _ in 0..<rating {
            let ratingStar = UIImageView(image: UIImage(named: "star_yellow"))
            nftRatingStack.addArrangedSubview(ratingStar)
        }
        for _ in rating..<5 {
            let emptyStar =  UIImageView(image: UIImage(named: "star"))
            nftRatingStack.addArrangedSubview(emptyStar)
        }
    }

    @objc func didTapDeleteButton() {
        guard let indexCell else { return }
        delegate?.showDeleteView(index: indexCell)
    }
}
