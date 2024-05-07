//
//  BookTableViewCell.swift
//  PixelPeek
//
//  Created by Prince on 03/05/24.
//

import UIKit

class BookTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    class var cellIdentifier: String {
        get {
            return "BookTableViewCell"
        }
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "BookTableViewCell", bundle: nil)
    }
    
    func configureCellData(itemname: String) {
        self.itemName.text = itemname
    }
    
}
