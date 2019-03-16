Pod::Spec.new do |s|
  s.name = 'KNPaypp'
  s.version = '0.1.0'

  s.osx.deployment_target = '10.9'
  s.ios.deployment_target = '7.0'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'

  s.license = 'MIT'
  s.summary = ''
  s.homepage = 'https://github.com/KNPaypp/KNPaypp'
  s.author = { '不知是哪个号' => '625574612@qq.com' }
  s.source = { :git => 'https://github.com/KNPaypp/KNPaypp.git', :tag => s.version.to_s }

  s.description = ''

  s.requires_arc = true
  s.framework = 'ImageIO'
  
  s.default_subspec = 'KNPaypp'

  s.subspec 'KNPaypp' do |core|
    core.source_files = 'KNPaypp/*.{h,m}'
    core.framework = 'UIKit'
  end
end