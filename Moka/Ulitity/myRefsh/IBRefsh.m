//
//  IBRefsh.m
//  InnerBuy
//
//  Created by 郑克 on 16/5/16.
//  Copyright © 2016年 sanfenqiu. All rights reserved.
//

#import "IBRefsh.h"
@implementation IBRefsh



+(void)IBheadAndFooterWithRefreshingTarget:(id)target refreshingAction:(SEL)action andFoootTarget:(id)foottarget refreshingFootAction:(SEL)footaction and:(UIScrollView *)myTableView{
    
    
    
    NSMutableArray *images = [NSMutableArray array];
    
    NSArray * imageArr = @[@"0",@"1",@"2",@"3",@"4",@"5", @"6", @"7", @"8", @"9"];
    for (int i = 0; i < imageArr.count; i++) {
        UIImage *image = [UIImage imageNamed:imageArr[i]];
        [images addObject:image];
    }
    MJRefreshGifHeader *gifHead = [MJRefreshGifHeader headerWithRefreshingTarget:target refreshingAction:action];
    //隐藏时间
    gifHead.lastUpdatedTimeLabel.hidden = YES;
    
    //隐藏状态
    gifHead.stateLabel.hidden = YES;
    
    [gifHead setImages:images duration:0.6 forState:(MJRefreshStatePulling)];
    
    //[gifHead setImages:images forState:MJRefreshStatePulling];
    myTableView.mj_header = gifHead;
    
    
    MJRefreshAutoGifFooter  * giftFoot= [MJRefreshAutoGifFooter footerWithRefreshingTarget:foottarget refreshingAction:footaction];
    
    giftFoot.refreshingTitleHidden = YES;
    //设置刷新图片
    [giftFoot setImages:images duration:0.6 forState:(MJRefreshStateRefreshing)];
    //设置尾部
    myTableView.mj_footer = giftFoot;
}

+(void)IBheadWithRefreshingTarget:(id)target refreshingAction:(SEL)action and:(UITableView *)myTableView{
    
    
    NSMutableArray *images = [NSMutableArray array];
    
    NSArray * imageArr = @[@"0",@"1",@"2",@"3",@"4",@"5", @"6", @"7", @"8", @"9"];
    for (int i = 0; i < imageArr.count; i++) {
        UIImage *image = [UIImage imageNamed:imageArr[i]];
        [images addObject:image];
    }
    
    MJRefreshGifHeader *gifHead = [MJRefreshGifHeader headerWithRefreshingTarget:target refreshingAction:action];
    //隐藏时间
    gifHead.lastUpdatedTimeLabel.hidden = YES;
    
    //隐藏状态
    gifHead.stateLabel.hidden = YES;
    [gifHead setImages:images forState:MJRefreshStatePulling];
    myTableView.mj_header = gifHead;
    
    
}



@end
