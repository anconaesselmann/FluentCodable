Pod::Spec.new do |s|
  s.swift_version    = '5.0'
  s.name             = 'FluentCodable'
  s.version          = '1.0.0'
  s.summary          = 'A fluent interface for Codable'
  s.description      = <<-DESC
A fluent interface for Codable.
                       DESC
  s.homepage         = 'https://github.com/anconaesselmann/FluentCodable'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'anconaesselmann' => 'axel@anconaesselmann.com' }
  s.source           = { :git => 'https://github.com/anconaesselmann/FluentCodable.git', :tag => s.version.to_s }
  s.ios.deployment_target = '10.0'
  s.source_files = 'FluentCodable/Classes/**/*'
end
