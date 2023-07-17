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

        DIContainer.register(TransactionConfirmBuildable.self) { _, args in
            return TransactionConfirmBuilder(dependency: args.get())
        }

        DIContainer.register(SelectCardBuildable.self) { _, args in
            return SelectCardBuilder(dependency: args.get())
        }

        DIContainer.register(ReceiptBuildable.self) { _, args in
            return ReceiptBuilder(dependency: args.get())
        }

        DIContainer.register(HistoryBuildable.self) { _, args in
            return HistoryBuilder(dependency: args.get())
        }

        DIContainer.register(TransactionDetailsBuildable.self) { _, args in
            return TransactionDetailsBuilder(dependency: args.get())
        }

        DIContainer.register(FilterBuildable.self) { _, args in
            return FilterBuilder(dependency: args.get())
        }

        DIContainer.register(GiftBuildable.self) { _, args in
            return GiftBuilder(dependency: args.get())
        }

        DIContainer.register(VoucherDetailsBuildable.self) { _, args in
            return VoucherDetailsBuilder(dependency: args.get())
        }

        DIContainer.register(EnterBillBuildable.self) { _, args in
            return EnterBillBuilder(dependency: args.get())
        }

        DIContainer.register(BillDetailsBuildable.self) { _, args in
            return BillDetailsBuilder(dependency: args.get())
        }

        DIContainer.register(GiftApplyBuildable.self) { _, args in
            return GiftApplyBuilder(dependency: args.get())
        }

        DIContainer.register(ScannerBuildable.self) { _, args in
            return ScannerBuilder(dependency: args.get())
        }

        DIContainer.register(QRBuildable.self) { _, args in
            return QRBuilder(dependency: args.get())
        }

        DIContainer.register(MyQRBuildable.self) { _, args in
            return MyQRBuilder(dependency: args.get())
        }

        DIContainer.register(ExpenseBuildable.self) { _, args in
            return ExpenseBuilder(dependency: args.get())
        }

        DIContainer.register(ExpenseDetailsBuildable.self) { _, args in
            return ExpenseDetailsBuilder(dependency: args.get())
        }

        DIContainer.register(NotificationsBuildable.self) { _, args in
            return NotificationsBuilder(dependency: args.get())
        }

        DIContainer.register(ChatBuildable.self) { _, args in
            return ChatBuilder(dependency: args.get())
        }

        DIContainer.register(ChatDetailsBuildable.self) { _, args in
            return ChatDetailsBuilder(dependency: args.get())
        }

        DIContainer.register(PhotoPreviewBuildable.self) { _, args in
            return PhotoPreviewBuilder(dependency: args.get())
        }

        DIContainer.register(AudioPreviewBuildable.self) { _, args in
            return AudioPreviewBuilder(dependency: args.get())
        }

        DIContainer.register(FeedbackBuildable.self) { _, args in
            return FeedbackBuilder(dependency: args.get())
        }
    }
}
