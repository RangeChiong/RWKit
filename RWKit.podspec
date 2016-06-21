Pod::Spec.new do |s|
  s.name             = 'RWKit'
  s.version          = '0.0.1'
  s.summary          = 'Reivent wheels kit.'
  s.homepage         = 'https://github.com/RangeChiong/RWKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '蒙牛D罩杯撸废' => 'rangeChiong@outlook.com' }
  s.source           = { :git => 'https://github.com/RangeChiong/RWKit.git', :tag => s.version }
  s.ios.deployment_target = '8.0'
  s.source_files = 'RWKit/Classes/**/*'
  s.frameworks = 'UIKit', 'Foundation'
end
