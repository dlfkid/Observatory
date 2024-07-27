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
  s.summary          = 'A swift written distributed tracing and log clinet built conformimg to OpenTelemetry specifications'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'git@github.com:dlfkid/Observatory'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'RavenDeng' => 'dlfkid@icloud.com' }
  s.source           = { :git => 'git@github.com:dlfkid/Observatory.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.2'

  s.default_subspec = 'Full'
  
  s.subspec 'Full' do |full|
    full.dependency 'Observatory/ObservatoryTracing'
    full.dependency 'Observatory/ObservatoryLogging'
  end

  s.subspec 'ObservatoryTracing' do |tracing|
    tracing.dependency 'Observatory/ObservatoryCommon'
    tracing.source_files = 'Sources/Tracing/**/*'
  end

  s.subspec 'ObservatoryLogging' do |logging|
    logging.dependency 'Observatory/ObservatoryCommon'
    logging.source_files = 'Sources/Logging/**/*'
  end

  s.subspec 'ObservatoryCommon' do |common|
    common.source_files = 'Sources/Common/**/*'
  end

  s.subspec 'ObservatoryTracingZipkin' do |zipkin|
    zipkin.dependency 'Observatory/ObservatoryTracing'
    zipkin.source_files = 'Sources/Extensions/Tracing/ZipkinExport'
  end
end
