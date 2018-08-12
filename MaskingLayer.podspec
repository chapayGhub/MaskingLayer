#
# Be sure to run `pod lib lint MaskingLayer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MaskingLayer'
  s.version          = '0.2'
  s.summary          = 'The traced part is masked.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/daisukenagata/MaskingLayer'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'daisukenagata' => 'dbank0208@gmail.com' }
  s.source           = { :git => 'https://github.com/daisukenagata/MaskingLayer.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/dbank0208'

  s.ios.deployment_target = '10.0'
  s.swift_version = '4.1'
  s.source_files = 'MaskingLayer/Classes/**/*'
  
  # s.resource_bundles = {
  #   'MaskingLayer' => ['MaskingLayer/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
