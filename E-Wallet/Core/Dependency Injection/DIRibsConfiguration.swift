//
//  DIRibsConfiguration.swift
//  E-Wallet
//
//  Created by đào sơn on 30/03/2023.
//

import Foundation

extension DIConnector {
    static func registerAllRibs() {
        DIContainer.register(RootBuildable.self) { _, args in
            return RootBuilder(dependency: args.get())
        }

        DIContainer.register(SignInBuildable.self) { _, args in
            return SignInBuilder(dependency: args.get())
        }

        DIContainer.register(SplashBuildable.self) { _, args in
            return SplashBuilder(dependency: args.get())
        }

        DIContainer.register(VerifyCodeBuildable.self) { _, args in
            return VerifyCodeBuilder(dependency: args.get())
        }

        DIContainer.register(EnterPasswordBuildable.self) { _, args in
            return EnterPasswordBuilder(dependency: args.get())
        }

        DIContainer.register(FillProfileBuildable.self) { _, args in
            return FillProfileBuilder(dependency: args.get())
        }

        DIContainer.register(HomeBuildable.self) { _, args in
            return HomeBuilder(dependency: args.get())
        }

        DIContainer.register(DashboardBuildable.self) { _, args in
            return DashboardBuilder(dependency: args.get())
        }

        DIContainer.register(IntroductionBuildable.self) { _, args in
            return IntroductionBuilder(dependency: args.get())
        }
    }
}
