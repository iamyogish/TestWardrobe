//
//  WardrobeSectionHeader.swift
//  TestWardrobe
//
//  Created by Yogish M on 25/11/20.
//

import UIKit

class WardrobeSectionHeader: UICollectionReusableView {

    @IBOutlet weak var sectionSelector: UISegmentedControl!

    class func instanceFromNib() -> WardrobeSectionHeader {
            let view = UINib(nibName: "WardrobeSectionHeader", bundle: nil)
                .instantiate(withOwner: nil, options: nil)[0] as! WardrobeSectionHeader
            return view
    }
}
