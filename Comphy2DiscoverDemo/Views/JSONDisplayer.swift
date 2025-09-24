//
//  JSONDisplayer.swift
//  Comphy2DiscoverDemo
//
//  Created by Bcl Dey Device 8 on 24/9/25.
//

import UIKit

class JSONDisplayer: UIView {

    @IBOutlet weak var textView: UITextView!
    
    var didPressCopy: (() -> Void)?
    
    override func awakeFromNib() {
        
    }
    
    
    @IBAction func copyButtonPressed(_ sender: UIButton) {
        UIPasteboard.general.string = textView.text
        didPressCopy?()
       
    }
    
    
    @IBAction func exitButtonPressed(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    

}
