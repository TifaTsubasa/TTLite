#
#  Be sure to run `pod spec lint TTLite.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "TTLite"
  s.version      = "0.1.4"
  s.summary      = "Easy objective sqlite"
  s.description  = <<-DESC
                  更加面向对象的SQLite，简洁直观的对象存储
                   DESC

  s.homepage     = "https://github.com/TifaTsubasa/TTLite"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "TifaTsubasa" => "15922402179@163.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/TifaTsubasa/TTLite.git", :tag => s.version }

  s.source_files  = "TTLite/**/*.{h,m}"
  # s.libraries = "iconv", "xml2"
  s.dependency 'FMDB', '~> 2.6' 

end
