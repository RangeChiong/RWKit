Pod::Spec.new do |s|
  s.name         = "RWKit"
  s.version      = "0.0.5"
  s.summary      = "Reivent Wheels Kit"
  s.homepage     = "https://github.com/RangeChiong/RWKit"
  s.license      = "MIT"
  s.author             = { "蒙牛D罩杯撸废" => "rangechiong@outlook.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/RangeChiong/RWKit.git", :tag => "v0.0.5", :submodules => true }
  s.requires_arc = true
  s.public_header_files = 'RWKit/RWKit.h'
  s.source_files = 'RWKit/RWKit.h'
  s.dependency "AFNetworking", "~> 3.1.0"

  s.subspec 'Helper' do |helper|
      helper.source_files = 'RWKit/Helper/**/*.{h,m}'
      helper.public_header_files = 'RWKit/Helper/**/*.h'
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
