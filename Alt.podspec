Pod::Spec.new do |s|
  s.name             = "Alt"
  s.version          = "0.1.0"
  s.summary          = "Another Flux implementation for Swift."

  s.homepage         = "https://github.com/<GITHUB_USERNAME>/Alt"
  s.license          = 'MIT'
  s.author           = { "Francis Chong" => "francis@ignition.hk" }
  s.source           = { :git => "https://github.com/siuying/Alt.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/siuying'

  s.osx.deployment_target = "10.9"
  s.ios.deployment_target = "8.0"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"

  s.requires_arc = true
  s.source_files = 'Pod/Classes/**/*.swift'
end
