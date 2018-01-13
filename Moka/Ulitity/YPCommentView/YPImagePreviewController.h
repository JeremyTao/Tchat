//
//  YPImagePreviewController.h
//  YPCommentDemo
//
//  Created by 朋 on 16/7/21.
//  Copyright © 2016年 杨朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YPImagePreviewController : UIViewController
@property (nonatomic,strong) NSArray * images;
@property (nonatomic) NSInteger index;
@end


@interface UIImage (MyBundle)

+ (UIImage *)imageNamedFromMyBundle:(NSString *)name;

@end