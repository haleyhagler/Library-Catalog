//
//  BookCard.swift
//  LibraryCatalog
//
//  Created by Haley Hagler on 4/6/19.
//  Copyright © 2019 Haley Hagler. All rights reserved.
//

import Cocoa
import SwiftyJSON

class BookCard{

    var kind : String
    var id : String
    var etag : String

    var title : String
    var authors : [String]
    var publisher : String
    var publishedDate : String
    var description : String

    var ISBN_13 : Int
    var ISBN_10 : Int

    var pageCount : Int
    var printType : String
    var categories : [String]

    var averageRating : Int
    var ratingsCount : Int
    var maturityRating : String

    var smallThumbnail : String
    var thumbnail : String

    var language : String
//    var previewLink : String
//    var infoLink : String
//    var canonicalVolumeLink : String


    init(json : JSON) {
        kind = json["kind"].string!
        id = json["id"].string!
        etag = json["etag"].string!
        
    //////////////////////////////////// Volume Info
        
        title = checkNullString(json : json["volumeInfo"]["title"])
        authors = toVector(json: json["volumeInfo"]["authors"])
        publisher = checkNullString(json : json["volumeInfo"]["publisher"])
        publishedDate = checkNullString(json : json["volumeInfo"]["publishedDate"])
        description = checkNullString(json : json["volumeInfo"]["description"])
        
     //////////////////////////////////// Industry Identifiers
        
        ISBN_13 = checkNullInt(json : json["volumeInfo"]["industryIdentifiers"]["ISBN_13"])
        ISBN_10 = checkNullInt(json : json["volumeInfo"]["industryIdentifiers"]["ISBN_10"])

        pageCount = checkNullInt(json : json["volumeInfo"]["pageCount"])
        printType = checkNullString(json : json["volumeInfo"]["printType"])
        categories = toVector(json: json["volumeInfo"]["categories"])

        averageRating = checkNullInt(json : json["volumeInfo"]["averageRating"])
        ratingsCount = checkNullInt(json : json["volumeInfo"]["ratingsCount"])
        maturityRating = checkNullString(json : json["volumeInfo"]["maturityRating"])
        
        //////////////////////////////////// Image Links
        
        smallThumbnail = checkNullString(json : json["volumeInfo"]["imageLinks"]["smallThumbnail"])
        thumbnail = checkNullString(json: json["volumeInfo"]["imageLinks"]["thumbnail"])

        language = checkNullString(json : json["volumeInfo"]["language"])
//        previewLink = json["volumeInfo"]["previewLink"].string!
//        infoLink = json["volumeInfo"]["infoLink"].string!
//        canonicalVolumeLink = json["volumeInfo"]["canonicalVolumeLink"].string!

    }
}

func toVector(json : JSON) -> [String]{
    var i : Int = 0
    var vector : [String] = []
    while json[i] != JSON.null {
        vector.append(json[i].string!)
        i = i + 1
    }
    return vector
}

func fromVector(vector : [String]) -> String {
    var output : String = ""
    for item in vector{
        output = "\(output)\(item) "
    }
    return output
}

func checkNullString(json : JSON) -> String{
    if json == JSON.null { return "" }
    else { return json.string! }
}

func checkNullInt(json : JSON) -> Int{
    if json == JSON.null { return -1 }
    else { return json.int! }
}
