//
//  SettingsTableViewController.swift
//  watsapChatApp
//
//  Created by prog on 8/16/19.
//  Copyright © 2019 prog. All rights reserved.
//

import UIKit
import ProgressHUD

class SettingsTableViewController: UITableViewController {
    
    
//    @IBOutlet weak var avatarImageView: UIImageView!
//    @IBOutlet weak var fullNameLabel: UILabel!
//    @IBOutlet weak var deleteButtonOutlet: UIButton!
//    @IBOutlet weak var showAvatarStatusSwitch: UISwitch!
//
//    @IBOutlet weak var versionLabel: UILabel!
//    let userDefaults = UserDefaults.standard
//
//    var avatarSwitchStatus = false
//    var firstLoad: Bool?
    
    
    override func viewDidAppear(_ animated: Bool) {
//        if FUser.currentUser() != nil {
//            setupUI()
//            loadUserDefaults()
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.tableFooterView = UIView()
        
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 5
        }
        return 2
    }
    
    //MARK: TableViewDelegate
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 0
        }
        
        return 30
    }
    
    //MARK: IBActions
    
//    @IBAction func cleanCacheButtonPressed(_ sender: Any) {
//
//        do {
//            let files = try FileManager.default.contentsOfDirectory(atPath: getDocumentsURL().path)
//
//            for file in files {
//                try FileManager.default.removeItem(atPath: "\(getDocumentsURL().path)/\(file)")
//            }
//
//            ProgressHUD.showSuccess("Cache cleaned.")
//        } catch {
//            ProgressHUD.showError("Couldnt clean Media files.")
//        }
//    }
    
    
//    @IBAction func showAvatartSwithValueChanged(_ sender: UISwitch) {
//
//        avatarSwitchStatus = sender.isOn
//
//        saveUserDefaults()
//    }
    
//    @IBAction func tellAFriendButtonPressed(_ sender: Any) {
//
//        let text = "Hey! Lets chat on iChat \(kAPPURL)"
//
//        let objectsToShare:[Any] = [text]
//
//        let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
//
//        activityViewController.popoverPresentationController?.sourceView = self.view
//
//        activityViewController.setValue("Lets Chat on iCHat", forKey: "subject")
//
//        self.present(activityViewController, animated: true, completion: nil)
//    }
//
    
    
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        
        FUser.logOutCurrentUser { (success) in
            
            if success {
                self.showLoginView()
            }
            
        }
        
    }
    
    
//    @IBAction func deleteAccountButtonPressed(_ sender: Any) {
//
//        let optionMenu = UIAlertController(title: "Delete Account", message: "Are you sure you want to delete tje account?", preferredStyle: .actionSheet)
//
//        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (alert) in
//
//            self.deleteUser()
//        }
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in
//
//        }
//
//        optionMenu.addAction(deleteAction)
//        optionMenu.addAction(cancelAction)
//
//        //for iPad not to crash
//        if ( UI_USER_INTERFACE_IDIOM() == .pad )
//        {
//            if let currentPopoverpresentioncontroller = optionMenu.popoverPresentationController{
//
//                currentPopoverpresentioncontroller.sourceView = deleteButtonOutlet
//                currentPopoverpresentioncontroller.sourceRect = deleteButtonOutlet.bounds
//
//                currentPopoverpresentioncontroller.permittedArrowDirections = .up
//                self.present(optionMenu, animated: true, completion: nil)
//            }
//        }else{
//            self.present(optionMenu, animated: true, completion: nil)
//        }
//
//    }
    
    
    func showLoginView() {
        
        let mainView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "welcome")
        
        self.present(mainView, animated: true, completion: nil)
    }
    
    
    //MARK: SetupUI
    
//    func setupUI() {
//
//        let currentUser = FUser.currentUser()!
//
//        fullNameLabel.text = currentUser.fullname
//
//        if currentUser.avatar != "" {
//
//            imageFromData(pictureData: currentUser.avatar) { (avatarImage) in
//
//                if avatarImage != nil {
//                    self.avatarImageView.image = avatarImage!.circleMasked
//                }
//            }
//        }
//
//        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
//            versionLabel.text = version
//        }
//    }
    
    //MARK: Delete user
    
//    func deleteUser() {
//
//        //delet locally
//        userDefaults.removeObject(forKey: kPUSHID)
//        userDefaults.removeObject(forKey: kCURRENTUSER)
//        userDefaults.synchronize()
//
//        //delete from firebase
//        reference(.User).document(FUser.currentId()).delete()
//
//        FUser.deleteUser { (error) in
//
//            if error != nil {
//
//                DispatchQueue.main.async {
//                    ProgressHUD.showError("Couldnt delete use")
//                }
//                return
//            }
//
//            self.showLoginView()
//        }
//    }
//
    
    //MARK: UserDefaults
    
//    func saveUserDefaults() {
//        
//        userDefaults.set(avatarSwitchStatus, forKey: kSHOWAVATAR)
//        userDefaults.synchronize()
//    }
//    
//    func loadUserDefaults() {
//        
//        firstLoad = userDefaults.bool(forKey: kFIRSTRUN)
//        
//        if !firstLoad! {
//            userDefaults.set(true, forKey: kFIRSTRUN)
//            userDefaults.set(avatarSwitchStatus, forKey: kSHOWAVATAR)
//            userDefaults.synchronize()
//        }
//        
//        avatarSwitchStatus = userDefaults.bool(forKey: kSHOWAVATAR)
//        showAvatarStatusSwitch.isOn = avatarSwitchStatus
//    }
    
    
}

