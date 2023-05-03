//
//  FilterViewController.swift
//  E-Wallet
//
//  Created by đào sơn on 28/04/2023.
//

import RIBs
import RxSwift
import UIKit
import RangeSeekSlider

private struct Const {
    static let maxAmount = 2000.0
    static let minAmount = 0.0
}

protocol FilterPresentableListener: AnyObject {
    func didTapCancel()
    func didUpdateFilterModel(filterModel: FilterModel)
    func didTapFilter(filterModel: FilterModel)
}

final class FilterViewController: UIViewController, FilterPresentable, FilterViewControllable {

    // MARK: - Outlets
    @IBOutlet private weak var monthFilterView: FilterSelectionView!
    @IBOutlet private weak var serviceFilterView: FilterSelectionView!
    @IBOutlet private weak var statusFilterView: FilterSelectionView!
    @IBOutlet private weak var rangeSeekSlider: RangeSeekSlider!

    // MARK: - Variables
    weak var listener: FilterPresentableListener?
    private var filterModel = FilterModel(month: "All", service: "All", startAmount: Const.minAmount, endAmount: Const.maxAmount, status: "All")

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }

    init(filterModel: FilterModel?) {
        if let filterModel = filterModel {
            self.filterModel = filterModel
        }

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func config() {
        self.configMonthFilterView()
        self.configServiceFilterView()
        self.configStatusFilterView()
        self.configRangeSeekSlider()
    }

    private func configRangeSeekSlider() {
        self.rangeSeekSlider.tintColor = .lightGray
        self.rangeSeekSlider.numberFormatter.numberStyle = .currency
        self.rangeSeekSlider.minLabelFont = Outfit.regularFont(size: 16.0)
        self.rangeSeekSlider.maxLabelFont = Outfit.regularFont(size: 16.0)
        self.rangeSeekSlider.maxValue = Const.maxAmount
        self.rangeSeekSlider.minValue = Const.minAmount
        self.rangeSeekSlider.colorBetweenHandles = .crayola
        self.rangeSeekSlider.handleColor = .crayola
        self.rangeSeekSlider.lineHeight = 3.0
        self.rangeSeekSlider.minLabelColor = .crayola
        self.rangeSeekSlider.maxLabelColor = .crayola
        self.rangeSeekSlider.selectedMinValue = self.filterModel.startAmount
        self.rangeSeekSlider.selectedMaxValue = self.filterModel.endAmount
        self.rangeSeekSlider.delegate = self
    }

    private func configMonthFilterView() {
        var listSelections: [String] = []
        listSelections.append("All")
        for index in 0...6 {
            if let month = Date().getMonth(by: -index)?.monthName() {
                listSelections.append(month)
            }
        }

        var viewModel = FilterSelectionViewModel(listSelections: listSelections)
        viewModel.selectedSelection = self.filterModel.month
        self.monthFilterView.bind(viewModel: viewModel)
        self.monthFilterView.numberOfColumns = 3
        self.monthFilterView.isImageVisible = false
        self.monthFilterView.delegate = self
    }

    private func configServiceFilterView() {
        var listSelections: [String] = ["All", "Transfer", "Top Up", "Withdraw", "Receiver"]
        listSelections += ServiceType.allCases.map {$0.name()}

        var viewModel = FilterSelectionViewModel(listSelections: listSelections)
        viewModel.selectedSelection = self.filterModel.service
        self.serviceFilterView.bind(viewModel: viewModel)
        self.serviceFilterView.numberOfColumns = 4
        self.serviceFilterView.isImageVisible = true
        self.serviceFilterView.delegate = self
    }

    private func configStatusFilterView() {
        var listSelections: [String] = ["All"]
        listSelections += PaymentStatus.allCases.map {$0.name()}

        var viewModel = FilterSelectionViewModel(listSelections: listSelections)
        viewModel.selectedSelection = self.filterModel.status
        self.statusFilterView.bind(viewModel: viewModel)
        self.statusFilterView.numberOfColumns = 2
        self.statusFilterView.isImageVisible = false
        self.statusFilterView.delegate = self
    }

    // MARK: - Actions
    @IBAction func didTapCancelButton(_ sender: Any) {
        self.listener?.didTapCancel()
    }

    @IBAction func didTapClearButton(_ sender: Any) {
        self.monthFilterView.clear()
        self.serviceFilterView.clear()
        self.statusFilterView.clear()
        self.rangeSeekSlider.selectedMinValue = Const.minAmount
        self.rangeSeekSlider.selectedMaxValue = Const.maxAmount
    }

    @IBAction func didTapFilterButton(_ sender: Any) {
        self.listener?.didTapFilter(filterModel: self.filterModel)
    }
}

// MARK: - FilterSelectionViewDelegate
extension FilterViewController: FilterSelectionViewDelegate {
    func filterSelectionView(_ filterSelectionView: FilterSelectionView, didSelect filterValue: String) {
        if filterSelectionView == self.monthFilterView {
            self.filterModel.month = filterValue
            self.listener?.didUpdateFilterModel(filterModel: self.filterModel)
        } else if filterSelectionView == self.serviceFilterView {
            self.filterModel.service = filterValue
            self.listener?.didUpdateFilterModel(filterModel: self.filterModel)
        } else if filterSelectionView == self.statusFilterView {
            self.filterModel.status = filterValue
            self.listener?.didUpdateFilterModel(filterModel: self.filterModel)
        }
    }
}

// MARK: - RangeSeekSliderDelegate
extension FilterViewController: RangeSeekSliderDelegate {
    func rangeSeekSlider(_ slider: RangeSeekSlider, stringForMaxValue: CGFloat) -> String? {
        self.filterModel.endAmount = Double(Int(stringForMaxValue))
        self.listener?.didUpdateFilterModel(filterModel: self.filterModel)
        return "$\(Int(stringForMaxValue))"
    }

    func rangeSeekSlider(_ slider: RangeSeekSlider, stringForMinValue minValue: CGFloat) -> String? {
        self.filterModel.startAmount = Double(Int(minValue))
        self.listener?.didUpdateFilterModel(filterModel: self.filterModel)
        return "$\(Int(minValue))"
    }
}
