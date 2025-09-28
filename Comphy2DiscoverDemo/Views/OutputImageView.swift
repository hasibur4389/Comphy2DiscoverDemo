//
//  OutputImageView.swift
//  Comphy2DiscoverDemo
//
//  Created by Bcl Dey Device 8 on 25/9/25.
//

import UIKit

class OutputImageView: UIView {

    
    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage? {
        didSet {
            imageView?.image = image
        }
    }

    var didPressSave: (() -> Void)?
    var didPressShareImage: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 12.0
        imageView.layer.borderColor = UIColor(white: 1, alpha: 0.6).cgColor
        imageView.layer.borderWidth = 0.8
    }
    
    @IBAction func exitViewPressed(_ sender: UIButton) {
        imageView.image = nil
        image = nil
        removeFromSuperview()
    }
    
    @IBAction func saveImagePressed(_ sender: UIButton) {
        didPressSave?()
    }
    
    
    @IBAction func shareImagePressed(_ sender: UIButton) {
        didPressShareImage?()
    }
    

}
