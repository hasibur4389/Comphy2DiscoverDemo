//
//  AIAvatarDiscoverListViewController.swift
//  NoCrop
//
//  Created by Bcl Dey Device 8 on 8/9/25.
//

import UIKit
import SVProgressHUD

class AIAvatarDiscoverListViewController: UIViewController {
    
    
  
    @IBOutlet weak var navTitleLabel: UILabel!
    
    @IBOutlet weak var dicoverCategoryCollectionView: UICollectionView!
    
    @IBOutlet weak var discoverListCollectionView: UICollectionView!
        
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    var tagsDiscoverModel: TagsResponseModel? = nil
    var navTitle: String = ""
    var selectedTagIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    var selectedDiscoverIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // addObserver()
        setupUI()
        registerCell()
        updateCollectionView()
        
    }
    
//    func addObserver() {
//        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged), name: NSNotification.Name("AIIMAGE_REACHABILTY_CHANGED"), object: nil)
//    }
//    
//    @objc func reachabilityChanged(_ notification: Notification) {
//        // Handle the reachability change here
//        if Reachability.checkInternetConnection() {
//            DispatchQueue.main.async {[weak self] in
//                self?.discoverListCollectionView.reloadData()
//            }
//            
//        }
//    }
    
//    deinit {
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("AIIMAGE_REACHABILTY_CHANGED"), object: nil)
//    }
    
    
    func setupUI() {
        self.navigationController?.navigationBar.isHidden = true
        navTitleLabel.text = navTitle
    }
    
    func updateCollectionView() {
 
        discoverListCollectionView.reloadData()
        dicoverCategoryCollectionView.reloadData()
        if let tags = tagsDiscoverModel?.tags, tags.count > 0 {
            dicoverCategoryCollectionView.selectItem(at: selectedTagIndexPath, animated: false, scrollPosition: .centeredHorizontally)
        }
    }
        
    @IBAction func backButtonPressed(_ sender: UIButton) {
        guard let navController = self.navigationController else { return }
        self.navigationController?.popViewController(animated: true)
        
    }
    

    
    func registerCell() {
        discoverListCollectionView.register(UINib(nibName: AIAvatarDiscoverListCell.identifier, bundle: nil), forCellWithReuseIdentifier: AIAvatarDiscoverListCell.identifier)
        
        dicoverCategoryCollectionView.register(UINib(nibName: AIAvatarDiscoverCategoryCell.identifier, bundle: nil), forCellWithReuseIdentifier: AIAvatarDiscoverCategoryCell.identifier)
    }
    
}


extension AIAvatarDiscoverListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == dicoverCategoryCollectionView {
            return tagsDiscoverModel?.tags?.count ?? 0
        } else {
            if let tags = tagsDiscoverModel?.tags,
               selectedTagIndexPath.row < tags.count {
                return tags[selectedTagIndexPath.row].discoverModels?.count ?? 0
            }
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == dicoverCategoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AIAvatarDiscoverCategoryCell.identifier, for: indexPath) as! AIAvatarDiscoverCategoryCell
            cell.categoryLabel.text = tagsDiscoverModel?.tags?[indexPath.row].displayName
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AIAvatarDiscoverListCell.identifier, for: indexPath) as! AIAvatarDiscoverListCell
            
            if let tags = tagsDiscoverModel?.tags,
               selectedTagIndexPath.row < tags.count {
                
                let discoverModels = tags[selectedTagIndexPath.row].discoverModels ?? []
                
                if indexPath.row < discoverModels.count {
                    let item = discoverModels[indexPath.row]
                    cell.label.text = item.discoverName
                    cell.loadImage(urlString: item.thumbnailImageUrl)
                }
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == dicoverCategoryCollectionView {
            selectedTagIndexPath = indexPath
            dicoverCategoryCollectionView.selectItem(at: selectedTagIndexPath, animated: true, scrollPosition: .centeredHorizontally)
            discoverListCollectionView.reloadData()
        } else {
            selectedDiscoverIndexPath = indexPath

            if let tags = tagsDiscoverModel?.tags,
               selectedTagIndexPath.row < tags.count,
               let discoverModels = tags[selectedTagIndexPath.row].discoverModels,
               indexPath.row < discoverModels.count,
               let jsonFileUrlString = discoverModels[indexPath.row].jsonFileUrl {
                
                showLoader(withMessage: "Loading Discover JSON...")
                Comphy2ApiRequest().fetchApiRequestModelFromJsonURL(from: jsonFileUrlString) {[weak self] jsonString, error in
                    guard let self else { return }
                    hideLoader()
                    if let jsonString {
                        DispatchQueue.main.async {[weak self] in
                            guard let self else { return }
                            if let displayer = Bundle.main.loadNibNamed("JSONDisplayer", owner: nil, options: nil)?.first as? JSONDisplayer {
                                let safeInsets = self.view.safeAreaInsets
                                let screenWidth = self.view.bounds.width
                                let screenHeight = self.view.bounds.height
                                
                                displayer.frame = CGRect(
                                    x: safeInsets.left,
                                    y: safeInsets.top,
                                    width: screenWidth - safeInsets.left - safeInsets.right,
                                    height: screenHeight - safeInsets.top
                                )
                                displayer.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                                
                                displayer.textView.text = jsonString
                                displayer.didPressCopy = { [weak self] in
                                    guard let self else { return }
                                    // Convert string to Data
                                    guard let jsonData = jsonString.data(using: .utf8) else { return }
                                    
                                    // Create a temporary file URL
                                    if let name = discoverModels[indexPath.row].discoverName {
                                        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(name).json")
                                        
                                        do {
                                            // Write JSON data to the file
                                            try jsonData.write(to: tempURL)
                                            
                                            // Create a UIActivityViewController for sharing
                                            let activityVC = UIActivityViewController(activityItems: [tempURL], applicationActivities: nil)
                                            // Optional: for iPad support
                                            if let popover = activityVC.popoverPresentationController {
                                                popover.sourceView = self.view
                                                popover.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                                                popover.permittedArrowDirections = []
                                            }
                                            self.present(activityVC, animated: true)
                                        } catch {
                                            print("Failed to write JSON file: \(error)")
                                            showAlert(title: "Failed to write JSON file", message: error.localizedDescription)
                                           
                                        }
                                    } else {
                                        showAlert(title: "Nil Found", message: "Discover name found nil")
                                    }
                                }
                                self.view.addSubview(displayer)
                            }
                        }
                    } else if let error {
                        print("Error fetching JSON: \(error.localizedDescription)")
                        DispatchQueue.main.async {[weak self] in
                            guard let self else { return }
                            showAlert(title: "Error!", message: error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let ratio = (UIScreen.main.bounds.width/414.0)
        if collectionView == dicoverCategoryCollectionView {
            return CGSize(width: 60, height: collectionView.frame.height)
        } else {
            let horizontalInset = 16.0*2
            let numberOfItemsInRow = 2.0
            
            var spacing = 10.0
            let totalSpacing = spacing * (numberOfItemsInRow - 1)
            let totalWidth = UIScreen.main.bounds.width - totalSpacing - horizontalInset
            let rawItemWidth = totalWidth / numberOfItemsInRow
            let itemWidth = floor(rawItemWidth)
            let size = CGSize(width: itemWidth, height: 4/3*itemWidth)
            print("AI Avatar discover list cell size \(size)")
            return size
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == dicoverCategoryCollectionView {
            return 8
        } else {
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == dicoverCategoryCollectionView {
            return 8
        } else {
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == dicoverCategoryCollectionView {
            return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        } else {
            return UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        }
    }
}
