//
//  ViewController.swift
//  PixelPeek
//
//  Created by Prince on 03/05/24.
//

import Foundation
import UIKit

class ViewController: UIViewController {
    
    // MARK: -  Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var popupItemBtn: UIButton!
    @IBOutlet weak var itemPriceLbl: UILabel!
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var itemListView: UIView!
    
    // MARK: -  Properties
    var ItemList: [Item] = []
    var layer: CAShapeLayer?
    
    // MARK: -  LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUi()
    }
    
    // MARK: -  Actions
    @IBAction func popupItemBtnDidTap(_ sender: Any) {
        if let product = self.itemNameLbl.text?.replacingOccurrences(of: " ", with: "+") {
            if let url = URL(string: "https://www.amazon.com/s?k=\(product)") {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
    
    
    // MARK: -  Custom Methods
    private func setupUi() {
        self.setupPopup()
        self.setupTableView()
        self.setupScrollView()
        self.setupItemListView()
    }
    
    private func setupPopup() {
        self.popupView.layer.cornerRadius = 10
        self.popupView.layer.shadowColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 1)
        self.popupView.layer.shadowRadius = 10
        self.popupView.isHidden = true
    }
    
    private func setupTableView() {
        self.ItemList = getBooksShelfData()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = .white
        self.tableView.register(BookTableViewCell.nib(), forCellReuseIdentifier: BookTableViewCell.cellIdentifier)
    }
    
    private func setupScrollView() {
        self.scrollView.delegate = self
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 3.0
        self.scrollView.layer.cornerRadius = 15
        self.scrollView.isUserInteractionEnabled = false
    }
    
    private func setupItemListView() {
        self.itemListView.layer.cornerRadius = 20
        self.itemListView.layer.borderWidth = 1
        self.itemListView.layer.borderColor = UIColor.lightGray.cgColor
    }
}
// MARK: -  Tableview Delegate and Datasource methods
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ItemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let itemCell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.cellIdentifier, for: indexPath) as? BookTableViewCell else { return UITableViewCell() }
        itemCell.configureCellData(itemname: self.ItemList[indexPath.row].itemName)
        return itemCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.itemNameLbl.text == self.ItemList[indexPath.row].itemName {
            self.resetPopup()
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }else {
            self.markItemAndPresentPopup(item: self.ItemList[indexPath.row])
        }
    }
    
}

// MARK: -  ScrollView Delegate
extension ViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.mainImageView
    }
}

// MARK: - Item Marking and Popup Methods
extension ViewController {
    func markItemAndPresentPopup(item: Item) {
        self.popupView.isHidden = true
        let maxPixels = max(self.mainImageView.image!.size.width, self.mainImageView.image!.size.width)
        let scaleX = self.scrollView.frame.size.width / maxPixels
        let scaleY = self.scrollView.frame.size.height / maxPixels
        var offsetX: CGFloat = max((self.scrollView.frame.size.width - self.mainImageView.image!.size.width * scaleX) / 2, 0)
        var offsetY: CGFloat = max((self.scrollView.frame.size.height - self.mainImageView.image!.size.height * scaleY) / 2, 0)
        let itemX = item.itemBoundingBox.origin.x
        let itemY = item.itemBoundingBox.origin.y
        let contentOffset = self.scrollView.contentOffset
        
        //convert original image item coordinates to Imageview frame size coordinates.
        var newRelativeItemBoundingBox = CGRect(
            x: (itemX * scaleX) - contentOffset.x + offsetX,
            y: (itemY * scaleX) - contentOffset.y + offsetY,
            width: item.itemBoundingBox.size.width * scaleX,
            height: item.itemBoundingBox.size.height * scaleX
        )
        
        //Handle negative coordinates scenarios.
        if newRelativeItemBoundingBox.origin.x < 0 {
            newRelativeItemBoundingBox.origin.x = 0
        }

        if newRelativeItemBoundingBox.origin.y < 0 {
            newRelativeItemBoundingBox.origin.y = 0
        }
        
        //Removing previously selected product's shapelayer/rect/marking if any.
        if let oldLayer = self.layer{
            oldLayer.removeFromSuperlayer()
        }
        
        //Adding Shapelayer of item to the image.
        let rectLayer = CAShapeLayer()
        rectLayer.path = UIBezierPath(rect: newRelativeItemBoundingBox).cgPath
        rectLayer.strokeColor = UIColor.black.cgColor
        rectLayer.fillColor = UIColor.green.cgColor
        rectLayer.opacity = 0.4
        self.mainImageView.layer.addSublayer(rectLayer)
        self.layer = rectLayer
        
        self.updatePopupData(item: item, itemRelativeRect: newRelativeItemBoundingBox)
    }
    
    func updatePopupData(item: Item, itemRelativeRect: CGRect) {
        //fetch and update item image and detail in popup
        getImage(from: item.itemImageUrl) { (image) in
            if let image = image {
                print("Image fetched successfully")
                self.itemImageView.image = image
            }
        }
        self.itemNameLbl.text = item.itemName
        self.itemPriceLbl.text = item.itemValue
        
        //calculating popup coordinates to appear next to item.
        let popupSize = self.popupView.frame.size
        var popupX: CGFloat = 0
        var popupY: CGFloat = itemRelativeRect.midY - popupSize.height/2
        
        //Handling right or left side positioning with 10px padding from each leading and trailing side
        if itemRelativeRect.origin.x > mainImageView.frame.width/2 {
            //popup will appear on left side of the item.
            popupX = max(10, itemRelativeRect.origin.x - popupSize.width - 10)
        }else {
            //popup will appear on right side of the item.
            popupX = min(itemRelativeRect.maxX + 10, mainImageView.frame.width - popupSize.width - 10)
        }
        
        if popupY < 10 {
            //To not let popup appear outside image view from top.
            popupY = 10
        }
        if popupY + popupSize.height > mainImageView.frame.height - 10 {
            //To not let popup appear outside image view from bottom.
            popupY = mainImageView.frame.height - popupSize.height - 10
        }
        
        self.popupView.isHidden = false
        
        if self.popupView.frame.origin == CGPoint(x: 0, y: 0) {
            //popup appearing for the first time or after deselection. Dont animate the movement
            self.popupView.frame = CGRect(origin: CGPoint(x: popupX, y: popupY), size: popupSize)
        }else {
            UIView.animate(withDuration: 0.3) {
                self.popupView.frame = CGRect(origin: CGPoint(x: popupX, y: popupY), size: popupSize)
            }
        }
    }
    
    func resetPopup() {
        //reset popup and remove shapelayer from imageview
        self.popupView.isHidden = true
        self.itemNameLbl.text = ""
        self.itemPriceLbl.text = ""
        self.popupView.frame.origin = CGPoint(x: 0, y: 0)
        if let anyMarkLayer = self.layer {
            anyMarkLayer.removeFromSuperlayer()
            self.layer = nil
        }
    }

}
