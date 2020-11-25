//
//  ViewController.swift
//  TestWardrobe
//
//  Created by Yogish M on 25/11/20.
//

import UIKit

class ViewController: UIViewController {

    static let sectionHeaderElementKind = "section-header-element-kind"

    enum Section: Int, CaseIterable {
        case userDetail
        case wardrobe
    }

    var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>! = nil
    var collectionView: UICollectionView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
    }
}

extension ViewController {
    func createLayout() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()

        let layout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            guard let sectionKind = Section(rawValue: sectionIndex) else { fatalError("Unidentified Section") }

            if sectionKind == .userDetail {
                // Item description
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalWidth(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                // Group Description
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .fractionalWidth(0.8))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                               subitems: [item])
                // Section description
                let section = NSCollectionLayoutSection(group: group)

                return section
            } else if sectionKind == .wardrobe {
                // Item Description
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                // Group Description
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .absolute(160))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                               subitem: item,
                                                               count: 2)
                group.interItemSpacing = .fixed(CGFloat(2))

                // Section Header Description
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .estimated(44)),
                    elementKind: ViewController.sectionHeaderElementKind,
                    alignment: .top)
                sectionHeader.pinToVisibleBounds = true
                sectionHeader.zIndex = 2

                // Section Description
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                section.boundarySupplementaryItems = [sectionHeader]

                return section
            }

            return nil
        }, configuration: config)

        return layout
    }
}

extension ViewController {
    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.delegate = self
    }

    func configureDataSource() {
        let userCellNib = UINib(nibName: "UserDetailCollectionViewCell", bundle: nil)
        let userDetailCellRegistration = UICollectionView.CellRegistration<UserDetailCollectionViewCell, Int>(cellNib: userCellNib) { (cell, indexPath, identifier) in
            cell.profilePicture.image = UIImage(named: "MaryJane")
            cell.nameLabel.text = "Mary Jane"
            cell.followersLabel.text = "304"
            cell.followingLabel.text = "825"
            cell.trialsLabel.text = "1"
        }

        let productCellNib = UINib(nibName: "ProductCollectionViewCell", bundle: nil)
        let productCellRegistration = UICollectionView.CellRegistration<ProductCollectionViewCell, Product>(cellNib: productCellNib) { (cell, indexpath, item) in
            cell.productImageView.image = UIImage(named: item.image)
        }

        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            if let userSection = item as? Int {
                let cell = collectionView.dequeueConfiguredReusableCell(using: userDetailCellRegistration, for: indexPath, item: userSection)
                return cell
            } else if let productItem = item as? Product {
                let  cell = collectionView.dequeueConfiguredReusableCell(using: productCellRegistration, for: indexPath, item: item as? Product)
                cell.productImageView.image = UIImage(named: productItem.image)
                return cell
            }

            fatalError()
        }

        let headerNib = UINib(nibName: "WardrobeSectionHeader", bundle: nil)
        let supplementaryRegistration = UICollectionView.SupplementaryRegistration(supplementaryNib: headerNib, elementKind: "Header") { (supplementaryView, string, indexpath) in
            // Do Nothing
        }

        dataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: supplementaryRegistration, for: index)
        }

        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        Section.allCases.forEach {
            snapshot.appendSections([$0])
            if $0 == .userDetail {
                snapshot.appendItems([1])
            }

            if $0 == .wardrobe {
                let products = Array(1...6).map {
                    Product(name: "Product\($0)", image: "Item\($0)")
                }
                snapshot.appendItems(products)
            }
        }

        dataSource.apply(snapshot)
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}

