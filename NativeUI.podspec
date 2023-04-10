Pod::Spec.new do |s|
  s.name          = "NativeUI"
  s.version       = "1.2.2"
  s.summary       = "Library that includes customizable replacements for native UIKit components"

  s.description   = <<-DESC
                      For main focus of this library is to allow user to use native-style UI components 
                      with ability to customize them without using private Apple API.
                      Library contains components which looks like native ones, 
                      but customizable and were implemented from scratch.
                      DESC

  s.homepage      = "https://github.com/devpolant/NativeUI"
  s.license       = { :type => "MIT", :file => "LICENSE" }
  s.author        = "Anton Poltoratskyi"

  s.platform      = :ios, "11.0"
  
  s.swift_version = "5.0"

  s.source        = { :git => "https://github.com/devpolant/NativeUI.git", :tag => "#{s.version}" }
  
  s.frameworks    = "Foundation", "UIKit"

  s.requires_arc  = true

  s.default_subspec   = 'Core'

  s.subspec 'Core' do |ss|
    ss.dependency 'NativeUI/Alert'
  end

  s.subspec 'Utils' do |ss|
    ss.source_files    = "NativeUI/Sources/Utils/**/*.{swift}"
  end
  
  s.subspec 'Alert' do |ss|
    ss.source_files    = "NativeUI/Sources/Alert/**/*.{swift}"
    ss.dependency 'NativeUI/Utils'
  end

end
