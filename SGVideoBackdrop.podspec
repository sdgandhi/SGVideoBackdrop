#
# Be sure to run `pod lib lint SGVideoBackdrop.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SGVideoBackdrop"
  s.version          = "0.1.0"
  s.summary          = "A video backdrop for your view controller + UIVisualEffectView"
  s.description      = <<-DESC
                       Set any local or remote video (that AVPlayer accepts) as a blurred out backdrop to your view controller.
                       DESC
  s.homepage         = "https://github.com/sdgandhi/SGVideoBackdrop"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Sidhant Gandhi" => "sidhant.gandhi@gmail.com" }
  s.source           = { :git => "https://github.com/sdgandhi/SGVideoBackdrop.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/sidhantgandhi'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'SGVideoBackdrop' => ['Pod/Assets/*.*']
  }

  s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'AVFoundation'
  s.dependency 'SDWebImage', '~> 3.0'
end
