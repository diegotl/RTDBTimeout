Pod::Spec.new do |s|
  s.name             = 'RTDBTimeout'
  s.version          = '0.0.1'
  s.summary          = 'A Firebase Realtime Database iOS extension providing timeout support and simultaneous connections saving.'

  s.homepage         = 'https://github.com/diegotl/rtdb-timeout'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "Diego Trevisan Lara" => 'diego@trevisa.nl' }
  s.source           = { :git => 'https://github.com/diegotl/rtdb-timeout.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/diegotrevisan90'

  s.ios.deployment_target = '9.0'

  s.source_files = 'RTDBTimeout/**/*.{h,swift}'

  s.static_framework = true
  s.dependency 'Firebase/Core'
  s.dependency 'Firebase/Database'

end
