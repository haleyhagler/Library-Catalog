# Library Catalog

BookShelf is an application built for Mac that will keep lists of books for the user. It uses google books api to search for books with the title, author and/or ISBN. Books can be selected and added to libraries. It will display the books like a real life bookshelf

## App Views

- [x] [Book Search](#book-search-function): Pull Book Data with Google Books API and display in a table
- [ ] [Barcode Scanner](#barcode-scanner): to allow from scanning in ISBNs
- [ ] [User Libraries](#user-libraries) Add a Book to user Created Libraries
- [ ] [Bookshelf display](#bookshelf-display): Display Libraries with books spined out
- [ ] Allow to set a State for the book: Reading, Read, Have yet to Read
- [ ] Tracker to keep track of when books where read (Calendar Function)

### [Book Search Function](#book-search-function)

Uses google books API. Pulls Search Data based on Title, Author and ISBN. Google Books API [documentation]("https://developers.google.com/books/")

```swift
let API_books : String = "AIzaSyDoX358ucpk3R-MPLAOscqS8-YKiwdy5QE"
let project : String = "com.HaleyHagler.Bookshelf"
let URL : String = "https://www.googleapis.com/books/v1/volumes?q="
```

### [Barcode Scanner](#barcode-scanner) 

### [User Libraries](#user-libraries)

### [Bookshelf display](#bookshelf-display)

## Terms

- Libraries
- Book States

## Pods

- [Alamofire]("https://cocoapods.org/pods/Alamofire") -  Makes networking easy. Used to connect with google books API and aids in downloading the information on books
- [AlamofireImage]("https://cocoapods.org/pods/AlamofireImage") - Makes downloading Images easy. Used to download the image file for the book covers. 
- [SwiftyJSON]("https://cocoapods.org/pods/SwiftyJSON") - Make it easy to work with JSON. Used to pull relevant information from the JSON.



Cycle through book covers?? 
