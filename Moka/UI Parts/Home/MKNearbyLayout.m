//
//  MKNearbyLayout.m
//  Moka
//
//  Created by Knight on 2017/7/22.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKNearbyLayout.h"

#define WFCollectionWidth self.collectionView.frame.size.width
/** 每一行之间的间距 */
static const CGFloat WFDefaultRowMargin = 10;
/** 每一列之间的间距 */
static const CGFloat WFDefaultColumnMargin = 10;
/** 每一列之间的间距 top, left, bottom, right */
static const UIEdgeInsets WFDefaultInsets = {0, 10, 10, 10};
/** 默认的列数 */
static const int WFDefaultColumsCount = 3;

@implementation MKNearbyLayout

#pragma mark - 懒加载
- (NSMutableArray *)columnMaxYs
{
    if (!_columnMaxYs) {
        _columnMaxYs = [[NSMutableArray alloc] init];
    }
    return _columnMaxYs;
}

- (NSMutableArray *)attrsArray
{
    if (!_attrsArray) {
        _attrsArray = [[NSMutableArray alloc] init];
    }
    return _attrsArray;
}

#pragma mark - 实现内部的方法
/**
 * 决定了collectionView的contentSize
 */
- (CGSize)collectionViewContentSize
{
    // 找出最长那一列的最大Y值
    CGFloat destMaxY = [self.columnMaxYs[0] doubleValue];
    for (NSUInteger i = 1; i < self.columnMaxYs.count; i++) {
        // 取出第i列的最大Y值
        CGFloat columnMaxY = [self.columnMaxYs[i] doubleValue];
        
        // 找出数组中的最大值
        if (destMaxY < columnMaxY) {
            destMaxY = columnMaxY;
        }
    }
    _maxColumnHeight = destMaxY;
    return CGSizeMake(0, destMaxY + WFDefaultInsets.bottom);
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    // 重置每一列的最大Y值
    [self.columnMaxYs removeAllObjects];
    for (NSUInteger i = 0; i < WFDefaultColumsCount; i++) {
        [self.columnMaxYs addObject:@(WFDefaultInsets.top)];
    }
    
    // 计算所有cell的布局属性
    [self.attrsArray removeAllObjects];
    NSUInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSUInteger i = 0; i < count; ++i) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArray addObject:attrs];
    }
}

/**
 * 说明所有元素（比如cell、补充控件、装饰控件）的布局属性
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrsArray;
}

/**
 * 说明cell的布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    /** 计算indexPath位置cell的布局属性 */
    
    // 水平方向上的总间距
    CGFloat xMargin = WFDefaultInsets.left + WFDefaultInsets.right + (WFDefaultColumsCount - 1) * WFDefaultColumnMargin;
    // cell的宽度
    CGFloat w = (WFCollectionWidth - xMargin) / WFDefaultColumsCount;
    // cell的高度
    CGFloat h = 0;
    
    
    if (indexPath.row > 0 && (indexPath.row - 1) % 3 == 0) {
        h = w + 60;
    } else {
        h = w + 30;
    }
    
    // 找出最短那一列的 列号 和 最大Y值
    CGFloat destMaxY = [self.columnMaxYs[0] doubleValue];
    NSUInteger destColumn = 0;
    for (NSUInteger i = 1; i<self.columnMaxYs.count; i++) {
        // 取出第i列的最大Y值
        CGFloat columnMaxY = [self.columnMaxYs[i] doubleValue];
        
        // 找出数组中的最小值
        if (destMaxY > columnMaxY) {
            destMaxY = columnMaxY;
            destColumn = i;
        }
    }
    
    // cell的x值
    CGFloat x = WFDefaultInsets.left + destColumn * (w + WFDefaultColumnMargin);
    // cell的y值
    CGFloat y = destMaxY + WFDefaultRowMargin;
    // cell的frame
    attrs.frame = CGRectMake(x, y, w, h);
    
    // 更新数组中的最大Y值
    self.columnMaxYs[destColumn] = @(CGRectGetMaxY(attrs.frame));
    
    return attrs;
}

//- (UICollectionViewLayoutAttributes*)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
//{
//    UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
//
//    attr.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0.2, 0.2), M_PI);
//    attr.center = CGPointMake(CGRectGetMidX(self.collectionView.bounds), CGRectGetMaxY(self.collectionView.bounds));
//
//    return attr;
//}
//
//- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
//{
//    CGRect oldBounds = self.collectionView.bounds;
//    if (!CGSizeEqualToSize(oldBounds.size, newBounds.size)) {
//        return YES;
//    }
//
//    return NO;
//}

@end
