//
//  TableViewController.swift
//  JSQMessagesViewControllerTest
//
//  Created by Sylvain FAY-CHATELARD on 21/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import Foundation

class TableViewController: UITableViewController, JSQDemoViewControllerDelegate {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "JSQMessagesViewController"
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if let indexPathForSelectedRow = self.tableView.indexPathForSelectedRow {
        
            self.tableView.deselectRowAtIndexPath(indexPathForSelectedRow, animated: true)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 2 {
            
            return 1
        }
        
        return 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "CellIdentifier"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        if cell == nil {
            
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        
        if indexPath.section == 0 {
            
            switch indexPath.row {
                
            case 0:
                cell?.textLabel?.text = "Push via storyboard"
            default:
                cell?.textLabel?.text = "Push programmatically"
            }
        }
        else if indexPath.section == 1 {
            
            switch indexPath.row {
                
            case 0:
                cell?.textLabel?.text = "Modal via storyboard"
            default:
                cell?.textLabel?.text = "Modal programmatically"
            }
        }
        else if indexPath.section == 2 {
            
            cell?.textLabel?.text = "Settings"
        }
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        return section == (tableView.numberOfSections - 1) ? "Copyright © 2014\nSylvain Fay-Châtelard, Jesse Squires\nMIT License" : nil
    }
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 {
            
            switch indexPath.row {
                
            case 0:
                self.performSegueWithIdentifier("seguePushDemoVC", sender: self)
            default:
                let vc = DemoMessagesViewController.messagesViewController() as! DemoMessagesViewController
                vc.delegateModal = self
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if indexPath.section == 1 {
            
            switch indexPath.row {
                
            case 0:
                self.performSegueWithIdentifier("segueModalDemoVC", sender: self)
            default:
                let vc = DemoMessagesViewController.messagesViewController() as! DemoMessagesViewController
                vc.delegateModal = self
                let nc = UINavigationController(rootViewController: vc)
                self.presentViewController(nc, animated: true, completion: nil)
            }
        }
        else if indexPath.section == 2 {
            self.performSegueWithIdentifier("SegueToSettings", sender: self)
        }
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "segueModalDemoVC" {
            
            let nc = segue.destinationViewController as! UINavigationController
            let vc = nc.topViewController as! DemoMessagesViewController
            vc.delegateModal = self
        }
    }
    
    @IBAction func unwindSegue(sender: UIStoryboardSegue) { }
    
    // MARK: - Demo delegate
    
    func didDismissJSQDemoViewController(vc: DemoMessagesViewController) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}