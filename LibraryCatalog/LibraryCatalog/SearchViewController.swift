//
//  SearchViewController.swift
//  LibraryCatalog
//
//  Created by Haley Hagler on 3/29/19.
//  Copyright © 2019 Haley Hagler. All rights reserved.
//

import Cocoa
import Alamofire
import SwiftyJSON
import AlamofireImage

class SearchViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    /////////////////////////////////////////// URL Constants
    
    let API_books : String = "AIzaSyAMfBSt5KiuHQE2VgycO0bz6reABBdyhcc"
    let project : String = "com.HaleyHagler.Bookshelf"
    let URL : String = "https://www.googleapis.com/books/v1/volumes?q="
    
    /////////////////////////////////////////// Global Variables
    
    //var data : [[String: String]] = []
    var data : [JSON] = []
    var selectedIndex : Int = -1            // Not sure if nessaray
    
    ///////////////////////////////////////////  IBOutlets
    
    @IBOutlet weak var bookTitleTextInput: NSTextField!
    @IBOutlet weak var authorTextInput: NSTextField!
    @IBOutlet weak var isbnTextInput: NSTextField!
    @IBOutlet weak var tableView: NSTableView!
    
    ///////////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
    
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    /////////////////////////////////////////// IBActions
    // MARK:    SEARCH BUTTON
    
    @IBAction func searchButton(_ sender: Any) {
    
        let bookTitle = bookTitleTextInput.stringValue
        let author = authorTextInput.stringValue
        var currentURL = URL

        data.removeAll()           // Clears Data from Last Search

        //////////////////// Create URL

        currentURL += prepareForURL(input: bookTitle, url: "intitle")
        if bookTitle != "" && author != ""{ currentURL += "+" }
        currentURL += prepareForURL(input: author, url: "inauthor")
        currentURL += "&key=\(API_books)"
        print("URL: \(currentURL)")

        //////////////////// Grab JSON from URL

        Alamofire.request(currentURL, method: .get ).responseJSON{
            response in
            if response.result.isSuccess {
                // print("Success! Got the book data")
                let bookJSON : JSON = JSON(response.result.value!)      // Grabs Data from google books
                self.populateData(json: bookJSON)                       // Makes vector with each book
                self.tableView.reloadData()                             // Creates Table
                //print(bookJSON)
            }
            else { print("Error \(response.result.error!)") }           // In Case of Error
        }
    }
    
    // sets up inputs for the url
    
    func prepareForURL( input : String, url : String ) -> String {
        if input != ""{
            return "\(url):\(input.replacingOccurrences(of: " ", with: "+"))"
        } else { return "" }
    }
    
    /////////////////////////////////////////// TABEL VIEW FUCNTIONS
    // MARK: TABEL VIEW FUCNTIONS
    
    func populateData(json : JSON){
        var i  = 0
        while json["items"][i]["volumeInfo"] != JSON.null {
            data.append(json["items"][i]["volumeInfo"])
            i += 1
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int { return data.count }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?{
        let item = data[row]
    
        if item["title"].string != nil {
            let cell : BookTableCell = (tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? BookTableCell)!
            
            cell.title.stringValue = item["title"].string!
            if item["authors"][0].string == nil {
                cell.author.isHidden = true
            } else { cell.author.stringValue = item["authors"][0].string! }
            if item["imageLinks"]["smallThumbnail"].string == nil {
                cell.cover.image = NSImage(named: "bookCover.png")
            }else{
                Alamofire.request(item["imageLinks"]["smallThumbnail"].string!, method: .get).responseImage { response in
                    guard let image = response.result.value else {
                        cell.cover.image = NSImage(named: "bookCover.png")
                        
                        return
                    }
                    cell.cover.image = image
                }
            }
            return cell
        } else { return nil }
        
    }


    func tableViewSelectionDidChange(_ notification: Notification) {
        selectedIndex = self.tableView.selectedRow
        self.performSegue(withIdentifier: "toBookInfo", sender: self)
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        let secondViewController = segue.destinationController as! BookInfoViewController
        secondViewController.receivedData = data[selectedIndex]
    }
}

class BookTableCell : NSTableCellView {
    
    @IBOutlet weak var cover: NSImageView!
    @IBOutlet weak var title: NSTextField!
    @IBOutlet weak var author: NSTextField!
    @IBOutlet weak var publishedDate: NSTextField!
    @IBOutlet weak var rating: NSTextField!
    
    
}
