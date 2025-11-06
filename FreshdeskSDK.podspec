
Pod::Spec.new do |s|

  s.name         		 = "FreshdeskSDK"
  s.version      		 = "0.1.0"
  s.summary      		 = "Freshdesk iOS SDK - Modern messaging software that your sales and customer engagement teams will love."
  s.description  		 = <<-DESC
                   			Modern messaging software that your sales and customer engagement teams will love.
                   			DESC
  s.homepage     		 = "https://www.freshdesk.com"
  s.license 	 		 = { :type => 'Commercial', :file => 'FreshdeskSDK/LICENSE', :text => 'See https://www.freshworks.com/terms' }
  s.author       		 = { "Freshdesk" => "support@freshdesk.com" }
  s.social_media_url     = "https://twitter.com/freshdesk"
  s.platform     		 = :ios, "14.0"
  s.source       		 = { :git => "https://github.com/freshworks/freshdesk-ios-sdk.git", :tag => "v#{s.version}" }
  s.frameworks 			 = "Foundation", "SystemConfiguration", "Security", "WebKit" 
  s.requires_arc 		 = true
  s.preserve_paths      = "FreshdeskSDK.xcframework"
  s.vendored_frameworks = "FreshdeskSDK.xcframework"

end
