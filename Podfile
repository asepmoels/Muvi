# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

workspace 'MovieDB'

def core_dependency
  pod 'RxSwift'
  pod 'RxRelay'
  pod 'RxCocoa', '6.1.0'
end

target 'MovieDB' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  core_dependency
  pod 'SwiftLint'
  pod 'Swinject'
  pod 'Reusable'
  pod 'SVProgressHUD'
  pod 'SnapKit'
  pod 'SDWebImage'
  pod 'youtube-ios-player-helper'
  pod 'EmptyDataSet-Swift'
  pod 'ObjectMapper+Realm'
  pod 'RealmSwift', '10.7.6'
  pod 'Alamofire'
  pod 'ObjectMapper'
  pod 'Core', :source => "https://code.nbs.co.id/nbsengineering/specs.git"

  # Pods for MovieDB

  target 'MovieDBTests' do
    inherit! :search_paths
    pod 'RxBlocking'
  end

  target 'MovieDBUITests' do
    # Pods for testing
  end

  target 'Movies' do
    use_modular_headers!
    project 'Modules/Movies/Movies'
  end
end

target 'Core' do
  project 'Modules/Core/Core'
  core_dependency
end

target 'Common' do
  project 'Modules/Common/Common'
end

post_install do |pi|
  pi.pods_project.targets.each do |t|
    t.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end
  end
end
