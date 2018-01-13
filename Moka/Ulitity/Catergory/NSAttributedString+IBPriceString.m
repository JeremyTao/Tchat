//
//  NSAttributedString+IBPriceString.m
//  InnerBuy
//
//  Created by Knight on 5/16/16.
//  Copyright © 2016 sanfenqiu. All rights reserved.
//

#import "NSAttributedString+IBPriceString.h"

@implementation NSAttributedString (IBPriceString)

+ (NSAttributedString *)priceFromString:(NSString *)string {
    NSString *defultStr   = @"¥";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", defultStr, string]];
    
    // 设置富文本样式
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:12]
                             range:NSMakeRange(0, 1)];
    
 
    [attributedString addAttributes:@{NSForegroundColorAttributeName:commonBlueColor,
                                      NSFontAttributeName:[UIFont systemFontOfSize:17.0 weight:0.3]} range:NSMakeRange(1, string.length)];
    
    return attributedString;
}
+ (NSAttributedString *)orderPriceFromString:(NSString *)string {
    NSString *defultStr   = @"¥";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", defultStr, string]];
    
    // 设置富文本样式
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:12]
                             range:NSMakeRange(0, 1)];
    
    
    [attributedString addAttributes:@{NSForegroundColorAttributeName:RGBCOLOR(105, 105, 105),
                                      NSFontAttributeName:[UIFont systemFontOfSize:17.0 weight:0.1]} range:NSMakeRange(1, string.length)];
    
    return attributedString;
}
+ (NSAttributedString *)orderFountPriceFromString:(NSString *)string  and:(CGFloat)myFloat{
    NSString *defultStr   = @"¥";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", defultStr, string]];
    
    // 设置富文本样式
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:12]
                             range:NSMakeRange(0, 1)];
    
    
    [attributedString addAttributes:@{NSForegroundColorAttributeName:commonBlueColor,
                                      NSFontAttributeName:[UIFont systemFontOfSize:myFloat weight:0.1]} range:NSMakeRange(1, string.length)];
    
    return attributedString;
}

+ (NSAttributedString *)priceBlackFromString:(NSString *)string and:(CGFloat)fount {
    NSString *defultStr   = @"¥";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", defultStr, string]];
    
    // 设置富文本样式
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:12]
                             range:NSMakeRange(0, 1)];
    
    
    [attributedString addAttributes:@{NSForegroundColorAttributeName:commonBlueColor,
                                      NSFontAttributeName:[UIFont systemFontOfSize:fount weight:0.3]} range:NSMakeRange(1, string.length)];
    
    return attributedString;
}
+ (NSAttributedString *)blacpriceBlackFromString:(NSString *)string and:(CGFloat)fount {
    NSString *defultStr   = @"¥";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", defultStr, string]];
    
    // 设置富文本样式
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:12]
                             range:NSMakeRange(0, 1)];
    
    
    [attributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.702 alpha:1.000],
                                      NSFontAttributeName:[UIFont systemFontOfSize:fount weight:0.3]} range:NSMakeRange(1, string.length)];
    
    return attributedString;
}
+ (NSAttributedString *)priceBlackFromString:(NSString *)string and:(CGFloat)fount and:(UIColor *)color{
    NSString *defultStr   = @"¥";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", defultStr, string]];
    
    // 设置富文本样式
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:12]
                             range:NSMakeRange(0, 1)];
    
    
    [attributedString addAttributes:@{NSForegroundColorAttributeName:color,
                                      NSFontAttributeName:[UIFont systemFontOfSize:fount weight:0.3]} range:NSMakeRange(1, string.length)];
    
    return attributedString;
    
}
@end
