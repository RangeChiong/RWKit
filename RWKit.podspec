Pod::Spec.new do |s|
  s.name         = "RWKit"
  s.version      = "0.1.1"
  s.summary      = "Reivent Wheels Kit"
  s.homepage     = "https://github.com/RangeChiong/RWKit"
  s.license      = "MIT"
  s.author       = { "蒙牛D罩杯撸废" => "rangechiong@outlook.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/RangeChiong/RWKit.git", :tag => s.version, :submodules => true }
  s.requires_arc = true
  s.public_header_files = 'RWKit/RWKit.h'
  s.source_files = 'RWKit/RWKit.h'

  s.subspec 'Helper' do |helper|
      helper.source_files = 'RWKit/Helper/**/*.{h,m}'
      helper.public_header_files = 'RWKit/Helper/**/*.h'
      helper.dependency 'AFNetworking', '~> 3.1.0'
  end

  s.subspec 'Category' do |category|
      category.source_files = 'RWKit/Category/**/*.{h,m}'
      category.public_header_files = 'RWKit/Category/**/*.h'
  end

  s.subspec 'Config' do |config|
      config.source_files = 'RWKit/Config/**/*.{h,m}'
      config.public_header_files = 'RWKit/Config/**/*.h'
  end
end
