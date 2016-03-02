//
//  DemoModelData.swift
//  JSQMessagesViewControllerTest
//
//  Created by Sylvain FAY-CHATELARD on 21/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import Foundation
import MapKit
import JSQMessagesViewController_Swift

let kJSQDemoAvatarDisplayNameSquires = "Jesse Squires"
let kJSQDemoAvatarDisplayNameCook = "Tim Cook"
let kJSQDemoAvatarDisplayNameJobs = "Jobs"
let kJSQDemoAvatarDisplayNameWoz = "Steve Wozniak"

let kJSQDemoAvatarIdSquires = "053496-4509-289"
let kJSQDemoAvatarIdCook = "468-768355-23123"
let kJSQDemoAvatarIdJobs = "707-8956784-57"
let kJSQDemoAvatarIdWoz = "309-41802-93823"

class DemoModelData {
    
    var messages: [JSQMessage] = []
    var avatars: [String: JSQMessagesAvatarImage] = [:]
    var users: [String: String] = [:]
    
    var outgoingBubbleImageData: JSQMessagesBubbleImage
    var incomingBubbleImageData: JSQMessagesBubbleImage
    
    init() {
        
        let jsqImage = JSQMessagesAvatarImageFactory.avatarImage(userInitials: "JSQ", backgroundColor: UIColor(white: 0.85, alpha: 1), textColor: UIColor(white: 0.6, alpha: 1), font: UIFont.systemFontOfSize(14), diameter: kJSQMessagesCollectionViewAvatarSizeDefault)
        
        let cookImage = JSQMessagesAvatarImageFactory.avatarImage(image: UIImage(named: "demo_avatar_cook")!, diameter: kJSQMessagesCollectionViewAvatarSizeDefault)
        
        let jobsImage = JSQMessagesAvatarImageFactory.avatarImage(image: UIImage(named: "demo_avatar_jobs")!, diameter: kJSQMessagesCollectionViewAvatarSizeDefault)
        
        let wozImage = JSQMessagesAvatarImageFactory.avatarImage(image: UIImage(named: "demo_avatar_woz")!, diameter: kJSQMessagesCollectionViewAvatarSizeDefault)
        
        self.avatars = [
            kJSQDemoAvatarIdSquires : jsqImage,
            kJSQDemoAvatarIdCook : cookImage,
            kJSQDemoAvatarIdJobs : jobsImage,
            kJSQDemoAvatarIdWoz : wozImage
        ]
        
        self.users = [
            kJSQDemoAvatarIdJobs : kJSQDemoAvatarDisplayNameJobs,
            kJSQDemoAvatarIdCook : kJSQDemoAvatarDisplayNameCook,
            kJSQDemoAvatarIdWoz : kJSQDemoAvatarDisplayNameWoz,
            kJSQDemoAvatarIdSquires : kJSQDemoAvatarDisplayNameSquires
        ]
        
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        
        self.outgoingBubbleImageData = bubbleFactory.outgoingMessagesBubbleImage(color: UIColor.jsq_messageBubbleLightGrayColor())
        self.incomingBubbleImageData = bubbleFactory.incomingMessagesBubbleImage(color: UIColor.jsq_messageBubbleGreenColor())
        
        if NSUserDefaults.emptyMessagesSetting() {
            
            self.messages = []
        }
        else {
            
            self.loadFakeMessages()
        }
    }
    
    func loadFakeMessages() {
        
        self.messages = [
            JSQMessage(senderId: kJSQDemoAvatarIdSquires, senderDisplayName: kJSQDemoAvatarDisplayNameSquires, date: NSDate.distantPast(), text: "Welcome to JSQMessages: A messaging UI framework for iOS."),
            JSQMessage(senderId: kJSQDemoAvatarIdWoz, senderDisplayName: kJSQDemoAvatarDisplayNameWoz, date: NSDate.distantPast(), text: "It is simple, elegant, and easy to use. There are super sweet default settings, but you can customize like crazy."),
            JSQMessage(senderId: kJSQDemoAvatarIdSquires, senderDisplayName: kJSQDemoAvatarDisplayNameSquires, date: NSDate.distantPast(), text: "It even has data detectors. You can call me tonight. My cell number is 123-456-7890. My website is www.hexedbits.com."),
            JSQMessage(senderId: kJSQDemoAvatarIdJobs, senderDisplayName: kJSQDemoAvatarDisplayNameJobs, date: NSDate.distantPast(), text: "JSQMessagesViewController is nearly an exact replica of the iOS Messages App. And perhaps, better."),
            JSQMessage(senderId: kJSQDemoAvatarIdCook, senderDisplayName: kJSQDemoAvatarDisplayNameCook, date: NSDate.distantPast(), text: "It is unit-tested, free, open-source, and documented."),
            JSQMessage(senderId: kJSQDemoAvatarIdSquires, senderDisplayName: kJSQDemoAvatarDisplayNameSquires, date: NSDate.distantPast(), text: "Now with media messages!")
        ]
        
        self.addPhotoMediaMessage()
        
        if NSUserDefaults.extraMessagesSetting() {
            
            for var i=0; i<4; i++ {
                
                self.messages.appendContentsOf(self.messages.map { $0.copy() as! JSQMessage } )
            }
        }
        
        if NSUserDefaults.longMessageSetting() {
            let reallyLongMessage = JSQMessage.message(senderId: kJSQDemoAvatarIdSquires, senderDisplayName: kJSQDemoAvatarDisplayNameSquires, text: "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur? END Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur? END")
            
            self.messages.append(reallyLongMessage)
        }
    }
    
    func addPhotoMediaMessage() {
        
        let photoItem = JSQPhotoMediaItem(image: UIImage(named: "goldengate"))
        let photoMessage = JSQMessage.message(senderId: kJSQDemoAvatarIdSquires, senderDisplayName: kJSQDemoAvatarDisplayNameSquires, media: photoItem)
        
        self.messages.append(photoMessage)
    }
    
    func addLocationMediaMessageCompletion(completion: JSQLocationMediaItemCompletionBlock?) {
        
        let ferryBuildingInSF = CLLocation(latitude: 37.795313,longitude:-122.393757)
        
        let locationItem = JSQLocationMediaItem()
        locationItem.set(ferryBuildingInSF, completion: completion)
        
        let locationMessage = JSQMessage.message(senderId: kJSQDemoAvatarIdSquires, senderDisplayName: kJSQDemoAvatarDisplayNameSquires, media: locationItem)
        
        self.messages.append(locationMessage)
    }
    
    func addVideoMediaMessage() {
        
        let videoURL = NSURL(string: "file://")!
        
        let videoItem = JSQVideoMediaItem(fileURL: videoURL, isReadyToPlay: true)
        let videoMessage = JSQMessage.message(senderId: kJSQDemoAvatarIdSquires, senderDisplayName: kJSQDemoAvatarDisplayNameSquires, media: videoItem)
        
        self.messages.append(videoMessage)
    }
}