Pod::Spec.new do |s|
  s.name          = "NativeUI"
  s.version       = "0.0.1"
  s.summary       = "Library that includes customizable replacements for native UIKit components"

  s.description   = <<-DESC
                      For main focus of this library is to allow user to use native-style UI components 
                      with ability to customize them without using private Apple API.
                      Library contains components which looks like native ones, 
                      but customizable and were implemented from scratch.
                      DESC

  s.homepage      = "https://github.com/AntonPoltoratskyi/NativeUI"

  # spec.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  s.license       = { :type => "MIT", :file => "LICENSE" }
  s.author        = "Anton Poltoratskyi"
  s.platform      = :ios, "9.0"

  s.source        = { :git => "https://github.com/AntonPoltoratskyi/NativeUI.git", :tag => "#{s.version}" }
  s.source_files  = "NativeUI/Sources/**/*.{swift}"

  s.frameworks    = "Foundation", "UIKit"
  s.requires_arc  = true

  s.swift_version = "5.0"
  
end
