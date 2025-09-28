//
//  AIAvatarDiscoverListCell.swift
//  NoCrop
//
//  Created by Bcl Dey Device 8 on 8/9/25.
//

import UIKit
import SDWebImage

class AIAvatarDiscoverListCell: UICollectionViewCell {
    static let identifier = "AIAvatarDiscoverListCell"
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var label: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
       // imageView.sd_cancelLatestImageLoad()
    }
    
    func setupUI() {
        label.textColor = UIColor(
            red: 252/255.0,
            green: 254/255.0,
            blue: 255/255.0,
            alpha: 1.0
        )

        
        self.layer.borderWidth = 0.6
        self.layer.borderColor = UIColor(white: 1.0, alpha: 0.1).cgColor
        self.layer.cornerRadius = 12.0
        self.layer.masksToBounds = true
        self.imageView.contentMode = .scaleAspectFill
        self.clipsToBounds = true

    }
    
    func loadImage(urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            imageView.image = UIImage(named: "AiImagePlaceHolder")
            return
        }
        
        imageView.sd_setImage(
            with: url,
            placeholderImage: UIImage(named: "AiImagePlaceHolder"),
            options: [.continueInBackground, .retryFailed]
        )
    }
}
