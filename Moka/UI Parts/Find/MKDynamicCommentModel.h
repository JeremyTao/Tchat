//
//  MKDynamicCommentModel.h
//  Moka
//
//  Created by  moka on 2017/8/10.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKBasic.h"
#import "MKCommentModel.h"
#import "MKReplyModel.h"

@interface MKDynamicCommentModel : MKBasic

PRO_NUM(messageid);    //动态id

PRO_NUM(id);           //评论id
PRO_STR(createtime);   //时间
PRO_STR(commenttext);  //评论内容
PRO_NUM(replycomid);   // 0: 第一级评论

PRO_STR(name);         //评论人昵称
PRO_NUM(userid);       //评论人id
PRO_STR(img);          //评论人头像

PRO_STR(replyName);    //回复人名称 : nil则是第一级
PRO_NUM(ifdel);  // 是否是自己的评论

PRO_NUM(hideSeperatorLine);  //是否显示分割线 0 显示  1 不显示

- (instancetype)initWithCommentModel:(MKCommentModel *)commentModel;

- (instancetype)initWithReplyModel:(MKReplyModel *)replyModel;

@end
