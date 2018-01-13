//
//  UIViewController+CBBasicVC.h
//  CrunClub
//
//  Created by 郑克 on 16/3/11.
//  Copyright © 2016年 sanfenqiu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (CBBasicVC)

-(void)setCommeNaviGationBar:(NSString *)title and:(BOOL)isPush;
/**
 *  设置默认导航只带返回
 *
 *  @param title 控制器title
 */
-(void)setCommeNaviGationBar:(NSString *)title;

-(void)setCommeNaviGationBar:(NSString *)title andRightbtnImage:(NSString *)rightName andTarget:(id)target SEL:(SEL)method ;
/**
 
 设置自定义返回的navigationBar
 */

-(void)setNewNavi:(NSString *)title andBackCoLor:(UIColor *)color andImageName:(NSString *)name andTileColor:(UIColor *)titleColor lineViewColor:(UIColor *)lineColor;
/**
 设置只用返回的navigationBar和右边图片的btn

 */

-(void)setNewNavi:(NSString *)title andBackCoLor:(UIColor *)color andImageName:(NSString *)name andRightbtnTitle:(NSString *)rightName andTarget:(id)target SEL:(SEL)method andRBtnColor:(UIColor *)rightColor  andTileColor:(UIColor *)titleColor lineViewColor:(UIColor *)lineColor;
/**
 设置只用返回的navigationBar和右边图片的btn

 */

-(void)setNewNavi:(NSString *)title andBackCoLor:(UIColor *)color andImageName:(NSString *)name andleftandTarget:(id)rtarget SEL:(SEL)rmethod andRightbtnTitle:(NSString *)rightName andTarget:(id)target SEL:(SEL)method andRBtnColor:(UIColor *)rightColor andTileColor:(UIColor *)titleColor lineViewColor:(UIColor *)lineColor;
-(void)close;
#pragma  mark 设置NaviGationBar
-(void)setLeftNaviBarRed;
#pragma  mark 设置导航栏字体颜色黑色
- (void)setupNavigationBarBlack;
- (void)setBlueStyleNavigationBar;
- (void)setWhiteStyleNavigationBar;
- (void)setBlackStyleNavigationBar;

-(void)setNoback:(NSString *)title;
-(void)setLeftNaviBarIteam;
- (void)setNavigationBar;
/**
 *设置导航栏不透明
 */
-(void)SetNoAphr;
/**设置导航栏透明*/
-(void)setNaviAphr;
/**
 *  设置导航栏的背景颜色以及标题文字
 */
-(void)setupNavigationBar;
/**切圆角*/
-(void)creatCircle:(UIButton *)sender;
//设置
-(void)setLeftNaviBar;
/**
 *  md5加密
 *
 *  @param str
 *
 *  @return
 */
//-(NSString *)getPassWord:(NSString *)str;
/**
 *  数字滚动
 *
 */
-(void)updateUIWithOne:(NSString *)one andTwo:(NSString *)two and:(UILabel *)senderLable;
- (void)shakeAnimationForView:(UIView *) view;
- (NSString *)cacheStringWithSDCache:(NSInteger)cacheSize;

//传入类名，创建VC，并push到VC
- (void)pushViewController:(Class)vc_class;
//执行约束改变动画
- (void)playConstraintsChangeAnimation;

@end
