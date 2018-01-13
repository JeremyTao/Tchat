//
//  IBShareView.h
//  InnerBuy
//
//  Created by Knight on 25/11/2016.
//  Copyright © 2016 sanfenqiu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IBShareViewDelegate <NSObject>

- (void)shareToWeichatMoments;

- (void)shareToWeichatFriends;

//- (void)shareToQQZone;
//
//- (void)shareToQQFriends;

@optional

- (void)inform;  //投诉
- (void)outCircle; //离开圈子
- (void)deCircle;  //解散圈子
- (void)taiValueFriends; //钛值好友
- (void)deleteDynamic; //删除动态
- (void)editRemark;  //修改备注
- (void)clearChat;  //清空聊天记录
- (void)addBlackList:(BOOL)add;//加入黑名单


@end


typedef enum : NSUInteger {
    ShareViewStyleNotMember, //非成员查看圈子信息
    ShareViewStyleMember,    //成员查看圈子信息
    ShareViewStyleAdmin,     //管理员查看圈子信息
    ShareViewStyleOther,     //分享他人的个人资料
    ShareViewStyleSelf,      //分享自己的个人资料
    ShareViewStyleDynamicSelf,//分享自己的动态
    ShareViewStyleDynamicOther,//分享他人的动态
    ShareViewStyleNews          //分享资讯
} ShareViewStyle;



@interface IBShareView : UIView

@property (weak, nonatomic) id<IBShareViewDelegate> delegate;

@property (assign, nonatomic) NSInteger index;

+ (instancetype)newShareView;

- (void)show;
- (void)hide;
- (void)setShareStyle:(ShareViewStyle)style;
- (void)setInBlackList:(BOOL)inBlack;

@end
