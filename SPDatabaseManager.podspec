Pod::Spec.new do |spec|

  spec.name                = "SPDatabaseManager"
  spec.version             = "1.0.0"
  spec.summary             = "FMDB 数据库操作"
  spec.homepage            = "https://mouos.com"
  spec.license             = "MIT"
  spec.author              = { "高文立" => "swiftprimer@gmail.com" }
  spec.platform            = :ios, "10.0"
  spec.source              = { :git => "https://github.com/mouos/SPDatabaseManager.git", :tag => "#{spec.version}" }
  spec.source_files        = "Classes", "Classes/**/*.{h,m}"
  spec.exclude_files       = "Classes/Exclude"
  spec.public_header_files = "Classes/**/*.h"

end
