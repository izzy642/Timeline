//
//  PostDetailTableViewController.swift
//  Timeline
//
//  Created by Caleb Hicks on 5/25/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import UIKit

class PostDetailTableViewController: UITableViewController {
    
    var post: Post?
    var comments: [Comment]? {
        
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: true)
        return post?.comments?.sortedArrayUsingDescriptors([sortDescriptor]) as? [Comment]
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 40
        
        if let post = post {
            
            updateWithPost(post)
        }
    }
    
    func updateWithPost(post: Post) {
        
        imageView.image = post.photo
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return comments?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath)
        
        if let comments = comments {
            
            let comment = comments[indexPath.row]
            
            cell.textLabel?.text = comment.text
            cell.detailTextLabel?.text = comment.recordName
        }
        
        return cell
    }
    
    
    // MARK: - Post Actions
    
    @IBAction func commentButtonTapped(sender: AnyObject) {
        
        presentCommentAlert()
    }
    
    @IBAction func shareButtonTapped(sender: AnyObject) {
        
        presentActivityViewController()
    }
    
    @IBAction func followUserButtonTapped(sender: AnyObject) {
        
    }
    
    func presentCommentAlert() {
        
        let alertController = UIAlertController(title: "Add Comment", message: nil, preferredStyle: .Alert)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            
            textField.placeholder = "Nice shot!"
        }
        
        let addCommentAction = UIAlertAction(title: "Add Comment", style: .Default) { (action) in
            
            guard let commentText = alertController.textFields?.first?.text,
                let post = self.post else { return }
            
            PostController.sharedController.addCommentToPost(commentText, post: post, completion: { (success) in
                
                self.tableView.reloadData()
            })
        }
        alertController.addAction(addCommentAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func presentActivityViewController() {
        
        guard let photo = post?.photo,
            let comment = post?.comments?.firstObject as? Comment,
            let text = comment.text else { return }
        
        let activityViewController = UIActivityViewController(activityItems: [photo, text], applicationActivities: nil)
        
        presentViewController(activityViewController, animated: true, completion: nil)
    }

}
