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

        DIContainer.register(ProfileBuildable.self) { _, args in
            return ProfileBuilder(dependency: args.get())
        }

        DIContainer.register(EditProfileBuildable.self) { _, args in
            return EditProfileBuilder(dependency: args.get())
        }

        DIContainer.register(TransferBuildable.self) { _, args in
            return TransferBuilder(dependency: args.get())
        }

        DIContainer.register(AddCardBuildable.self) { _, args in
            return AddCardBuilder(dependency: args.get())
        }

        DIContainer.register(AccountBuildable.self) { _, args in
            return AccountBuilder(dependency: args.get())
        }

        DIContainer.register(CardDetailsBuildable.self) { _, args in
            return CardDetailsBuilder(dependency: args.get())
        }

        DIContainer.register(TopUpBuildable.self) { _, args in
            return TopUpBuilder(dependency: args.get())
        }

        DIContainer.register(WithdrawBuildable.self) { _, args in
            return WithdrawBuilder(dependency: args.get())
        }
    }
}
