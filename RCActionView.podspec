#
# Be sure to run `pod lib lint RCActionView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RCActionView'
  s.version          = '1.0.0'
  s.summary          = 'RCActionView  is as a customizable bottom menu.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/flipacholas/RCActionView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Rodrigo' => 'busntour@gmail.com' }
  s.source           = { :git => 'https://github.com/flipacholas/RCActionView.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/flipacholas'

  s.ios.deployment_target = '8.0'

  s.source_files = 'RCActionView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'RCActionView' => ['RCActionView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
