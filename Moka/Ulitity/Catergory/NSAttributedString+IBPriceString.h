//
//  NSAttributedString+IBPriceString.h
//  InnerBuy
//
//  Created by Knight on 5/16/16.
//  Copyright © 2016 sanfenqiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (IBPriceString)

+ (NSAttributedString *)priceFromString:(NSString *)string;
+ (NSAttributedString *)priceBlackFromString:(NSString *)string and:(CGFloat)fount;
+ (NSAttributedString *)blacpriceBlackFromString:(NSString *)string and:(CGFloat)fount;

+ (NSAttributedString *)priceBlackFromString:(NSString *)string and:(CGFloat)fount and:(UIColor *)color;
+ (NSAttributedString *)orderPriceFromString:(NSString *)string ;

+ (NSAttributedString *)orderFountPriceFromString:(NSString *)string  and:(CGFloat)myFloat;
@end
