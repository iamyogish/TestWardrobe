//
//  ViewController.swift
//  TestWardrobe
//
//  Created by Yogish M on 25/11/20.
//

import UIKit

class ViewController: UIViewController {

    static let sectionHeaderElementKind = "section-header-element-kind"
    static let productCellIdentifier = "product-cell"
    static let userCellIdentifier = "user-cell"
    static let sectionHeader = "section-header"

    typealias WardrobeCellProvider = UICollectionViewDiffableDataSource<Section, AnyHashable>.CellProvider
    typealias WardrobeSupplementaryViewProvider = UICollectionViewDiffableDataSource<Section, AnyHashable>.SupplementaryViewProvider

    enum Section: Int, CaseIterable {
        case userDetail
        case wardrobe
    }

    var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>! = nil
    var collectionView: UICollectionView! = nil
    private var selectedSection = 0
    private var products: [Product] = []

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
                                                      heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                // Group Description
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .estimated(120.0))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                               subitem: item, count: 1)
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
                group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .none, top: .fixed(2.0), trailing: .none, bottom: .fixed(2.0))

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

    func updateUI() {
        let items = self.getProducts()
        
        if #available(iOS 14, *) {
            var snapshot = dataSource.snapshot(for: .wardrobe)
            snapshot.deleteAll()
            snapshot.append(items)
            dataSource.apply(snapshot, to: .wardrobe, animatingDifferences: true, completion: nil)
        } else  if #available(iOS 13, *){
            var snapshot = dataSource.snapshot()
            snapshot.deleteItems(products)
            snapshot.appendItems(items, toSection: .wardrobe)
            dataSource.apply(snapshot)
        }
    }
}

extension ViewController {
    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        configureHierarchyForiOS13()
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.delegate = self
    }

    func configureHierarchyForiOS13() {
        if #available(iOS 13, *) {
            let userCellNib = UINib(nibName: "UserDetailCollectionViewCell", bundle: nil)
            let productCellNib = UINib(nibName: "ProductCollectionViewCell", bundle: nil)
            let sectionHeaderNib = UINib(nibName: "WardrobeSectionHeader", bundle: nil)
            collectionView.register(userCellNib,
                                    forCellWithReuseIdentifier: Self.userCellIdentifier)
            collectionView.register(productCellNib, 
                                    forCellWithReuseIdentifier: Self.productCellIdentifier)
            collectionView.register(sectionHeaderNib,
                                    forSupplementaryViewOfKind: Self.sectionHeaderElementKind,
                                    withReuseIdentifier: Self.sectionHeader)
        }
    }

    func configureDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()

        if #available(iOS 14, *) {
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
            let supplementaryRegistration = UICollectionView.SupplementaryRegistration(supplementaryNib: headerNib, elementKind: "Header") { [weak self]  (supplementaryView, string, indexpath) in
                if let headerView = supplementaryView as? WardrobeSectionHeader {
                    guard let self = self else { return }
                    headerView.sectionSelector.addTarget(self, action: #selector(self.didChangeSection(_:)), for: .valueChanged)
                }
            }

            dataSource.supplementaryViewProvider = { (view, kind, index) in
                return self.collectionView.dequeueConfiguredReusableSupplementary(using: supplementaryRegistration, for: index)
            }
        } else {
            let cellProvider: WardrobeCellProvider =  { (collectionView, indexPath, item) -> UICollectionViewCell? in
                if let user = item as? User {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.userCellIdentifier,
                                                                  for: indexPath) as? UserDetailCollectionViewCell
                    cell?.configure(user)
                    return cell
                } else if let productItem = item as? Product {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.productCellIdentifier,
                                                                  for: indexPath) as? ProductCollectionViewCell
                    cell?.configure(productItem)
                }
                return nil
            }

            let supplementaryViewProvider: WardrobeSupplementaryViewProvider =  { (collectionView, kind, indexpath) -> UICollectionReusableView? in
                let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Self.sectionHeader, for: indexpath)
                return supplementaryView
            }

            dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: collectionView, cellProvider: cellProvider)
            dataSource.supplementaryViewProvider = supplementaryViewProvider
        }

        Section.allCases.forEach {
            snapshot.appendSections([$0])
            if $0 == .userDetail {
                snapshot.appendItems([1])
            }

            if $0 == .wardrobe {
                let items = getProducts()
                snapshot.appendItems(items)
            }
        }

        dataSource.apply(snapshot)
    }

    @objc func didChangeSection(_ segmentControl: UISegmentedControl) {
        if selectedSection != segmentControl.selectedSegmentIndex {
            selectedSection = segmentControl.selectedSegmentIndex
            updateUI()
        }
    }

    internal func getProducts() -> [Product] {
        self.products.removeAll()
        let products = Array(1...99).map {
            Product(name: "Product\($0)", image: "Item\(Int.random(in: 1...6))")
        }
        self.products = products
        return products
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}

