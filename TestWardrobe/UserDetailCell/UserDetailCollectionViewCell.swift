//
//  UserDetailCollectionViewCell.swift
//  TestWardrobe
//
//  Created by Yogish M on 25/11/20.
//

import UIKit

class UserDetailCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var trialsLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width / 2
        self.profilePicture.clipsToBounds = true
    }
}
