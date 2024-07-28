#
# Be sure to run `pod lib lint Observatory.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ObservatoryPod'
  s.version          = '0.1.1'
  s.summary          = 'A swift written distributed tracing and log clinet built conformimg to OpenTelemetry specifications'
  s.swift_versions = '5.0'
# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
In short, To help application developer to improve the observability of their apps. By offering distributed tacing data to the backend colletor, developer can see through the connection between logs and understand the hole process they defined rather than searching in tons of god knows wether they are relative logs and die trying to organize the whole situation.
                       DESC

  s.homepage         = 'https://github.com/dlfkid/Observatory'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'RavenDeng' => 'dlfkid@icloud.com' }
  s.source           = { :git => 'https://github.com/dlfkid/Observatory.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.2'

  s.default_subspec = 'Full'
  
  s.subspec 'Full' do |full|
    full.dependency 'ObservatoryPod/Tracing'
    full.dependency 'ObservatoryPod/Logging'
  end

  s.subspec 'Tracing' do |tracing|
    tracing.dependency 'ObservatoryPod/Common'
    tracing.source_files = 'Sources/Tracing/**/*'
  end

  s.subspec 'Logging' do |logging|
    logging.dependency 'ObservatoryPod/Common'
    logging.source_files = 'Sources/Logging/**/*'
  end

  s.subspec 'Common' do |common|
    common.source_files = 'Sources/Common/**/*'
  end

  s.subspec 'TracingZipkin' do |zipkin|
    zipkin.dependency 'ObservatoryPod/Tracing'
    zipkin.source_files = 'Sources/Extensions/Tracing/ZipkinExport'
  end
end
