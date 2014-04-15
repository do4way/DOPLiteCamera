Pod::Spec.new do |s|

  s.name         = "DOPLiteCamera"
  s.version      = "0.0.1"
  s.summary      = "A fullscreen camera for ios, you can use the camera to takephotos and post it to any photo share service" 

  s.description  = <<-DESC
		Camera Feature:
       			* a full screen preview frame
       			* really speedy shutter
       			* auto-focus and auto-explosue at touch point
       			* keep exif data in image file( no geographic data yet)
		Photo Picker
       			* multi photo selection
		Photo Comment
       			* Comment on the selected photos
       			* add or remove photo from selection
                DESC

  s.homepage     = "https://github.com/do4way/DOPLiteCamera.git"
  # s.screenshots  = "www.example.com/screenshots_1", "www.example.com/screenshots_2"

  s.license      = "MIT"
  s.author       = { "Yongwei" => "yongwei.dou@gmail.com" }

  s.platform     = :ios, "6.0"
  s.source       = { :git => "https://github.com/do4way/DOPLiteCamera.git", :tag => "v0.0.1" }

  s.source_files  = "DOPLiteCamera", "DOPListCamera/**/*.{h,m}"
  s.exclude_files = "DOPLiteCamera/{Exclude,Resources}"
  s.resources = "DOPLiteCamera/Resources/*"

  # s.public_header_files = "Classes/**/*.h"

  s.requires_arc = true

  s.prefix_header_file = "DOPLiteCamera/DOPLiteCamera-Prefix.pch"
  s.dependency "UIView\+AutoLayout",  "~> 1.3.0"

end
