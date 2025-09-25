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
    var didPressGenerate:(() -> Void)?
    var didRemove:(() -> Void)?
    
//    var jsonString: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        textView.text = jsonString
    }
    
    
    @IBAction func copyButtonPressed(_ sender: UIButton) {
        UIPasteboard.general.string = textView.text
        didPressCopy?()
       
    }
    
    
    @IBAction func generateButtonPressed(_ sender: UIButton) {
        didPressGenerate?()
    }
    
    
    @IBAction func exitButtonPressed(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    

}
