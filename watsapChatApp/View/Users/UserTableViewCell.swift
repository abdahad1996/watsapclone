//
//  UserTableViewCell.swift
//  watsapChatApp
//
//  Created by prog on 8/16/19.
//  Copyright © 2019 prog. All rights reserved.
//

import UIKit


protocol UserTableViewCellDelegate {
    func didTapAvatarImage(indexPath: IndexPath)
}


class UserTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    
    var indexPath: IndexPath!
    var delegate: UserTableViewCellDelegate?
    
    
    let tapGestureRecognizer = UITapGestureRecognizer()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tapGestureRecognizer.addTarget(self, action: #selector(self.avatarTap))
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
    //
    func generateCellWith(fUser: FUser, indexPath: IndexPath) {
        
        self.indexPath = indexPath
        
        self.fullNameLabel.text = fUser.fullname
        //check if avatar is not nill
        if fUser.avatar != "" {
            // create image from string
            imageFromData(pictureData: fUser.avatar) { (avatarImage) in
                //checks if image is not nill and also rounds the image
                if avatarImage != nil {
                    self.avatarImageView.image = avatarImage!.circleMasked
                }
            }
        }
        
    }
    
    
    @objc func avatarTap() {
        print("avatar")
//        delegate!.didTapAvatarImage(indexPath: indexPath)
    }
    
    
}

