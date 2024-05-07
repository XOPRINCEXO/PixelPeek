//
//  ViewModel.swift
//  PixelPeek
//
//  Created by Prince on 03/05/24.
//

import Foundation
import UIKit

//MARK: Custom Datatypes
struct Item {
    var itemName: String = ""
    var itemValue: String = ""
    var itemImageUrl: String
    var itemBoundingBox: CGRect
    
    init(itemName: String, itemValue: String, itemImageUrl: String,itemBoundingBox: CGRect) {
        self.itemName = itemName
        self.itemValue = itemValue
        self.itemImageUrl = itemImageUrl
        self.itemBoundingBox = itemBoundingBox
    }
}

//MARK: Download Image from URL
func getImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
    guard let url = URL(string: urlString) else {
        completion(nil)
        return
    }
    
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let error = error {
            print("Error fetching image: \(error.localizedDescription)")
            DispatchQueue.main.async {
                completion(nil)
            }
            return
        }
        
        guard let data = data else {
            print("No data received")
            DispatchQueue.main.async {
                completion(nil)
            }
            return
        }
        
        if let image = UIImage(data: data) {
            DispatchQueue.main.async {
                completion(image)
            }
        } else {
            print("Unable to convert data to image")
            DispatchQueue.main.async {
                completion(nil)
            }
        }
    }
    
    task.resume()
}

//MARK: Dummy Data
func getBooksShelfData() -> [Item] {
    //Image Item coordinates
    var bookList: [Item] = []
    
    // -- Shelf 1 --
    var imageLink = "https://m.media-amazon.com/images/I/919bHrm3yWL._AC_UF1000,1000_QL80_.jpg"
    var boundingBox: CGRect = CGRect(x: 650, y: 415, width: 250, height: 270)
    var book = Item(itemName: "The Four Steps to the Epiphany", itemValue: "₹2,800.00", itemImageUrl: imageLink, itemBoundingBox: boundingBox)
    bookList.append(book)
    
    imageLink = "https://m.media-amazon.com/images/I/41fa9EuJUfS.jpg"
    boundingBox = CGRect(x: 1065, y: 400, width: 250, height: 285)
    book = Item(itemName: "Don't Make Me Think", itemValue: "₹1,272.00 INR", itemImageUrl: imageLink, itemBoundingBox: boundingBox)
    bookList.append(book)
    
    imageLink = "https://m.media-amazon.com/images/I/81qQ3b-Wh0L._SY522_.jpg"
    boundingBox = CGRect(x: 1680, y: 450, width: 180, height: 230)
    book = Item(itemName: "Growth Hacker Marketing", itemValue: "₹1,108.00 INR", itemImageUrl: imageLink, itemBoundingBox: boundingBox)
    bookList.append(book)
    
    imageLink = "https://knowledgelibrary.ifma.org/wp-content/uploads/2023/01/2016-02-MarApr-800x1024.png"
    boundingBox = CGRect(x: 2245, y: 350, width: 300, height: 335)
    book = Item(itemName: "The Quantified Building", itemValue: "N/A", itemImageUrl: imageLink, itemBoundingBox: boundingBox)
    bookList.append(book)
    
    // -- Shelf 2 --
    imageLink = "https://m.media-amazon.com/images/I/71SkrXVO92L._AC_UF350,350_QL50_.jpg"
    boundingBox = CGRect(x: 635, y: 820, width: 215, height: 290)
    book = Item(itemName: "Conscious Capitalism", itemValue: "₹1,528.69 INR", itemImageUrl: imageLink, itemBoundingBox: boundingBox)
    bookList.append(book)
    
    imageLink = "https://m.media-amazon.com/images/I/51mSnTZNM4L.jpg"
    boundingBox = CGRect(x: 1075, y: 825, width: 235, height: 285)
    book = Item(itemName: "Microinteractions", itemValue: "₹641.25 INR", itemImageUrl: imageLink, itemBoundingBox: boundingBox)
    bookList.append(book)
    
    imageLink = "https://m.media-amazon.com/images/I/61BFOf9Ap-L._AC_UF1000,1000_QL80_.jpg"
    boundingBox = CGRect(x: 1410, y: 825, width: 210, height: 285)
    book = Item(itemName: "The Lean Startup", itemValue: "₹1,599.00 INR", itemImageUrl: imageLink, itemBoundingBox: boundingBox)
    bookList.append(book)
    
    imageLink = "https://rukminim2.flixcart.com/image/850/1000/kkmwr680/book/j/x/l/crossing-the-chasm-original-imafzxwyyhuczcx8.jpeg?q=90&crop=false"
    boundingBox = CGRect(x: 1725, y: 820, width: 215, height: 290)
    book = Item(itemName: "Crossing The Chasm", itemValue: "₹349.00 INR", itemImageUrl: imageLink, itemBoundingBox: boundingBox)
    bookList.append(book)
    
    imageLink = "https://m.media-amazon.com/images/I/51e5NpuRtFL.jpg"
    boundingBox = CGRect(x: 2270, y: 830, width: 240, height: 280)
    book = Item(itemName: "Desiging With Web Standards", itemValue: "₹3,485.13 INR", itemImageUrl: imageLink, itemBoundingBox: boundingBox)
    bookList.append(book)
    
    // -- Shelf 3 --
    imageLink = "https://image.isu.pub/160109141055-196d84b6c9e9f8853aa9f9e0e17530ce/jpg/page_1.jpg"
    boundingBox = CGRect(x: 570, y: 1250, width: 370, height: 280)
    book = Item(itemName: "2015/Workplace Showcase", itemValue: "N/A", itemImageUrl: imageLink, itemBoundingBox: boundingBox)
    bookList.append(book)
    
    imageLink = "https://m.media-amazon.com/images/I/41aDnD94iCL._AC_UF1000,1000_QL80_.jpg"
    boundingBox = CGRect(x: 1080, y: 1240, width: 200, height: 290)
    book = Item(itemName: "Déclics", itemValue: "₹910.92 INR", itemImageUrl: imageLink, itemBoundingBox: boundingBox)
    bookList.append(book)
    
    imageLink = "https://m.media-amazon.com/images/I/51iljNYtA3L._AC_UF1000,1000_QL80_.jpg"
    boundingBox = CGRect(x: 1425, y: 1280, width: 200, height: 250)
    book = Item(itemName: "Mobile Web Design", itemValue: "₹1,708.00 INR", itemImageUrl: imageLink, itemBoundingBox: boundingBox)
    bookList.append(book)
    
    imageLink = "https://m.media-amazon.com/images/I/81RUq9XAYkL._AC_UF1000,1000_QL80_.jpg"
    boundingBox = CGRect(x: 1735, y: 1255, width: 205, height: 275)
    book = Item(itemName: "Managing Startups", itemValue: "₹1,297.00 INR", itemImageUrl: imageLink, itemBoundingBox: boundingBox)
    bookList.append(book)
    
    imageLink = "https://m.media-amazon.com/images/I/71Qde+ZerdL._AC_UF1000,1000_QL80_.jpg"
    boundingBox = CGRect(x: 2210, y: 1255, width: 240, height: 275)
    book = Item(itemName: "Domain-Driven Design", itemValue: "₹1,595.00 INR", itemImageUrl: imageLink, itemBoundingBox: boundingBox)
    bookList.append(book)
    
    return bookList
}
