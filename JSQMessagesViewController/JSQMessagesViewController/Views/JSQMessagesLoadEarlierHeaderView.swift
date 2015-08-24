//
//  JSQMessagesLoadEarlierHeaderView.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 20/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import UIKit

protocol JSQMessagesLoadEarlierHeaderViewDelegate {
    
    func headerView(headerView: JSQMessagesLoadEarlierHeaderView, didPressLoadButton sender: UIButton?)
}

class JSQMessagesLoadEarlierHeaderView: UICollectionReusableView {
    
    static var kJSQMessagesLoadEarlierHeaderViewHeight: CGFloat = 32
    var delegate: JSQMessagesLoadEarlierHeaderViewDelegate?
    
    @IBOutlet var loadButton: UIButton!
    
    class func nib() -> UINib {
        
        return UINib(nibName: "\(JSQMessagesLoadEarlierHeaderView.self)".jsq_className(), bundle: NSBundle(forClass: JSQMessagesLoadEarlierHeaderView.self))
    }
    
    class func headerReuseIdentifier() -> String {
        
        return "\(JSQMessagesLoadEarlierHeaderView.self)".jsq_className()
    }
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.backgroundColor = UIColor.clearColor()
        
        self.loadButton.setTitle(NSBundle.jsq_localizedStringForKey("load_earlier_messages"), forState: .Normal)
        self.loadButton.titleLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    }
    
    // MARK: - Reusable view
    
    override var backgroundColor: UIColor? {
        
        didSet {
            
            self.loadButton.backgroundColor = backgroundColor
        }
    }
    
    // MARK: - Actions
    
    @IBAction func loadButtonPressed(sender: UIButton) {
        
        self.delegate?.headerView(self, didPressLoadButton: sender)
    }
}

