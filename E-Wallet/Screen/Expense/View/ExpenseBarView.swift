//
//  ExpenseBarView.swift
//  E-Wallet
//
//  Created by đào sơn on 15/05/2023.
//

import UIKit

protocol ExpenseBarViewDelegate: AnyObject {
    func expenseBarViewDidSelectExpense(_ expenseBarView: ExpenseBarView)
    func expenseBarViewDidSelectIncome(_ expenseBarView: ExpenseBarView)
}

class ExpenseBarView: UIView {

    // MARK: - Variables
    private var containerView: UIView!
    private var stackView: UIStackView!
    private var expenseView: TapableView!
    private var expenseLabel: UILabel!
    private var incomeView: TapableView!
    private var incomeLabel: UILabel!

    var isOnExpenseMode = true {
        didSet {
            reloadUI()
        }
    }

    weak var delegate: ExpenseBarViewDelegate?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    private func commonInit() {
        self.config()
        self.addContentViews()
        self.addLayoutConstraints()
        self.reloadUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.containerView.layer.cornerRadius = 24
        self.stackView.layer.cornerRadius = 24
        self.expenseView.layer.cornerRadius = 24
        self.incomeView.layer.cornerRadius = 24
    }

    // MARK: - Config
    private func config() {
        self.containerView = UIView()
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.layer.cornerRadius = 24

        self.stackView = UIStackView()
        self.stackView.axis = .horizontal
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.distribution = .fillEqually
        self.stackView.backgroundColor = UIColor(rgb: 0xF1F1FA)
        self.stackView.layer.cornerRadius = 24

        self.expenseView = TapableView()
        self.expenseView.cornerRadius = 24
        self.expenseView.translatesAutoresizingMaskIntoConstraints = false
        self.expenseView.addTarget(self, action: #selector(didTapExpense(_:)), for: .touchUpInside)

        self.expenseLabel = UILabel()
        self.expenseLabel.translatesAutoresizingMaskIntoConstraints = false
        self.expenseLabel.text = "Expense"
        self.expenseLabel.font = Outfit.regularFont(size: 18.0)
        self.expenseLabel.textColor = .black
        self.expenseLabel.textAlignment = .center

        self.incomeView = TapableView()
        self.incomeView.cornerRadius = 24
        self.incomeView.translatesAutoresizingMaskIntoConstraints = false
        self.incomeView.addTarget(self, action: #selector(didTapIncome(_:)), for: .touchUpInside)

        self.incomeLabel = UILabel()
        self.incomeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.incomeLabel.text = "Income"
        self.incomeLabel.font = Outfit.regularFont(size: 18.0)
        self.incomeLabel.textColor = .black
        self.incomeLabel.textAlignment = .center
    }

    private func addContentViews() {
        self.addSubview(self.containerView)
        self.containerView.addSubview(self.stackView)
        self.stackView.addArrangedSubview(self.expenseView)
        self.stackView.addArrangedSubview(self.incomeView)
        self.expenseView.addSubview(self.expenseLabel)
        self.incomeView.addSubview(self.incomeLabel)
    }

    private func addLayoutConstraints() {
        self.containerView.fitSuperviewConstraint()
        self.stackView.fitSuperviewConstraint()
        self.expenseLabel.fitSuperviewConstraint()
        self.incomeLabel.fitSuperviewConstraint()
    }

    func reloadUI() {
        UIView.animate(withDuration: 0.25, delay: 0) {
            self.expenseLabel.backgroundColor = self.isOnExpenseMode ? .crayola : UIColor(rgb: 0xF1F1FA)
            self.expenseLabel.textColor = self.isOnExpenseMode ? .white : .black
            self.incomeLabel.backgroundColor = self.isOnExpenseMode ? UIColor(rgb: 0xF1F1FA) : .crayola
            self.incomeLabel.textColor = self.isOnExpenseMode ? .black : .white
            self.layoutIfNeeded()
        }
    }

    // MARK: - Actions
    @objc func didTapExpense(_ sender: UIButton) {
        self.isOnExpenseMode = true
        self.delegate?.expenseBarViewDidSelectExpense(self)
    }

    @objc func didTapIncome(_ sender: UIButton) {
        self.isOnExpenseMode = false
        self.delegate?.expenseBarViewDidSelectIncome(self)
    }
}
