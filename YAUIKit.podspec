Pod::Spec.new do |s|

  s.name         = 'YAUIKit'
  s.version      = '2.1.0'
  s.summary      = 'YAUIKit'
  s.homepage     = 'https://github.com/candyan/YAUIKit'
  s.license      = 'MIT'
  s.author       = { 'Candyan' => 'liuyanhp@gmail.com' }
  s.platform     = :ios, '6.0'
  s.requires_arc = true

  s.source       = {
      :git => 'https://github.com/candyan/YAUIKit.git',
      :tag => s.version.to_s
  }

  s.source_files = 'Source/**/*.{c,h,m}'

end
