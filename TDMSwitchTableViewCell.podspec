Pod::Spec.new do |s|
  s.name         = "TDMSwitchTableViewCell"
  s.version      = "0.0.1"
  s.summary      = "TDMSwitchTableViewCell."
  s.description  = <<-DESC
                   TDMSwitchTableViewCell.
                   DESC
  s.homepage     = "https://github.com/duemunk/TDMSwitchTableViewCell"
  s.screenshots  = ""
  s.license      = 'GPLv3'
  s.author       = { "Tobias Due Munk" => "tobias@developmunk.dk" }
  s.source       = { :git => "https://github.com/duemunk/TDMSwitchTableViewCell.git", :tag => s.version.to_s }

  s.platform     = :ios, "7.0"
  s.ios.deployment_target = '7.0'
  s.requires_arc = true
 
  s.resources = 'Assets'

	s.public_header_files = 'Classes/*.h'
  s.source_files = 'Classes/*.{h,m}'
	s.preserve_paths = "Classes"
end
