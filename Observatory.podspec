#
# Be sure to run `pod lib lint Observatory.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Observatory'
  s.version          = '0.1.0'
  s.summary          = 'A short description of Observatory.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/RavenDeng/Observatory'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'RavenDeng' => 'dlfkid@icloud.com' }
  s.source           = { :git => 'https://github.com/RavenDeng/Observatory.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.default_subspec = 'Full'
  
  s.subspec 'Full' do |full|
    full.dependency 'Observatory/Tracing'
    full.dependency 'Observatory/Logging'
  end

  s.subspec 'Tracing' do |tracing|
    tracing.dependency 'Observatory/Common'
    tracing.source_files = 'Observatory/Classes/Tracing/**/*'
  end

  s.subspec 'Logging' do |logging|
    logging.dependency 'Observatory/Common'
    logging.source_files = 'Observatory/Classes/Logging/**/*'
  end

  s.subspec 'Common' do |common|
    common.source_files = 'Observatory/Classes/Common/**/*'
  end
end
