Pod::Spec.new do |s|
  s.name                = "faac-prebuild@EchoLiao"
  s.version             = "1.28.1"
  s.summary             = "FAAC static libraries compiled for iOS"
  s.homepage            = "http://www.audiocoding.com/faac.html"
  s.author              = { "Echo Liao" => "echoliao8@gmail.com" }
  s.requires_arc        = false
  s.platform            = :ios
  s.source              = { :http => "https://github.com/EchoLiao/faac-prebuild/raw/master/faac-iOS-1.28.1.tgz" }
  s.preserve_paths      = "include/**/*.h"
  s.vendored_libraries  = 'lib/*.a'
  s.libraries           = 'faac'
  s.xcconfig            = { 'HEADER_SEARCH_PATHS' => "\"${PODS_ROOT}/#{s.name}/include\"" }
end
