Pod::Spec.new do |s|
    s.name             = 'DoricWebView'
    s.version          = '0.1.1'
    s.summary          = 'Doric extension library for webview'
  
    s.description      = <<-DESC
    Doric webview plugin to load web content.
                            DESC

    s.homepage         = 'https://github.com/doric-pub/DoricWebView/'
    s.license          = { :type => 'Apache-2.0', :file => 'LICENSE' }
    s.author           = { 'pengfei.zhou' => 'pengfeizhou@foxmail.com' }
    s.source           = { :git => 'https://github.com/doric-pub/DoricWebView.git', :tag => s.version.to_s }
  
    s.ios.deployment_target = '9.0'
  
    s.source_files = 'iOS/Classes/**/*'
    s.resource     =  "dist/**/*"
    s.public_header_files = 'iOS/Classes/**/*.h'
    s.dependency 'DoricCore'
end
