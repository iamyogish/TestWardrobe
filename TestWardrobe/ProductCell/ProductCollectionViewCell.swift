//
//  ProductCollectionViewCell.swift
//  TestWardrobe
//
//  Created by Yogish M on 25/11/20.
//

import UIKit

struct Product: Hashable {
    let name: String
    let image: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(image)
    }

    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.name == rhs.name && lhs.image == rhs.image
    }
}

class ProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    internal func configure(_ product: Product) {
        productImageView.image = UIImage(named: product.image)
    }
}
