require 'json'

package = JSON.parse(File.read(File.join(__dir__, '../package.json')))

Pod::Spec.new do |s|
  s.name                = "RNXRPC"
  s.version             = package['version']
  s.summary             = package['description']
  s.description         = <<-DESC
                            RNXRPC enables pub/sub and rpc between natives and js for react-native.
                         DESC
  s.homepage            = "https://github.com/webee/react-native-xrpc-ios"
  s.license             = package['license']
  s.author              = "webee.yw <webee.yw@gmail.com>"
  s.source              = { :git => "https://github.com/webee/react-native-xrpc-ios", :tag => s.version }
  s.default_subspec     = 'XRPC'
  s.requires_arc        = true
  s.platform            = :ios, "8.0"

  s.subspec 'XRPC' do |ss|
    ss.dependency 'React/Core'
    ss.source_files        = "ReactNativeXRPC/**/*.{h,m,swift}"
    ss.pod_target_xcconfig = { "CLANG_CXX_LANGUAGE_STANDARD" => "c++14" }
  end

  s.subspec 'Helper' do |ss|
    ss.dependency 'RNXRPC/XRPC'
    ss.dependency 'PromiseKit', '~> 4.0'
    ss.source_files        = "RNHelper/**/*.{h,m,swift}"
    ss.pod_target_xcconfig = { "CLANG_CXX_LANGUAGE_STANDARD" => "c++14" }
  end
end
