//
//  IBSmallText.m
//  InnerBuy
//
//  Created by 郑克 on 16/5/5.
//  Copyright © 2016年 sanfenqiu. All rights reserved.
//

#import "IBSmallText.h"

@implementation IBSmallText


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super awakeFromNib];
    
}
-(void)setText{
    
    [[self layer] setBorderColor:commonBlueColor.CGColor];
    [[self layer] setBorderWidth:self.borderWidth];
}
-(void)clearText{
    
    [[self layer] setBorderColor:[UIColor colorWithRed:0.875 green:0.153 blue:0.153 alpha:0.000].CGColor];
    [[self layer] setBorderWidth:self.borderWidth];
}
@end
