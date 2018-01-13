//
//  MKTool.h
//  Moka
//
//  Created by Knight on 2017/7/20.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MKTool : NSObject

/**
 *  判断电话号码的长度
 *
 *  @param phoneNumber 11
 *
 *  @return bool
 */
+ (BOOL)checkPhoneNumber:(NSString *)phoneNumber;



/**检查电话号码格式*/
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

+ (NSString *)md5_passwordEncryption:(NSString *)password;

+ (NSString*)md532BitUpper:(NSString *)url;

//给View加投影
+ (void)addGrayShadowAboveOnView:(UIView *)view;
+ (void)addShadowOnView:(UIView *)view;
+ (void)addGrayShadowOnView:(UIView *)view;
+ (void)removeShadowOnView:(UIView *)view;
@end
