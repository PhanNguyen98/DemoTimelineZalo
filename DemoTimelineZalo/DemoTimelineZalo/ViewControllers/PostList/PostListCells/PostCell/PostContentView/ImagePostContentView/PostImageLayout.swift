//
//  PostImageLayout.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 22/8/25.
//

import UIKit

class PostImageLayout: UICollectionViewLayout {
    private enum LayoutConstants {
        static let height1Item: CGFloat = 450
        static let height2Items: CGFloat = 400
        static let height3Items: CGFloat = 350
        static let height4or5Items: CGFloat = 450
        static let columnUnitDivisor: CGFloat = 5
    }

    var numberOfColumns: Int = 2
    var cellPadding: CGFloat = 8

    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0

    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        return collectionView.bounds.width - collectionView.contentInset.left - collectionView.contentInset.right
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }

    override func prepare() {
        guard let collectionView = collectionView else { return }
        cache.removeAll()
        contentHeight = 0

        let itemCount = collectionView.numberOfItems(inSection: 0)
        contentHeight = PostImageLayout.heightForItemCount(itemCount)
        
        switch itemCount {
        case 1:
            layoutFor1Item()
        case 2:
            layoutFor2Items()
        case 3:
            layoutFor3Items()
        case 4:
            layoutFor4Items()
        case 5:
            layoutFor5Items()
        default:
            break
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter { $0.frame.intersects(rect) }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
    static func heightForItemCount(_ count: Int) -> CGFloat {
        switch count {
        case 1:
            return LayoutConstants.height1Item
        case 2:
            return LayoutConstants.height2Items
        case 3:
            return LayoutConstants.height3Items
        case 4, 5:
            return LayoutConstants.height4or5Items
        default:
            return 0
        }
    }
    
    func layoutFor1Item() {
        let indexPath = IndexPath(item: 0, section: 0)
        let frame = CGRect(x: 0, y: 0, width: contentWidth, height: LayoutConstants.height1Item)
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = frame.insetBy(dx: 0, dy: 0)
        cache.append(attributes)
        return
    }
    
    func layoutFor2Items() {
        let columnWidth = (contentWidth - cellPadding) / 2
        for item in 0..<2 {
            let indexPath = IndexPath(item: item, section: 0)
            let xOffset: CGFloat = CGFloat(item) * columnWidth
            let frame = CGRect(x: xOffset == 0 ? 0 : xOffset + cellPadding,
                               y: 0,
                               width: columnWidth,
                               height: LayoutConstants.height2Items)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame.insetBy(dx: 0, dy: 0)
            cache.append(attributes)
        }
        return
    }
    
    func layoutFor3Items() {
        let columnWidthUnit = contentWidth / LayoutConstants.columnUnitDivisor
        let widthSmallItem = columnWidthUnit * 2
        let widthBigItem = columnWidthUnit * 3
        let heightSmallItem = (contentHeight - cellPadding * 3) / 2
        for item in 0..<3 {
            let indexPath = IndexPath(item: item, section: 0)
            switch item {
            case 0:
                let frame = CGRect(x: 0,
                                   y: 0,
                                   width: widthBigItem,
                                   height: contentHeight - cellPadding * 3)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                cache.append(attributes)
            case 1:
                let frame = CGRect(x: widthBigItem,
                                   y: cellPadding * 3,
                                   width: widthSmallItem,
                                   height: heightSmallItem)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                cache.append(attributes)
            case 2:
                let frame = CGRect(x: widthBigItem,
                                   y: cellPadding * 3 + heightSmallItem,
                                   width: widthSmallItem,
                                   height: heightSmallItem)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                cache.append(attributes)
            default:
                return
            }
        }
        return
    }
    
    func layoutFor4Items() {
        let widthItem = contentWidth / 2
        for item in 0..<4 {
            let indexPath = IndexPath(item: item, section: 0)
            switch item {
            case 0, 2:
                let yOffset = item == 0 ? 0 : widthItem
                let frame = CGRect(x: 0,
                                   y: yOffset,
                                   width: widthItem,
                                   height: widthItem)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                cache.append(attributes)
            case 1, 3:
                let yOffset = cellPadding * 4
                let frame = CGRect(x: widthItem,
                                   y: item == 1 ? yOffset : yOffset + widthItem,
                                   width: widthItem,
                                   height: widthItem)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                cache.append(attributes)
            default:
                break
            }
        }
        return
    }
    
    func layoutFor5Items() {
        let columnWidthUnit = contentWidth / LayoutConstants.columnUnitDivisor
        let widthSmallItem = columnWidthUnit * 2
        let heighSmallItem = contentHeight / 3
        let widthBigItem = columnWidthUnit * 3
        let heighBigItem = widthBigItem * 2 / 3
        for item in 0..<5 {
            let indexPath = IndexPath(item: item, section: 0)
            switch item {
            case 0, 2:
                let yOffset: CGFloat = item == 0 ? contentHeight / 2 - heighBigItem : contentHeight / 2
                let frame = CGRect(x: 0,
                                   y: yOffset,
                                   width: widthBigItem,
                                   height: heighBigItem)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                cache.append(attributes)
            case 1, 3, 4:
                let yOffset: CGFloat
                switch item {
                case 1:
                    yOffset = 0
                case 3:
                    yOffset = heighSmallItem
                case 4:
                    yOffset = heighSmallItem * 2
                default:
                    yOffset = 0
                }
                let frame = CGRect(x: widthBigItem,
                                   y: yOffset,
                                   width: widthSmallItem,
                                   height: heighSmallItem)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                cache.append(attributes)
            default:
                return
            }
        }
        return
    }
}
