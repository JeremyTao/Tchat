//
//  IBCopyLable.m
//  IntelligentControl
//
//  Created by 郑克 on 2017/3/13.
//  Copyright © 2017年 sanfenqiu. All rights reserved.
//

#import "IBCopyLable.h"

@implementation IBCopyLable

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(BOOL)canBecomeFirstResponder

{
    
    return YES;
    
}


// 可以响应的方法

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender

{
    
    return (action == @selector(copy:));
    
}

//针对于响应方法的实现

-(void)copy:(id)sender

{
    
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    
    pboard.string = self.text;
    
}
-(void)attachTapHandler

{
    
    self.userInteractionEnabled = YES;  //用户交互的总开关
    
    UILongPressGestureRecognizer *touch = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        
    [self addGestureRecognizer:touch];
    
    
}
- (id)initWithFrame:(CGRect)frame

{
    
    self = [super initWithFrame:frame];
    
    if (self)
        
    {
        
        [self attachTapHandler];
        
    }  
    
    return self;  
    
}
-(void)awakeFromNib

{
    
    [super awakeFromNib];
    
    [self attachTapHandler];
    
}
-(void)handleTap:(UIGestureRecognizer*) recognizer

{
    
    [self becomeFirstResponder];
    
    UIMenuItem *copyLink = [[UIMenuItem alloc] initWithTitle:@"复制"
                             
                                                      action:@selector(copy:)];
    
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:copyLink, nil]];
    
    [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
    
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated: YES];
    
}
@end
