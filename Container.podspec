#
# Be sure to run `pod lib lint Container.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = 'Container'
s.version          = '1.0.0'
s.summary          = 'All the things you are tired of writing.'

s.description      = <<-DESC
This framework is designed to make the process of embedding and transitioning between multiple child `UIViewController`s painless and flexible.
DESC

s.homepage          = 'https://github.com/BottleRocketStudios/iOS-Container'
s.license           = { :type => 'Apache 2.0', :file => 'LICENSE' }
s.author            = { 'Bottle Rocket Studios' => 'will.mcginty@bottlerocketstudios.com' }
s.source            = { :git => 'https://github.com/bottlerocketstudios/iOS-Container.git', :tag => s.version.to_s }
s.source_files      = 'Sources/Container/**/*'
s.ios.deployment_target = '10.0'
s.swift_version = '5.0'

end
