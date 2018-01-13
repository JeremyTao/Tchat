//
//  IBInfoLable.m
//  InnerBuy
//
//  Created by 郑克 on 2016/10/8.
//  Copyright © 2016年 sanfenqiu. All rights reserved.
//

#import "IBInfoLable.h"

@implementation IBInfoLable


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.layer.cornerRadius = 1;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
}


@end
