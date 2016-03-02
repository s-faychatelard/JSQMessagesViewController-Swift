//
//  JSQSystemSoundPlayer.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 19/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import JSQSystemSoundPlayer_Swift

let kJSQMessageReceivedSoundName = "message_received"
let kJSQMessageSentSoundName = "message_sent"

extension JSQSystemSoundPlayer {
    
    public class func jsq_playMessageReceivedSound() {
        
        JSQSystemSoundPlayer.jsq_playSoundFromJSQMessagesBundle(name: kJSQMessageReceivedSoundName, asAlert: false)
    }
    
    public class func jsq_playMessageReceivedAlert() {
        
        JSQSystemSoundPlayer.jsq_playSoundFromJSQMessagesBundle(name: kJSQMessageReceivedSoundName, asAlert: true)
    }
    
    public class func jsq_playMessageSentSound() {
        
        JSQSystemSoundPlayer.jsq_playSoundFromJSQMessagesBundle(name: kJSQMessageSentSoundName, asAlert: false)
    }
    
    public class func jsq_playMessageSentAlert() {
        
        JSQSystemSoundPlayer.jsq_playSoundFromJSQMessagesBundle(name: kJSQMessageSentSoundName, asAlert: true)
    }
    
    private class func jsq_playSoundFromJSQMessagesBundle(name name: String, asAlert: Bool) {
        
        // Save sound player original bundle
        let originalPlayerBundleIdentifier = JSQSystemSoundPlayer.sharedPlayer.bundle
        
        if let bundle = NSBundle.jsq_messagesBundle() {
        
            JSQSystemSoundPlayer.sharedPlayer.bundle = bundle
        }

        let filename = "JSQMessagesAssets.bundle/Sounds/\(name)"
        
        if asAlert {
            
            JSQSystemSoundPlayer.sharedPlayer.playAlertSound(filename, fileExtension: JSQSystemSoundPlayer.TypeAIFF, completion: nil)
        }
        else {
            
            JSQSystemSoundPlayer.sharedPlayer.playSound(filename, fileExtension: JSQSystemSoundPlayer.TypeAIFF, completion: nil)
        }
        
        JSQSystemSoundPlayer.sharedPlayer.bundle = originalPlayerBundleIdentifier
    }
}