Pod::Spec.new do |s|
  s.name             = 'ResolverContainer'
  s.version          = '1.3.3'
  s.summary          = 'Resolver container implemented on Swift'
  s.homepage         = 'https://github.com/kzlekk/Resolver'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Natan Zalkin' => 'natan.zalkin@me.com' }
  s.source           = { :git => 'https://kzlekk@github.com/kzlekk/ResolverContainer.git', :tag => "#{s.version}" }
  s.module_name      = 'ResolverContainer'
  s.swift_version    = '5.0'

  s.ios.deployment_target = '10.0'
  s.osx.deployment_target = '10.12'
  s.watchos.deployment_target = '3.0'
  s.tvos.deployment_target = '10.0'

  s.source_files = 'Resolver/*.swift'

end
