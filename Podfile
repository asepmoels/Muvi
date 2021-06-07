# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'MovieDB' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

pod 'Moya', '~> 14.0'
pod 'SwiftLint'
pod 'Swinject'
pod 'Reusable'
pod 'RxSwift'
pod 'ObjectMapper'
pod 'SVProgressHUD'
pod 'RxRelay'
pod 'SnapKit'
pod 'SDWebImage'

  # Pods for MovieDB

  target 'MovieDBTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'MovieDBUITests' do
    # Pods for testing
  end

end

post_install do |pi|
  pi.pods_project.targets.each do |t|
    t.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end
  end
end
