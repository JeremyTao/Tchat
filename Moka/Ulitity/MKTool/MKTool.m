//
//  MKTool.m
//  Moka
//
//  Created by Knight on 2017/7/20.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKTool.h"
#import<CommonCrypto/CommonDigest.h>


@implementation MKTool

+ (NSString*)md532BitUpper:(NSString *)url
{
    const char *cStr = [url UTF8String];
    
    unsigned char result[16];
    
    NSNumber *num = [NSNumber numberWithUnsignedLong:strlen(cStr)];
    
    CC_MD5( cStr,[num intValue], result );
    
    return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
    
}


+ (BOOL)checkPhoneNumber:(NSString *)phoneNumber
{
    if(phoneNumber == nil || phoneNumber.length != 11 || [phoneNumber characterAtIndex:0] != '1') return NO;
    
    for(int n=0; n<phoneNumber.length; n++)
    {
        unichar c = [phoneNumber characterAtIndex:n];
        if(c>='0' && c<='9') continue;
        
        return NO;
    }
    
    return YES;
}

+ (NSString *)md5_passwordEncryption:(NSString *)password {
    NSString *firstEncryptionStr = [self md532BitUpper:password];
    NSString *tempStr = [NSString stringWithFormat:@"moka%@",firstEncryptionStr];
    NSString *md5_passWord = [self md532BitUpper:tempStr];
    return md5_passWord;
    
}


//正则判断手机号码地址格式
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    if (mobileNum.length != 11)
    {
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     */
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    /**
     * 中国联通：China Unicom
     * 130,131,132,155,156,185,186,145,176,1709
     */
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    /**
     * 中国电信：China Telecom
     * 133,153,180,181,189,173,174,177,1700
     */
    NSString *CT = @"(^1(33|53|73|74|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (void)addGrayShadowAboveOnView:(UIView *)view {
    view.layer.masksToBounds = NO;
    view.layer.shadowColor = RGB_COLOR_HEX(0xCCCCCC).CGColor;
    view.layer.shadowOffset = CGSizeMake(0, -3);
    view.layer.shadowRadius = 3;
    view.layer.shadowOpacity = 0.26;
}

+ (void)addShadowOnView:(UIView *)view {
    view.layer.masksToBounds = NO;
    view.layer.shadowColor = commonBlueColor.CGColor;
    view.layer.shadowOffset = CGSizeMake(0, 6);
    view.layer.shadowRadius = 4;
    view.layer.shadowOpacity = 0.36;
}

+ (void)addGrayShadowOnView:(UIView *)view {
    view.layer.masksToBounds = NO;
    view.layer.shadowColor = RGB_COLOR_HEX(0xCCCCCC).CGColor;
    view.layer.shadowOffset = CGSizeMake(0, 6);
    view.layer.shadowRadius = 4;
    view.layer.shadowOpacity = 0.36;
}

+ (void)removeShadowOnView:(UIView *)view {
    view.layer.masksToBounds = NO;
    view.layer.shadowColor = [UIColor clearColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(0, 0);
    view.layer.shadowRadius = 0;
    view.layer.shadowOpacity = 0.0;
}

@end
