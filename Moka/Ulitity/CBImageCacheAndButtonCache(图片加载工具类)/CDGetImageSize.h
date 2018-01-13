//
//  CDGetImageSize.h
//  Exercise
//
//  Created by 郑克 on 16/2/19.
//  Copyright © 2016年 sanfenqiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDGetImageSize : NSObject
/**
 *  图片处理
 *
 *  @param NSURL NSURL description
 *
 *  @return return value description
 */
#pragma mark - Api functions static

+ (NSURL *)getUpsImageUrl:(NSString *)originalImageUrl withCGSize:(CGSize)size;



+ (NSURL *)getupsLowImageUrl:(NSString *)originalImageUrl withCGSize:(CGSize)size;
@end
