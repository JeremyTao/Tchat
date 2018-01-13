//
//  MKCircleMemberTableHeader.m
//  Moka
//
//  Created by  moka on 2017/8/7.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKCircleMemberTableHeader.h"

@implementation MKCircleMemberTableHeader

+ (instancetype)newCircleMemberTableHeaderView {
    MKCircleMemberTableHeader *customView = [[[NSBundle mainBundle] loadNibNamed:@"MKCircleMemberTableHeader" owner:nil options:nil] objectAtIndex:0];
    if ([customView isKindOfClass:[MKCircleMemberTableHeader class]]) {
        customView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 525);
        return customView;
    }
    else
        return nil;
}

@end
