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
import SwiftyJSON

class BookInfoViewController: NSViewController {

    
    @IBOutlet weak var coverImage: NSImageView!
    @IBOutlet weak var titleLable: NSTextField!
    @IBOutlet weak var authorLable: NSTextField!
    @IBOutlet weak var descriptionLable: NSTextField!
    
    
    var receivedData : JSON = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLable.stringValue = receivedData["title"].string!
        if receivedData["authors"][0].string == nil{
            authorLable.isHidden = true
        } else { authorLable.stringValue = receivedData["authors"][0].string! }
        if receivedData["description"].string == nil {
            descriptionLable.isHidden = true
        }else { descriptionLable.stringValue = receivedData["description"].string! }
        if receivedData["imageLinks"]["smallThumbnail"].string == nil {
            coverImage.image = NSImage(named: "bookCover.png")
        }else{
            Alamofire.request(receivedData["imageLinks"]["smallThumbnail"].string!, method: .get).responseImage { response in
                guard let image = response.result.value else {
                    self.coverImage.image = NSImage(named: "bookCover.png")
                    
                    return
                }
                self.coverImage.image = image
            }
        }
        
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
}
