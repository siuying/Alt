Pod::Spec.new do |s|
  s.name             = "Alt"
  s.version          = "0.1.0"
  s.summary          = "Another Flux implementation for Swift."

  s.homepage         = "https://github.com/<GITHUB_USERNAME>/Alt"
  s.license          = 'MIT'
  s.author           = { "Francis Chong" => "francis@ignition.hk" }
  s.source           = { :git => "https://github.com/siuying/Alt.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/siuying'

  s.platform     = :ios, '8.0'
  s.platform     = :osx, '10.10'
  s.requires_arc = true
  s.source_files = 'Pod/Classes/**/*'
end
