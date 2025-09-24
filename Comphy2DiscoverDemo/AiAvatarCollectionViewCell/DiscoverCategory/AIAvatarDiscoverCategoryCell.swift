//
//  AIAvatarDiscoverCategoryCell.swift
//  NoCrop
//
//  Created by Bcl Dey Device 8 on 8/9/25.
//

import UIKit

class AIAvatarDiscoverCategoryCell: UICollectionViewCell {
    static let identifier = "AIAvatarDiscoverCategoryCell"

    @IBOutlet weak var categoryLabel: UILabel!
        
    @IBOutlet weak var dummyViewForInsideBorder: UIView!
    
    var selectedLabelColor = UIColor(red: 16/255.0, green: 16/255.0, blue: 18/255.0, alpha: 1.0)  // #101012
    var unselectedLabelColor = UIColor(red: 122/255.0, green: 126/255.0, blue: 133/255.0, alpha: 1.0) // #7A7E85
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                categoryLabel.textColor = selectedLabelColor
                self.backgroundColor = .white
                dummyViewForInsideBorder.isHidden = true
            } else {
                categoryLabel.textColor =  unselectedLabelColor
                self.backgroundColor = .clear
                dummyViewForInsideBorder.isHidden = false
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    
    func setupUI() {
        self.layer.cornerRadius = 8
        self.dummyViewForInsideBorder.layer.cornerRadius = 8.0
        self.dummyViewForInsideBorder.layer.borderWidth = 0.6
        self.dummyViewForInsideBorder.layer.borderColor = UIColor(white: 1.0, alpha: 0.1).cgColor
        self.dummyViewForInsideBorder.layer.masksToBounds = true
        self.layer.masksToBounds = true
    }

}
