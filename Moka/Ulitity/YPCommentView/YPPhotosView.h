//
//  YPPhotosView.h
//  YPCommentDemo
//
//  Created by 朋 on 16/7/21.
//  Copyright © 2016年 杨朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol backHeightDelegater <NSObject>

-(void)uplodeMyH:(CGFloat)myH;
@end

typedef void(^visitCameraBlock)();
typedef void(^removeImageBlock)(NSInteger index);

@protocol YPPhotosViewDelegate <NSObject>

- (void)didSelectPhotoAtIndexRow:(NSInteger)index;

@end


@interface YPPhotosView : UIView
@property (nonatomic,weak) id<backHeightDelegater> myHDelegaher;
@property (nonatomic,weak) id<YPPhotosViewDelegate> myPhotoDelegate;
/**存放图片的数组*/
@property (nonatomic,strong) NSArray *photoArray;
@property (nonatomic,strong) UICollectionView *collectionView ;

/**调用相册*/
@property (nonatomic,copy) visitCameraBlock clickChooseView;
@property (nonatomic,copy) removeImageBlock clickcloseImage;

@property (nonatomic,copy) void(^clicklookImage)(NSInteger tag , NSArray *imageArr);
@property (nonatomic,copy) void(^clickHiddenKeyBoard)();
/// 外部API 选择图片完成是调用
- (void)setYPPhotosView:(NSArray *)photoArray ;
-(void)setImg:(NSArray *)arr;
- (void)deleteImageAtIndex:(NSInteger)index;

@end
