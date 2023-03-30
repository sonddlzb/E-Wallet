
 platform :ios, '13.0'

 def RxSwiftPod
   pod 'RxSwift'
   pod 'RxCocoa'
 end

 def RIBsPod
   pod 'RIBs', :git => 'https://github.com/uber/RIBs/', :tag => 'v0.10.0' 
 end


 target 'E-Wallet' do
   use_frameworks!

   pod 'SwiftLint'
   pod 'Firebase'
   pod 'Firebase/Crashlytics'
   pod 'Resolver'
   pod 'SVProgressHUD'
   pod 'Kingfisher'

   RxSwiftPod()
   RIBsPod()
 end