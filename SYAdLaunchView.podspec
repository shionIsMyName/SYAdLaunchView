Pod::Spec.new do |s|
  s.name             = "SYAdLaunchView"
  s.version          = "1.0.0"
  s.summary          = "A obj-c library which getting ads from server and running like a launchImage/obj-c用,网络广告启动图框架,还可实现版本新特性功能"
  s.description      = <<-DESC
                       A obj-c library which can easily help you to achieve a AdLaunchImageView function and a New-Feature function./ 一个obj-c的框架,可以轻松帮你实现请求网络广告，缓存起来当作启动图来用,且还可以轻松帮您实现版本新特性功能。
 			DESC
  s.homepage         = "https://github.com/shionIsMyName/SYAdLaunchView"
  # s.screenshots      = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "施勇" => "619023485@qq.com/shionIsMyName@gmail.com" }
  s.source           = { :git => "https://github.com/shionIsMyName/SYAdLaunchView.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/NAME'

  s.platform     = :ios, '7.0'
  # s.ios.deployment_target = '5.0'
  # s.osx.deployment_target = '10.7'
  s.requires_arc = true

  s.source_files = 'SYAdLaunchView/*'
  s.source_files = 'SYAdLaunchView/dependencies/*'
  s.source_files = 'SYAdLaunchView/dependencies/PageControl/*'
  # s.resources = 'Assets'

  # s.ios.exclude_files = 'Classes/osx'
  # s.osx.exclude_files = 'Classes/ios'
  # s.public_header_files = 'Classes/**/*.h'
  s.frameworks = 'Foundation', 'CoreGraphics', 'UIKit'

end
