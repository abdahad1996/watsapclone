//
//  UserTableViewController.swift
//  watsapChatApp
//
//  Created by prog on 8/16/19.
//  Copyright © 2019 prog. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD

class UsersTableViewController: UITableViewController, UISearchResultsUpdating
//UserTableViewCellDelegate
{
    
    
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var filterSegmentedControll: UISegmentedControl!
    
    
    var allUsers: [FUser] = []
    var filteredUsers: [FUser] = []
    var allUsersGroupped = NSDictionary() as! [String : [FUser]]
    var sectionTitleList : [String] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = "Users"
        navigationItem.largeTitleDisplayMode = .never
        tableView.tableFooterView = UIView()
//
        navigationItem.searchController = searchController

        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = false

        loadUsers(filter: kCITY)
    }
    
    // MARK: - Table view data source
    
    // if searchcontroller is active return only 1 section otherwise return sections grouped by alphabetical order
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            return 1
        } else {
            return sectionTitleList.count
        }
        
    }
    
    // if searchcontroller is active returned filter arrays count otherwise
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            
            return filteredUsers.count
            
        } else {
            
            //find section Title such as A
            let sectionTitle = self.sectionTitleList[section]
            
            //user for given title means how many users are in alphabet A so that many rows
            let users = self.allUsersGroupped[sectionTitle]
            
            return users!.count
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UserTableViewCell
        
        
        var user: FUser
        //if search  is active we get filtered user and set it dynamically
        if searchController.isActive && searchController.searchBar.text != "" {
            
            user = filteredUsers[indexPath.row]
        }
        //otherwise get user of a particular section and set it
        else {
            
            let sectionTitle = self.sectionTitleList[indexPath.section]
            
            let users = self.allUsersGroupped[sectionTitle]
            
            user = users![indexPath.row]
        }
        
        
        
        cell.generateCellWith(fUser: user, indexPath: indexPath)
//        cell.delegate = self
        
        return cell
    }
    
    
    //MARK: TableView Delegate
    
    // title for header of our section
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // if user is searching we return no section title as there is only 1 section
        if searchController.isActive && searchController.searchBar.text != "" {
            return ""
        }
        // otheweise we use sectionTitleList array to get title for every index
        else {
            return sectionTitleList[section]
        }
    }
    
    // return indextitles in the righthand side list and this can help us to jump to any user by touching it
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            return nil
        } else {
            return self.sectionTitleList
        }
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        
        return index
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        tableView.deselectRow(at: indexPath, animated: true)
//
//        var user: FUser
//
//        if searchController.isActive && searchController.searchBar.text != "" {
//
//            user = filteredUsers[indexPath.row]
//        } else {
//
//            let sectionTitle = self.sectionTitleList[indexPath.section]
//
//            let users = self.allUsersGroupped[sectionTitle]
//
//            user = users![indexPath.row]
//        }
//
//        if !checkBlockedStatus(withUser: user) {
//
//            let chatVC = ChatViewController()
//            chatVC.titleName = user.firstname
//            chatVC.membersToPush = [FUser.currentId(), user.objectId]
//            chatVC.memberIds = [FUser.currentId(), user.objectId]
//            chatVC.chatRoomId = startPrivateChat(user1: FUser.currentUser()!, user2: user)
//
//            chatVC.isGroup = false
//            chatVC.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(chatVC, animated: true)
//
//
//        } else {
//            ProgressHUD.showError("This user is not available for chat!")
//        }
//
//    }
//
    //load from firestore with filter suppose filter is mycity so load all users of mycity in allusers array
    func loadUsers(filter: String) {

        ProgressHUD.show()

        var query: Query!

        switch filter {
            // make query so to load only user documents  with same city as current user
        case kCITY:
            query = reference(.User).whereField(kCITY, isEqualTo: FUser.currentUser()!.city).order(by: kFIRSTNAME, descending: false)
            
            // make query so to load only user documents with same country as current user

        case kCOUNTRY:
            query = reference(.User).whereField(kCOUNTRY, isEqualTo: FUser.currentUser()!.country).order(by: kFIRSTNAME, descending: false)
        default:
            query = reference(.User).order(by: kFIRSTNAME, descending: false)
        }

        query.getDocuments { (snapshot, error) in
            //empty all arrays for new fetches so they dont append to old fetches
            self.allUsers = []
            self.sectionTitleList = []
            self.allUsersGroupped = [:]
            //show empty list if error
            if error != nil {
                print(error!.localizedDescription)
                ProgressHUD.dismiss()
                self.tableView.reloadData()
                return
            }
            //snaphsot of all user documents
            guard let snapshot = snapshot else {
                ProgressHUD.dismiss(); return
            }
            //if no users den show empty list
            if !snapshot.isEmpty {
//              loop over user documents and give it to fuser intializer and append to array
                for userDictionary in snapshot.documents {

                    let userDictionary = userDictionary.data() as NSDictionary
                    let fUser = FUser(_dictionary: userDictionary)

                    if fUser.objectId != FUser.currentId() {
                        self.allUsers.append(fUser)
                    }
                }

                //split data into sections such as all users starting from A to A section and B to B section
                self.splitDataIntoSection()
                self.tableView.reloadData()
            }

            self.tableView.reloadData()
            ProgressHUD.dismiss()

        }

    }

    
   // MARK: IBActions
    
    @IBAction func filterSegmentValueChanged(_ sender: UISegmentedControl) {

        switch sender.selectedSegmentIndex {
        case 0:
            loadUsers(filter: kCITY)
        case 1:
            loadUsers(filter: kCOUNTRY)
        case 2:
            loadUsers(filter: "")
        default:
            return
        }

    }
    
    
    //MARK: Search controller functions
        //filter on search text
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        
        filteredUsers = allUsers.filter({ (user) -> Bool in
            
            return user.firstname.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    // delegate function
    func updateSearchResults(for searchController: UISearchController) {
        
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    //MARK: Helper functions
    // for eg suppise there is a user andrew we get A from it and append it in sectiontitlelist and
    // also we add all users starting from A to its own array and similary all users starting from b to its own array
    fileprivate func splitDataIntoSection() {
        
        var sectionTitle: String = ""
        
        for i in 0..<self.allUsers.count {
            //current user
            let currentUser = self.allUsers[i]
            //get first character of current user
            let firstChar = currentUser.firstname.first!
            //convert it into string
            let firstCarString = "\(firstChar)"
            
            // if andy and andrew den we don't make firstchar again since both are A
            if firstCarString != sectionTitle {
                
                sectionTitle = firstCarString
                //create dic with key sectiontitle which is firstchar for eg A and value of array of fusers
                self.allUsersGroupped[sectionTitle] = []
                // if sectiontitlelist doesnt contain firstchar already for eg A den append it to it
                if !sectionTitleList.contains(sectionTitle) {
                    self.sectionTitleList.append(sectionTitle)
                }
            }
            
            self.allUsersGroupped[firstCarString]?.append(currentUser)
            
        }
        
    }
    
    
    //MARK: UserTableViewCellDelegate
    
//    func didTapAvatarImage(indexPath: IndexPath) {
//
//        let profileVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profileView") as! ProfileViewTableViewController
//
//        var user: FUser
//
//        if searchController.isActive && searchController.searchBar.text != "" {
//
//            user = filteredUsers[indexPath.row]
//        } else {
//
//            let sectionTitle = self.sectionTitleList[indexPath.section]
//
//            let users = self.allUsersGroupped[sectionTitle]
//
//            user = users![indexPath.row]
//        }
//
//        profileVC.user = user
//        self.navigationController?.pushViewController(profileVC, animated: true)
//    }
//
    
    
}

