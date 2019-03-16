Pod::Spec.new do |s|
  s.name = 'KNPaypp'
  s.version = '0.1.0'

  s.ios.deployment_target = '7.0'
  s.osx.deployment_target = "10.9"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"

  s.license = 'MIT'
  s.summary = 'Wx and alipay'
  s.homepage = 'https://github.com/wushenchao/KNPaypp'
  s.author = { '不知是哪个号' => '625574612@qq.com' }
  s.source = { :git => 'https://github.com/wushenchao/KNPaypp.git', :tag => s.version.to_s }

  s.description = 'Simple wx and alipay'

  s.requires_arc = true
  s.framework = 'UIKit'
  
  s.default_subspec = 'KNPaypp'
  s.subspec 'KNPaypp' do |core|
    core.source_files = 'KNPaypp/*'
    core.framework = 'UIKit'
  end
end