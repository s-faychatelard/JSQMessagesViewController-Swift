//
//  JSQMessageMediaData.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 19/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import Foundation

@objc protocol JSQMessageMediaData: NSObjectProtocol {
    
    var mediaView: UIView? { get }
    var mediaViewDisplaySize: CGSize { get }
    var mediaPlaceholderView: UIView { get }
    var mediaHash: Int { get }
}