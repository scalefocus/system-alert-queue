Pod::Spec.new do |s|
  
  s.name             = 'UpnetixSystemAlertQueue'
  s.version          = '2.0.0'
  s.summary          = 'Upnetix System Alert Queue.'
  s.description      = <<-DESC
Simple manager that presents alerts by adding them in queue and chains their presentation. A priority can be set to have further control.
                       DESC

  s.homepage         = 'https://github.com/scalefocus/system-alert-queue'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Scalefocus' => 'code@upnetix.com' }
  s.source           = { :git => 'https://github.com/scalefocus/system-alert-queue.git', :tag => s.version.to_s }

  s.platform     = :ios, "11.0"
  s.swift_version = '5.0'
  s.source_files = 'UpnetixSystemAlertQueue/Classes/**/*'
  
end
