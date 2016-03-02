Pod::Spec.new do |s|
   s.name = 'JSQMessagesViewController-Swift'
   s.version = '1.0'
   s.license = 'MIT'

   s.summary = 'A fancy Obj-C wrapper for Cocoa System Sound Services'
   s.homepage = 'https://github.com/s-faychatelard/JSQMessagesViewController-Swift'
   s.documentation_url = 'http://jessesquires.com/JSQMessagesViewController'

   s.social_media_url = 'https://twitter.com/proto0moi'
   s.author = { 'Sylvain Fay-Châtelard' => 'sylvain.faychatelard@gmail.com' }

   s.source = { :git => 'https://github.com/s-faychatelard/JSQMessagesViewController-Swift.git', :tag => s.version }
   s.source_files = 'JSQMessagesViewController/JSQMessagesViewController/**/*.{h,m,swift}'
   s.resources = 'JSQMessagesViewController/JSQMessagesViewController/**/*.xib'

   s.resource_bundles = {
     'JSQMessagesAssets' => [
       'JSQMessagesViewController/JSQMessagesViewController/Assets/**/*'
     ]
   }

   s.dependency 'JSQSystemSoundPlayer-Swift', '1.0'

   s.requires_arc = true
end
