//
//  OutputImageView.swift
//  Comphy2DiscoverDemo
//
//  Created by Bcl Dey Device 8 on 25/9/25.
//

import UIKit

class OutputImageView: UIView {

    
    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage?
    
    var didPressSave: (() -> Void)?
    var didPressShareImage: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.image = image
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
