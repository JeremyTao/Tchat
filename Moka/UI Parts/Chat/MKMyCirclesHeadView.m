//
//  MKMyCirclesHeadView.m
//  Moka
//
//  Created by Knight on 2017/9/11.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKMyCirclesHeadView.h"

@implementation MKMyCirclesHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (instancetype)newCirclesHeadView {
    MKMyCirclesHeadView *customView = [[[NSBundle mainBundle] loadNibNamed:@"MKMyCirclesHeadView" owner:nil options:nil] objectAtIndex:0];
    if ([customView isKindOfClass:[MKMyCirclesHeadView class]]) {
        
        customView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
        return customView;
    }
    else
        return nil;
}


@end
