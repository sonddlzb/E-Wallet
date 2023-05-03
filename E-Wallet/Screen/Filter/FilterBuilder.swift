//
//  FilterBuilder.swift
//  E-Wallet
//
//  Created by đào sơn on 28/04/2023.
//

import RIBs

protocol FilterDependency: Dependency {

}

final class FilterComponent: Component<FilterDependency> {
}

// MARK: - Builder

protocol FilterBuildable: Buildable {
    func build(withListener listener: FilterListener, filterModel: FilterModel?) -> FilterRouting
}

final class FilterBuilder: Builder<FilterDependency>, FilterBuildable {

    override init(dependency: FilterDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: FilterListener, filterModel: FilterModel?) -> FilterRouting {
        let component = FilterComponent(dependency: dependency)
        let viewController = FilterViewController(filterModel: filterModel)
        let interactor = FilterInteractor(presenter: viewController)
        interactor.listener = listener
        return FilterRouter(interactor: interactor, viewController: viewController)
    }
}
