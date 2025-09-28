//
//  AIAvatarDiscoverListViewController.swift
//  NoCrop
//
//  Created by Bcl Dey Device 8 on 8/9/25.
//

import UIKit
import SVProgressHUD
import ZipArchive

class AIAvatarDiscoverListViewController: UIViewController {
    
    
  
    @IBOutlet weak var navTitleLabel: UILabel!
    
    @IBOutlet weak var dicoverCategoryCollectionView: UICollectionView!
    
    @IBOutlet weak var discoverListCollectionView: UICollectionView!
        
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    var tagsDiscoverModel: TagsResponseModel? = nil
    var navTitle: String = ""
    var selectedTagIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    var selectedDiscoverIndexPath: IndexPath = IndexPath(row: 0, section: 0)
   
    let overlayView = UIView()
    let comphy2APi = Comphy2ApiRequest()
    var discoverDict: [String: Any]?
    var discoverName: String?
    
    
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
    

    // MARK: - Save Image to Photos
    func saveImageToPhotos(_ image: UIImage, completion: ((Bool, Error?) -> Void)? = nil) {
        DispatchQueue.main.async {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            completion?(true, nil)
        }
       
    }
    
    // MARK: - Share Image
    func shareImage(_ image: UIImage) {
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
       
        DispatchQueue.main.async { [weak self] in
            activityVC.popoverPresentationController?.sourceView = self?.view // for iPad support
            self?.present(activityVC, animated: true)
        }
        
    }


    
    func registerCell() {
        discoverListCollectionView.register(UINib(nibName: AIAvatarDiscoverListCell.identifier, bundle: nil), forCellWithReuseIdentifier: AIAvatarDiscoverListCell.identifier)
        
        dicoverCategoryCollectionView.register(UINib(nibName: AIAvatarDiscoverCategoryCell.identifier, bundle: nil), forCellWithReuseIdentifier: AIAvatarDiscoverCategoryCell.identifier)
    }
    
    func handleSaveAndCopy(jsonString: String, discoverName: String?) {
        // Convert string to Data
        guard let jsonData = jsonString.data(using: .utf8) else { return }
        
        // Create a temporary file URL
        if let name = discoverName {
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
    
    // MARK: - Properties

    func showLoaderWithCancel() {
        guard let window = self.view else { return }

        // Configure overlay
        overlayView.frame = window.bounds
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlayView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
       

        // Configure cancel button
        let cancelButton = UIButton(type: .system)
        cancelButton.backgroundColor = .systemBlue
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.tintColor = .white
        cancelButton.layer.cornerRadius = 8
        cancelButton.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        cancelButton.center = CGPoint(x: overlayView.bounds.midX, y: overlayView.bounds.midY + 50) // below label
        cancelButton.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        cancelButton.addTarget(self, action: #selector(cancelHUD), for: .touchUpInside)
        overlayView.addSubview(cancelButton)

        // Show overlay
        DispatchQueue.main.async {[weak self] in
            guard let self else { return }
            window.addSubview(self.overlayView)
            showLoader(withMessage: "Generating...")
        }
    }

    @objc func cancelHUD() {
        // Remove overlay and cancel any task
        DispatchQueue.main.async {[weak self] in
            guard let self else { return }
            SVProgressHUD.dismiss()
            self.overlayView.removeFromSuperview()
            comphy2APi.cancelRequests()
        }
    }
    
    func handleGenerate(jsonString: String, discoverName: String?) {
        guard let discoverDict else { return }
        self.discoverName = discoverName
        if navTitle == FeatureType.tatto_design.rawValue || navTitle == FeatureType.tatto_design_in_body.rawValue || navTitle == FeatureType.t_shirt_design.rawValue || navTitle == FeatureType.text_2_logo.rawValue || navTitle == FeatureType.text_2_sticker .rawValue {
            generateImage(jsonString: jsonString, discoverName: discoverName)
        } else {
            presentImagePicker()
        }
       
    }
    
    func generateImage(jsonString: String, discoverName: String?) {
        guard let jsonData = jsonString.data(using: .utf8) else { return }
            
        if let name = discoverName {
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(name).json")
            
                do {
                    try jsonData.write(to: tempURL)
                    //SVProgressHUD.setDefaultMaskType(.black)
                    showLoaderWithCancel()
                    comphy2APi.generateComphy2(jsonURL: tempURL){ [weak self] zipURL, error in
                        guard let self else { return }
                        DispatchQueue.main.async {[weak self] in
                            guard let self else { return }
                            overlayView.removeFromSuperview()
                        }
                        
                        hideLoader()
                        if let error {
                            showAlert(title: "Error!", message: error.localizedDescription)
                        } else if let zipURL {
                            
                            let fileManager = FileManager.default
                            guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
                                print("❌ Could not find documents directory")
                                return
                            }
                            
                            let rootFolderURL = documentsURL.appendingPathComponent("Comphy2DemoDiscovers")
                            let nameFolderURL = rootFolderURL.appendingPathComponent("\(name)_\(UUID().uuidString)")
                            
                            let success = SSZipArchive.unzipFile(atPath: zipURL.path, toDestination: nameFolderURL.path)
                            if success {
                                DispatchQueue.main.async { [weak self] in
                                    guard let self = self else { return }
                                    overlayView.removeFromSuperview()
                                    if let outputImageView = Bundle.main.loadNibNamed("OutputImageView", owner: nil, options: nil)?.first as? OutputImageView {
                                        outputImageView.frame = self.view.frame
                                        outputImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                                        
                                        if let files = try? FileManager.default.contentsOfDirectory(at: nameFolderURL, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles]),
                                           let firstImageURL = files.first(where: { $0.pathExtension.lowercased() == "png" || $0.pathExtension.lowercased() == "jpg" ||  $0.pathExtension.lowercased() == "jpeg"}) {
                                            let image = UIImage(contentsOfFile: firstImageURL.path)
                                            outputImageView.image = image
                                        }
                                        
                                        outputImageView.didPressSave = { [weak self] in
                                            guard let self else { return }
                                            if let image = outputImageView.image {
                                                self.saveImageToPhotos(image) { success, error in
                                                    if success {
                                                        self.showAlert(title: "Success!", message: "Image Saved")
                                                    } else {
                                                        self.showAlert(title: "Failed!", message: "Image couldnt be saved")
                                                        print("❌ Failed to save image: \(String(describing: error))")
                                                    }
                                                }
                                            }
                                            
                                        }
                                        
                                        outputImageView.didPressShareImage = { [weak self] in
                                            guard let self else { return }
                                            if let image = outputImageView.image {
                                                self.shareImage(image)
                                            }
                                        }
                                        
                                        DispatchQueue.main.async {[weak self] in
                                            guard let self else { return }
                                            self.view.addSubview(outputImageView)
                                        }
                                        
                                    }
                                }
                                    
                            } else {
                                showAlert(title: "Error!", message: "Unzipping file failed")
                            }
                        }
                    }


                } catch {
                    print("Failed to write JSON file: \(error)")
                    showAlert(title: "Failed to write JSON file", message: error.localizedDescription)
                }
            } else {
            showAlert(title: "Nil Found", message: "Discover name found nil")
        }
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
                Comphy2ApiRequest().fetchApiRequestModelFromJsonURL(from: jsonFileUrlString) {[weak self] jsonDict, jsonString, error in
                    guard let self else { return }
                    hideLoader()
                    if let jsonString {
                        DispatchQueue.main.async { [weak self] in
                            guard let self else { return }
                            self.discoverDict = jsonDict
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
                            
                                displayer.didPressGenerate = {
                                    [weak self] in
                                    guard let self else { return }
                                    handleGenerate(jsonString: jsonString, discoverName: discoverModels[indexPath.row].discoverName)
                                }
                                
                                displayer.didPressCopy = { [weak self] in
                                    guard let self else { return }
                                    handleSaveAndCopy(jsonString: jsonString, discoverName: discoverModels[indexPath.row].discoverName)
                                    
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



extension AIAvatarDiscoverListViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func presentImagePicker(isCamera: Bool = false) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = isCamera ? .camera : .photoLibrary
        if isCamera {
            imagePicker.cameraCaptureMode = .photo
        } else {
            imagePicker.mediaTypes = ["public.image"]
        }
        imagePicker.allowsEditing = false // or true if you want cropping
        
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let pickedImage = info[.originalImage] as? UIImage {
            discoverDict?["face_img"] = pickedImage.jpegData(compressionQuality: 1.0)?.base64EncodedString()
            if let discoverDict,
                   let jsonData = try? JSONSerialization.data(withJSONObject: discoverDict, options: []),
                   let jsonString = String(data: jsonData, encoding: .utf8) {

                    if let discoverName {
                        generateImage(jsonString: jsonString, discoverName: discoverName)
                    }
                }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
}

