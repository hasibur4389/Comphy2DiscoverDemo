//
//  ViewController.swift
//  Comphy2DiscoverDemo
//
//  Created by Bcl Dey Device 8 on 24/9/25.
//

import UIKit
import SVProgressHUD

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var allDataComphy2: AllDataModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        showLoader(withMessage: "Fetching Comphy2 All Data...")
        Comphy2ApiRequest().getAllDataByApplicationID { [weak self] allDataModel, error in
            guard let self else { return }
            hideLoader()
            if error == nil {
                allDataComphy2 = allDataModel
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    tableView.reloadData()
                }
            } else {
                self.showAlert(title: "Error!", message: error!.localizedDescription)

            }
        }
    
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("row count")
        return allDataComphy2?.features?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SimpleCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ?? UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        if let aFeature = allDataComphy2?.features?[indexPath.row] {
            cell.textLabel?.text = aFeature.name
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Comphy 2.0"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .systemBlue
        label.textAlignment = .center
        label.backgroundColor = .systemGroupedBackground
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // TODO: 44*UIScreen.wdit
        return 44
    }
    
    func presentDiscoverListVC(_ responseModel: TagsResponseModel?, indexPath: IndexPath) {
        if let discoverListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AIAvatarDiscoverListViewController") as? AIAvatarDiscoverListViewController {
            guard let responseModel = responseModel else {
                print("tagsResponseModel is nil")
                return
            }
            
            if let tags = responseModel.tags, let discoverArr = responseModel.discoverArr {
                for tag in tags {
                    tag.mapDiscoverModels(from: discoverArr)
                }
            }
            discoverListVC.tagsDiscoverModel = responseModel
            if let aFeature = allDataComphy2?.features?[indexPath.row] {
                discoverListVC.navTitle  = aFeature.name ?? ""
            }
            DispatchQueue.main.async {[weak self] in
                guard let self else { return }
                self.navigationController?.pushViewController(discoverListVC, animated: true)
            }
        }
    }
    
     func callTagsDiscoverApi(_ featureID: String, _ indexPath: IndexPath) {
        showLoader(withMessage: "Loading Disocover Data...")
        Comphy2ApiRequest().getAllDiscoverAndTagsByApplicationIDAndFeatureID(featureID: featureID) { [weak self] responseModel, error in
            guard let self else { return }
            hideLoader()
            if let error = error {
                DispatchQueue.main.async {
                    self.showAlert(title: "Error!", message: error.localizedDescription)
                }
                print("error: \(error)")
                return
            } else {
                presentDiscoverListVC(responseModel, indexPath: indexPath)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let aFeature = allDataComphy2?.features?[indexPath.row], let featureID = aFeature._id {
            //callTagsDiscoverApi(featureID, indexPath)
            // First Alert (Yes/No)
            let firstAlert = UIAlertController(
                title: "Confirm",
                message: "Get discover(s) for a specific tag?",
                preferredStyle: .alert
            )
            
            // No action
            firstAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { [weak self] _ in
                // Do something else when user taps No
                print("User tapped No - doing something else")
                self?.callTagsDiscoverApi(featureID, indexPath)
            }))
            
            // Yes action → show second alert with input
            firstAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
                let secondAlert = UIAlertController(
                    title: "Input Required",
                    message: "Enter tagName",
                    preferredStyle: .alert
                )
                
                secondAlert.addTextField { textField in
                    textField.placeholder = "Type something..."
                }
                
                secondAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                    print("User cancelled input")
                }))
                
                secondAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    let userInput = secondAlert.textFields?.first?.text ?? ""
                    
                    //TODO: MAKE API call using the tag name and feature id
                }))
                
                self.present(secondAlert, animated: true)
            }))
            
            self.present(firstAlert, animated: true)
        } else {
            print("Error: DidSelect Selected Feature information missing")
            DispatchQueue.main.async {
                self.showAlert(title: "Error!", message: "Selected Feature information missing")
            }
            
        }
    }
    
}
