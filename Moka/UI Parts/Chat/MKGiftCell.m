//
//  MKGiftCell.m
//  Moka
//
//  Created by  moka on 2017/8/17.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKGiftCell.h"

@implementation MKGiftCell


+ (CGSize)sizeForMessageModel:(RCMessageModel *)model
      withCollectionViewWidth:(CGFloat)collectionViewWidth
         referenceExtraHeight:(CGFloat)extraHeight {
    MKGiftMessage *message = (MKGiftMessage *)model.content;
    CGSize size = [MKGiftCell getBubbleBackgroundViewSize:message];
    
    CGFloat __messagecontentview_height = size.height;
    __messagecontentview_height += extraHeight;
    
    return CGSizeMake(collectionViewWidth, __messagecontentview_height);
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeCell];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initializeCell];
    }
    return self;
}


- (void)initializeCell {
    //背景气泡
    self.bubbleBackgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.messageContentView addSubview:self.bubbleBackgroundView];
    
    //顶部“ 很高兴认识你”
    self.niceToMeetULabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.niceToMeetULabel.text = @"   很高兴认识你";
    [self.niceToMeetULabel setFont:[UIFont systemFontOfSize:14]];
    self.niceToMeetULabel.backgroundColor = [UIColor whiteColor];
    self.niceToMeetULabel.numberOfLines = 0;
    self.niceToMeetULabel.layer.cornerRadius = 4;
    self.niceToMeetULabel.layer.masksToBounds = YES;
    [self.niceToMeetULabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.niceToMeetULabel setTextAlignment:NSTextAlignmentLeft];
    [self.niceToMeetULabel setTextColor:RGB_COLOR_HEX(0x2A2A2A)];
    [self.bubbleBackgroundView addSubview:self.niceToMeetULabel];
    
    [self.niceToMeetULabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(25));
        make.top.equalTo(self.bubbleBackgroundView.mas_top).offset(7);
        make.left.equalTo(self.bubbleBackgroundView.mas_left).offset(7);
        make.right.equalTo(self.bubbleBackgroundView.mas_right).offset(0);
    }];
    
    //紫色背景
    self.purpleView = [[UIView alloc] initWithFrame:CGRectZero];
    self.purpleView.backgroundColor = RGB_COLOR_HEX(0xF5F7FF);
    [self.bubbleBackgroundView addSubview:self.purpleView];
    
    [self.purpleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.niceToMeetULabel.mas_bottom).offset(10);
        make.left.equalTo(self.niceToMeetULabel.mas_left).offset(10);
        make.right.equalTo(self.niceToMeetULabel.mas_right).offset(-10);
        make.bottom.equalTo(self.bubbleBackgroundView.mas_bottom).offset(-10);
    }];
    
    
    // 礼物图片
    self.giftImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.giftImageView.image = [UIImage imageNamed:@"chat_present"];
    [self.bubbleBackgroundView addSubview:self.giftImageView];
    
    self.giftImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.giftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.purpleView.mas_centerX).offset(0);
        make.centerY.equalTo(self.purpleView.mas_centerY).offset(-20);
        make.height.equalTo(@(55));
        make.width.equalTo(@(75));
    }];
    
    //领取按钮
    self.getButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.getButton setTitle:@"领取" forState:UIControlStateNormal];
    [self.getButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.getButton.backgroundColor = commonBlueColor;
    [self.bubbleBackgroundView addSubview:self.getButton];
    self.getButton.layer.cornerRadius = 18;
    self.getButton.layer.masksToBounds = YES;
    [self.getButton addTarget:self action:@selector(getButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.getButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.purpleView.mas_centerX).offset(0);
        make.centerY.equalTo(self.purpleView.mas_centerY).offset(40);
        make.height.equalTo(@(36));
        make.width.equalTo(@(80));
    }];
    
    //添加手势
    [self setupGestureRecognizer];
}

- (void)getButtonEvent {
    if (self.getDelegate && [self.getDelegate respondsToSelector:@selector(didClickedGetButtonWith:)]) {
        [self.getDelegate didClickedGetButtonWith:(MKGiftMessage *)self.model.content];
    }
}

- (void)setupGestureRecognizer {
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(longPressedGift:)];
    
    [self.bubbleBackgroundView addGestureRecognizer:longPress];
    
    UITapGestureRecognizer *textMessageTap = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(tapGiftMessage:)];
    textMessageTap.numberOfTapsRequired = 1;
    textMessageTap.numberOfTouchesRequired = 1;
    [self.bubbleBackgroundView addGestureRecognizer:textMessageTap];
    self.bubbleBackgroundView.userInteractionEnabled = YES;
    
    
    
}


- (void)longPressedGift:(UILongPressGestureRecognizer *)longPressGesture {
    
    if (longPressGesture.state == UIGestureRecognizerStateEnded) {
        return;
    } else if (longPressGesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"长按礼物");
        [self.delegate didLongTouchMessageCell:self.model
                                        inView:self.bubbleBackgroundView];
    }
}

- (void)tapGiftMessage:(UITapGestureRecognizer *)tapGesture {
    NSLog(@"点击礼物");
    if ([self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
        [self.delegate didTapMessageCell:self.model];
    }
}


- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel:model];
    
    
    
    [self setAutoLayout];
}


- (void)setAutoLayout {
    MKGiftMessage *redPacketMessage = (MKGiftMessage *)self.model.content;

    CGSize textLabelSize = [[self class] getTextLabelSize:redPacketMessage];
    CGSize bubbleBackgroundViewSize = [[self class] getBubbleSize:textLabelSize];
    CGRect messageContentViewRect = self.messageContentView.frame;
    
    //拉伸图片
    if (MessageDirection_RECEIVE == self.messageDirection) {
        
        //接受的消息
        messageContentViewRect.size.width = bubbleBackgroundViewSize.width;
        self.messageContentView.frame = messageContentViewRect;
        
        self.bubbleBackgroundView.frame = CGRectMake( 0, 0, bubbleBackgroundViewSize.width,
                                                     bubbleBackgroundViewSize.height);
        UIImage *image = [RCKitUtility imageNamed:@"chat_from_bg_normal"
                                         ofBundle:@"RongCloud.bundle"];
        UIImage *renderImage =  [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        self.bubbleBackgroundView.tintColor = [UIColor whiteColor];
        
        self.bubbleBackgroundView.image = [renderImage
                                           resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8,
                                                                                        image.size.width * 0.8,
                                                                                        image.size.height * 0.2,
                                                                                        image.size.width * 0.2)];
        
        [self.niceToMeetULabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(25));
            make.top.equalTo(self.bubbleBackgroundView.mas_top).offset(7);
            make.left.equalTo(self.bubbleBackgroundView.mas_left).offset(7);
            make.right.equalTo(self.bubbleBackgroundView.mas_right).offset(0);
        }];
        
        [self.purpleView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.niceToMeetULabel.mas_bottom).offset(10);
            make.left.equalTo(self.niceToMeetULabel.mas_left).offset(10);
            make.right.equalTo(self.niceToMeetULabel.mas_right).offset(-10);
            make.bottom.equalTo(self.bubbleBackgroundView.mas_bottom).offset(-10);
        }];
        
        [self.giftImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.purpleView.mas_centerX).offset(0);
            make.centerY.equalTo(self.purpleView.mas_centerY).offset(-20);
            make.height.equalTo(@(55));
            make.width.equalTo(@(75));
        }];
        
        [self.getButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.purpleView.mas_centerX).offset(0);
            make.centerY.equalTo(self.purpleView.mas_centerY).offset(40);
            make.height.equalTo(@(36));
            make.width.equalTo(@(80));
        }];
        
        self.getButton.hidden = NO;
        
        MKGiftMessage *messageContent = (MKGiftMessage *)self.model.content;
        
        if (![self.model.extra isEqualToString:@""] || [messageContent.status isEqualToString: @"1"]) {
            self.getButton.hidden = YES;
            [self.giftImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.purpleView.mas_centerX).offset(0);
                make.centerY.equalTo(self.purpleView.mas_centerY).offset(0);
                make.height.equalTo(@(55));
                make.width.equalTo(@(75));
            }];
        }
        
        
       
        
    } else {
        //发送的消息
        
        messageContentViewRect.size.width = bubbleBackgroundViewSize.width;
        messageContentViewRect.size.height = bubbleBackgroundViewSize.height;
        messageContentViewRect.origin.x =
        self.baseContentView.bounds.size.width -
        (messageContentViewRect.size.width + HeadAndContentSpacing +
         [RCIM sharedRCIM].globalMessagePortraitSize.width + 10);
        self.messageContentView.frame = messageContentViewRect;
        
        self.bubbleBackgroundView.frame = CGRectMake(0, 0, bubbleBackgroundViewSize.width, bubbleBackgroundViewSize.height);
        UIImage *image = [RCKitUtility imageNamed:@"chat_to_bg_normal"
                                         ofBundle:@"RongCloud.bundle"];
        UIImage *renderImage =  [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        self.bubbleBackgroundView.tintColor = [UIColor whiteColor];
        
        self.bubbleBackgroundView.image = [renderImage
                                           resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8,
                                                                                        image.size.width * 0.2,
                                                                                        image.size.height * 0.2,
                                                                                        image.size.width * 0.8)];
        
        [self hideGetButtonLayout];
        
    }
    
    
    
    
    

    
    
}


- (void)hideGetButtonLayout {
    [self.niceToMeetULabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(25));
        make.top.equalTo(self.bubbleBackgroundView.mas_top).offset(7);
        make.left.equalTo(self.bubbleBackgroundView.mas_left).offset(0);
        make.right.equalTo(self.bubbleBackgroundView.mas_right).offset(-7);
    }];
    
    
    [self.purpleView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.niceToMeetULabel.mas_bottom).offset(10);
        make.left.equalTo(self.niceToMeetULabel.mas_left).offset(10);
        make.right.equalTo(self.niceToMeetULabel.mas_right).offset(-10);
        make.bottom.equalTo(self.bubbleBackgroundView.mas_bottom).offset(-10);
    }];
    
    [self.giftImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.purpleView.mas_centerX).offset(0);
        make.centerY.equalTo(self.purpleView.mas_centerY).offset(0);
        make.height.equalTo(@(55));
        make.width.equalTo(@(75));
    }];
    
    self.getButton.hidden = YES;
}

+ (CGSize)getTextLabelSize:(MKGiftMessage *)message {
     return CGSizeZero;
}


+ (CGSize)getBubbleSize:(CGSize)textLabelSize {
    
    return CGSizeMake(160, 190);
}

+ (CGSize)getBubbleBackgroundViewSize:(MKGiftMessage *)message {
    
    return CGSizeMake(160, 190);
}



@end
