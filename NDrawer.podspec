Pod::Spec.new do |s|
  s.name        = 'NDrawer'
  s.version     = '1.0.1'
  s.summary     = 'Drawer is a framework that enables you to easily embed a UIViewController in a drawer and display it on top of another UIViewController.'
  s.homepage    = 'https://github.com/nodes-ios/Drawer'
  s.author      = { "Nodes Agency - iOS" => "ios@nodes.dk" }
  s.license     = { :type => 'MIT', :file => './LICENSE' }
  s.source      = { :git => 'https://github.com/nodes-ios/Drawer.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'

  s.source_files = 'Sources/Drawer/*'
  
  s.swift_version = '5'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '5' }
end
