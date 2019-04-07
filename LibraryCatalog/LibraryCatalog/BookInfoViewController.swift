//
//  BookInfoViewController.swift
//  LibraryCatalog
//
//  Created by Haley Hagler on 3/30/19.
//  Copyright © 2019 Haley Hagler. All rights reserved.
//
import Foundation
import Cocoa
import Alamofire
import AlamofireImage

class BookInfoViewController: NSViewController {

    
    @IBOutlet weak var coverImage: NSImageView!
    @IBOutlet weak var titleLable: NSTextField!
    @IBOutlet weak var authorLable: NSTextField!
    @IBOutlet weak var descriptionLable: NSTextField!
    
    
    var receivedData = BookCard()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLable.stringValue = receivedData.title
        authorLable.stringValue = fromVector(vector: receivedData.authors)
        descriptionLable.stringValue = receivedData.description
        Alamofire.request(receivedData.smallThumbnail, method: .get).responseImage { response in
            guard let image = response.result.value else {
                self.coverImage.image = NSImage(named: "bookCover.png")
                
                return
            }
            self.coverImage.image = image
        }
        
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    @IBAction func addButtonPushed(_ sender: Any) {
        
    }
    
}
