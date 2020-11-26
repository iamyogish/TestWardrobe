//
//  UserDetailCollectionViewCell.swift
//  TestWardrobe
//
//  Created by Yogish M on 25/11/20.
//

import UIKit

internal struct User: Hashable {
    let name: String
    let followersCount: String
    let followingCount: String
    let trailsCount: String
    let profileImage: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(profileImage)
    }
}

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

    internal func configure(_ user: User) {
        nameLabel.text = user.name
        followersLabel.text = user.followersCount
        followingLabel.text = user.followingCount
        trialsLabel.text = user.trailsCount
        profilePicture.image = UIImage(named: user.profileImage)
    }
}
