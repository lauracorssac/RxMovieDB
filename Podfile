# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'RxMovieDB' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'RxSwift',    '~> 4.0'
  pod 'RxCocoa',    '~> 4.0'
  pod 'Kingfisher', '~> 4.0'

  # Pods for RxMovieDB

end

post_install do |installer|
  swift4Targets = ['RxCocoa', 'RxSwift', 'Kingfisher']
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      swift4Targets.each do |target4|
        if target.name.include? target4
          config.build_settings['SWIFT_VERSION'] = '4.2'
        end
      end
    end
  end
end
