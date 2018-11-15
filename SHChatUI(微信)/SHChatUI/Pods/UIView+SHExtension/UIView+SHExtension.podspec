Pod::Spec.new do |s|
    s.name         = "UIView+SHExtension"
    s.version      = "0.0.1"
    s.summary      = "A short description of UIView+SHExtension."
    s.homepage     = 'https://github.com/CCSH/UIView+SHExtension'
    s.license      = 'MIT'
    s.authors      = {'CSH' => '624089195@qq.com'}
    s.platform     = :ios, '6.0'
    s.source       = {:git => 'https://github.com/CCSH/UIView+SHExtension.git', :tag => s.version}
    s.source_files = 'UIView+SHExtension/*.{h,m}'
    s.requires_arc = true

end
