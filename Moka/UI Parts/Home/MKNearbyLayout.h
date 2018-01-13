//
//  MKNearbyLayout.h
//  Moka
//
//  Created by Knight on 2017/7/22.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKNearbyLayout : UICollectionViewFlowLayout

/** 每一列的最大Y值 */
@property (nonatomic, strong) NSMutableArray *columnMaxYs;
/** 存放所有cell的布局属性 */
@property (nonatomic, strong) NSMutableArray *attrsArray;

@property (nonatomic, readonly) CGFloat maxColumnHeight;

@end
