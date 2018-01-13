//
//  MKDynamicCommentModel.m
//  Moka
//
//  Created by  moka on 2017/8/10.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKDynamicCommentModel.h"

@implementation MKDynamicCommentModel

@synthesize id;

- (instancetype)initWithCommentModel:(MKCommentModel *)commentModel {
    self = [super init];
    if (self) {
        self.messageid   = commentModel.messageid;
        self.id          = commentModel.id;
        self.createtime  = commentModel.createtime;
        self.commenttext = commentModel.commenttext;
        self.replycomid  = commentModel.replycomid;
        self.name        = commentModel.name;
        self.userid      = commentModel.userid;
        self.img         = commentModel.img;
        self.ifdel       = commentModel.ifdel;
        self.hideSeperatorLine = 0;
    }
    return self;
}



- (instancetype)initWithReplyModel:(MKReplyModel *)replyModel {
    self = [super init];
    if (self) {
        self.messageid   = replyModel.messageid;
        self.id          = replyModel.id;
        self.createtime  = replyModel.createtime;
        self.commenttext = replyModel.commenttext;
        self.replycomid  = replyModel.replycomid;
        self.name        = replyModel.name;
        self.userid      = replyModel.userid;
        self.img         = replyModel.img;
        self.replyName   = replyModel.replyName;
        self.ifdel       = replyModel.ifdel;
        self.hideSeperatorLine = 0;
    }
    return self;
}

@end
