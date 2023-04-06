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

        DIContainer.register(SignUpBuildable.self) { _, args in
            return SignUpBuilder(dependency: args.get())
        }

        DIContainer.register(VerifyCodeBuildable.self) { _, args in
            return VerifyCodeBuilder(dependency: args.get())
        }
    }
}
