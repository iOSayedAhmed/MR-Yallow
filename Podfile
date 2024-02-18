
# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'

target 'NewBazar' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  source 'https://github.com/CocoaPods/Specs.git'
  source 'https://github.com/ihak/iHAKPodSpecs.git'

  # Pods for Bazar
  pod "Alamofire"
  pod 'NVActivityIndicatorView/Extended'
  pod 'Siren'
  pod 'MOLH'
  pod 'TransitionButton'
  pod 'SDWebImage', '~> 5.0'
  pod 'PhoneNumberKit'
  pod 'MediaSlideshow'
  #  pod "ImageSlideshow/Alamofire"
  pod "MediaSlideshow/Alamofire"
  pod 'DLRadioButton'
  pod 'OTPFieldView'
  pod 'Cosmos'
  pod "NotificationBannerSwift"
  pod "PMAlertController"
  pod "RAMAnimatedTabBarController"
  pod "MediaSlideshow/AV"
  pod 'DropDown'
  pod 'GooglePlaces'
#  pod 'GooglePlacePicker'
  pod 'GoogleMaps'
  pod 'LSDialogViewController'
  pod 'Zoomy'
  pod 'iRecordView'
  pod 'M13Checkbox'
  pod 'Firebase/Messaging'
  pod 'Firebase/DynamicLinks'
  pod 'Firebase/Auth'
#  pod 'Firebase/Core'
  pod "TTGSnackbar"
  pod 'IQKeyboardManagerSwift'
#  pod 'lottie-ios'
  pod 'Kingfisher'
#  pod 'NextGrowingTextView', '1.6.1'
  pod 'WoofTabBarController'
  pod 'FSPagerView'
  pod 'CircleMenu'
  pod 'MyFatoorah'


end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13'
    end
  end
end
