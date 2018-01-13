//
//  YPCollectionViewFlowLayout.h
//  YPCommentDemo
//
//  Created by 朋 on 16/7/22.
//  Copyright © 2016年 杨朋. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YPCollectionViewFlowLayout;
@protocol YPwaterFlowLayoutDelegate <NSObject>

-(CGFloat)YPwaterFlowLayout:(YPCollectionViewFlowLayout*)waterFlow HeightForWidth:(CGFloat)width atIndexPath:(NSIndexPath*)indexPach;

@end
@interface YPCollectionViewFlowLayout : UICollectionViewLayout

@property(nonatomic,assign)UIEdgeInsets sectionInset;
@property(nonatomic,assign)CGFloat rowMagrin;
@property(nonatomic,assign)CGFloat colMagrin;
@property(nonatomic,assign)CGFloat colCount;
@property(nonatomic,weak)id<YPwaterFlowLayoutDelegate>degelate;
@end
