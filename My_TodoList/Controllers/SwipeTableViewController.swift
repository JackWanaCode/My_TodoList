//
//  SwipeTableViewController.swift
//  My_TodoList
//
//  Created by Aries Lam on 3/30/19.
//  Copyright © 2019 Cuong Tran. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    var orient: SwipeActionsOrientation = .right

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 80.0
        
        tableView.separatorStyle = .none
        
    }
    
    //TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        orient = orientation
        
        if orientation == .right {
        
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                // handle action by updating model with deletion
                 self.updateModel(at: indexPath)
                
            }
            
            // customize the action appearance
            deleteAction.image = UIImage(named: "delete-icon")
            return [deleteAction]
            
        } else {
            let recordAction = SwipeAction(style: .default, title: "Record") { (action, indexPath) in
                self.recordVoice(at: indexPath)
            }
            recordAction.backgroundColor = UIColor(hexString: "CAF7FO")
            recordAction.textColor = UIColor(hexString: "000000")
            let updateContent = SwipeAction(style: .default, title: "Update") { (action, indexPath) in
                self.updateContent(at: indexPath)
            }
            updateContent.backgroundColor = UIColor(hexString: "FF64FF")
            updateContent.textColor = UIColor(hexString: "000000")
            return [recordAction, updateContent]
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        if orient == .right{
            options.expansionStyle = .destructive
        } else {
            options.expansionStyle = .selection
        }
        return options
    }

    func updateModel(at indexPath: IndexPath) {
        //Update our data model.

    }
    
    func recordVoice(at indexPath: IndexPath) {
        //Record voice.
    }
    func updateContent(at indexPath: IndexPath){
        //Update Content
    }
}

