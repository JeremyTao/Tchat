//
//  IBCopyImageView.m
//  IntelligentControl
//
//  Created by 郑克 on 2017/3/13.
//  Copyright © 2017年 sanfenqiu. All rights reserved.
//

#import "IBCopyImageView.h"

@implementation IBCopyImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
 UIPasteboard有系统级别和应用级别两种类型，所以不仅可以在应用程序内通信，还能在应用程序间通信，比如我复制一个url，然后打开safari，粘贴到地址栏去，而我们可以在应用程序间通信、共享数据。
 
 在PasteBoardWrite里面点“写入”后把textField中的文本写入粘贴板，然后切换到PasteBoardRead的时候显示出来。如果我们的粘贴板只想给“自己人”用的话，就不能用系统的通用粘贴板，需要我们自己创建一个：
 
 //需要提供一个唯一的名字，一般使用倒写的域名：com.mycompany.myapp.pboard
 
 //后面的参数表示，如果不存在，是否创建一个
 
 UIPasteboard *pb = [UIPasteboard pasteboardWithName:@"testBoard" create:YES];
 
 使用这个粘贴板，我们可以把文本存进去，然后在另一个app里面读出来，一些常用的类型已经被设置为属性了：
 
 
 除此之外，如果是能够转换成plist的数据类型（NSString, NSArray, NSDictionary, NSDate, NSNumber 和 NSURL），我们可以调用setValue:forPasteboardType:方法去存储数据，其他类型只能调用setData:forPasteboardType:方法（plist数据类型也可使用），类似于这样：
 
 
 
 //存储数据
 
 NSDictionary *dict = [NSDictionary dictionaryWithObject:textField.text forKey:@"content"];
 
 NSData *dictData = [NSKeyedArchiver archivedDataWithRootObject:dict];
 
 [pb setData:dictData forPasteboardType:@"myType"];
 
 
 
 //获取就类似于这样：
 
 UIPasteboard *pb = [UIPasteboard pasteboardWithName:@"testBoard" create:YES];
 
 NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:[pb dataForPasteboardType:@"myType"]];
 
 caption.text = [dict objectForKey:@"content"];
 
 上面提到了一个PasteboardType， 这是一个统一类型标识符（Uniform Type Identifier  UTI）,能帮助app获取自己能处理的数据。比如你只能处理文本的粘贴，那给你一个UIImage显然是无用的。你可以使用公用的UTI，也可以使用 任意字符，苹果建议使用倒写的域名加上类型名：com.myCompany.myApp.myType。
*/
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender

{
    
    return (action == @selector(copy:) || action == @selector(paste:));
    
}



-(void)copy:(id)sender

{
    
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    
    pboard.image = self.image;
    
}



-(void)paste:(id)sender

{
    
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    
    self.image = pboard.image;
    
}

-(BOOL)canBecomeFirstResponder

{
    
    return YES;
    
}

-(void)attachTapHandler

{
    
    self.userInteractionEnabled = YES;  //用户交互的总开关
    
    UITapGestureRecognizer *touch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    
    touch.numberOfTapsRequired = 2;
    
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
