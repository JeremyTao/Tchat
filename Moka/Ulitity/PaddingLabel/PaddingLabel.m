//
//  PaddingLabel.m
//  Moka
//
//  Created by  moka on 2017/8/10.
//  Copyright © 2017年 moka. All rights reserved.
//
#define PADDING 2

#import "PaddingLabel.h"

@interface PaddingLabel ()


// 用来决定上下左右内边距，也可以提供一个借口供外部修改，在这里就先固定写死
@property (assign, nonatomic) UIEdgeInsets edgeInsets;

@end

@implementation PaddingLabel

//下面三个方法用来初始化edgeInsets
- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.edgeInsets = UIEdgeInsetsMake(PADDING, 0, PADDING, 0);
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.edgeInsets = UIEdgeInsetsMake(PADDING, 0, PADDING, 0);
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.edgeInsets = UIEdgeInsetsMake(PADDING, 0, PADDING, 0);
}

// 修改绘制文字的区域，edgeInsets增加bounds
-(CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    
    /*
     调用父类该方法
     注意传入的UIEdgeInsetsInsetRect(bounds, self.edgeInsets),bounds是真正的绘图区域
     */
    CGRect rect = [super textRectForBounds:UIEdgeInsetsInsetRect(bounds,
                                                                 self.edgeInsets) limitedToNumberOfLines:numberOfLines];
    //根据edgeInsets，修改绘制文字的bounds
    rect.origin.x -= self.edgeInsets.left;
    rect.origin.y -= self.edgeInsets.top;
    rect.size.width += self.edgeInsets.left + self.edgeInsets.right;
    rect.size.height += self.edgeInsets.top + self.edgeInsets.bottom;
    return rect;
}

//绘制文字
- (void)drawTextInRect:(CGRect)rect
{
    //令绘制区域为原始区域，增加的内边距区域不绘制
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
}


@end
