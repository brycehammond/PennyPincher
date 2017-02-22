Pod::Spec.new do |s|

  s.name         = "PennyPincher"
  s.version      = "1.1.1"
  s.summary      = "A fast gesture recognizer based on the PennyPincher algorithm."

  s.homepage     = "https://github.com/brycehammond/PennyPincher"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = "fe9lix"
  s.platform     = :ios
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/brycehammond/PennyPincher.gi", :tag => "#{s.version}" }
  s.source_files  = "PennyPincher"

end
