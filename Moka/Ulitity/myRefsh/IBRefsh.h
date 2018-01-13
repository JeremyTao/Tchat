//
//  IBRefsh.h
//  InnerBuy
//
//  Created by 郑克 on 16/5/16.
//  Copyright © 2016年 sanfenqiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IBRefsh : NSObject
/**
 *  下拉刷新上拉加载的方法
 *
 *  @param target      target description
 *  @param action      action description
 *  @param myTableView myTableView description
 */
+(void)IBheadAndFooterWithRefreshingTarget:(id)target refreshingAction:(SEL)action andFoootTarget:(id)foottarget refreshingFootAction:(SEL)footaction and:(UIScrollView *)myTableView;

+(void)IBheadWithRefreshingTarget:(id)target refreshingAction:(SEL)action and:(UITableView *)myTableView;
@end
