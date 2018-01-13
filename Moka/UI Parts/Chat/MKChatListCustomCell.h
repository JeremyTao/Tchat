//
//  MKChatListCustomCell.h
//  Moka
//
//  Created by  moka on 2017/8/12.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface MKChatListCustomCell : RCConversationBaseCell

@property(nonatomic, strong) UIImageView *ivAva;
@property(nonatomic, strong) UILabel *lblName;
@property(nonatomic, strong) UILabel *lblDetail;
@property(nonatomic, copy)   NSString *userName;
@property(nonatomic, strong) UILabel *labelTime;

@end
