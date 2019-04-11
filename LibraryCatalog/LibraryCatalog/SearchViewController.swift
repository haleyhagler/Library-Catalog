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
    
    // TODO:    Create barcode scanner
    // TODO:    Pagentation -> Add Load More results  
    // TODO:    Loading Screan/Wheel !!!
    // TODO:    Alert user when there is no internet connection
    // TODO:    Alert user when there are no results
    
    
    /////////////////////////////////////////// URL Constants
    
    let API_books : String = "AIzaSyAMfBSt5KiuHQE2VgycO0bz6reABBdyhcc"
    let project : String = "com.HaleyHagler.Bookshelf"
    let URL : String = "https://www.googleapis.com/books/v1/volumes?q="
    
    /////////////////////////////////////////// Global Variables
    
    var data : [BookCard] = []
    var selectedIndex : Int = -1            // Not sure if nessaray
    
    ///////////////////////////////////////////  IBOutlets
    
    @IBOutlet weak var bookTitleTextInput: NSTextField!
    @IBOutlet weak var authorTextInput: NSTextField!
    @IBOutlet weak var isbnTextInput: NSTextField!
    @IBOutlet weak var subjectTextInput: NSTextField!
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
    
    // MARK:    SEARCH BUTTON
    
    @IBAction func searchButton(_ sender: Any) {
        
        let bookTitle = ["id" : "intitle",
                         "string" : bookTitleTextInput.stringValue.replacingOccurrences(of: " ", with: "+") ]
        let author = ["id" : "inauthor",
                      "string" : authorTextInput.stringValue.replacingOccurrences(of: " ", with: "+")  ]
        let isbn = ["id" : "isbn",
                    "string" : isbnTextInput.stringValue.replacingOccurrences(of: " ", with: "+") ]
        let subject = ["id" : "subject",
                       "string" : subjectTextInput.stringValue.replacingOccurrences(of: " ", with: "+") ]
        
        let searchTerms = [bookTitle, author, isbn, subject]
        
        var currentURL = URL
        
        data.removeAll()           // Clears Data from Last Search

        //////////////////// Create URL

        for term in searchTerms{
          if term["string"] != ""{
            currentURL += "\(String(describing: term["id"]!)):\(String(describing: term["string"]!))+"
            }
        }
        currentURL = String(currentURL.dropLast())
        currentURL += "&maxResults=25&key=\(API_books)"
        print("URL: \(currentURL)")

        //////////////////// Grab JSON from URL

        Alamofire.request(currentURL, method: .get ).responseJSON{
            response in
            if response.result.isSuccess {
                // print("Success! Got the book data")
                let bookJSON : JSON = JSON(response.result.value!)      // Grabs Data from google books
                var items = bookJSON["totalItems"]
                self.populateData(json: bookJSON)                       // Makes vector with each book
                self.tableView.reloadData()                             // Creates Table
                print(items)
                //print(bookJSON)
            }
            else { print("Error \(response.result.error!)") }           // In Case of Error
        }
        
        clearInputs()
        
    }
    
    func clearInputs(){
        bookTitleTextInput.stringValue = ""
        authorTextInput.stringValue = ""
        isbnTextInput.stringValue = ""
        subjectTextInput.stringValue = ""
    }
    
    // MARK: TABEL VIEW FUCNTIONS
    
    func populateData(json : JSON){
        var i  = 0
        while json["items"][i]["volumeInfo"] != JSON.null {
            let book : BookCard = BookCard(json : json["items"][i])
            data.append(book)
            i += 1
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int { return data.count }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?{
        let item = data[row]
    
        if item.title != "" {
            let cell : BookTableCell = (tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? BookTableCell)!
            
            cell.title.stringValue = item.title
            cell.author.stringValue = fromVector(vector: item.authors)
            cell.publishedDate.stringValue = item.publishedDate
            cell.rating.stringValue = item.stringRating
      
            Alamofire.request(item.smallThumbnail, method: .get).responseImage { response in
                guard let image = response.result.value else {
                    cell.cover.image = NSImage(named: "bookCover.png")
                    
                    return
                }
                cell.cover.image = image
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
