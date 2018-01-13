//
//  MKRedPacketCell.m
//  Moka
//
//  Created by  moka on 2017/8/15.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKRedPacketCell.h"

@interface MKRedPacketCell ()



@end



@implementation MKRedPacketCell

/*!
 自定义消息Cell的Size
 
 @param model               要显示的消息model
 @param collectionViewWidth cell所在的collectionView的宽度
 @param extraHeight         cell内容区域之外的高度
 
 @return 自定义消息Cell的Size
 
 @discussion 当应用自定义消息时，必须实现该方法来返回cell的Size。
 其中，extraHeight是Cell根据界面上下文，需要额外显示的高度（比如时间、用户名的高度等）。
 一般而言，Cell的高度应该是内容显示的高度再加上extraHeight的高度。
 */


+ (CGSize)sizeForMessageModel:(RCMessageModel *)model
      withCollectionViewWidth:(CGFloat)collectionViewWidth
         referenceExtraHeight:(CGFloat)extraHeight {
    MKRedPacketMessageContent *message = (MKRedPacketMessageContent *)model.content;
    CGSize size = [MKRedPacketCell getBubbleBackgroundViewSize:message];
    
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
    
    //底部“ 摩咖红包”
    self.mokaLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.mokaLabel.text = @"   钛值红包";
    [self.mokaLabel setFont:[UIFont systemFontOfSize:14]];
    self.mokaLabel.backgroundColor = [UIColor whiteColor];
    self.mokaLabel.numberOfLines = 0;
    self.mokaLabel.layer.cornerRadius = 4;
    self.mokaLabel.layer.masksToBounds = YES;
    [self.mokaLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.mokaLabel setTextAlignment:NSTextAlignmentLeft];
    [self.mokaLabel setTextColor:RGB_COLOR_HEX(0xB3B3B3)];
    [self.bubbleBackgroundView addSubview:self.mokaLabel];
    
    [self.mokaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(25));
        make.bottom.equalTo(self.bubbleBackgroundView.mas_bottom).offset(0);
        make.left.equalTo(self.bubbleBackgroundView.mas_left).offset(0);
        make.right.equalTo(self.bubbleBackgroundView.mas_right).offset(-7);
    }];
    
    self.whiteView = [[UIView alloc] initWithFrame:CGRectZero];
    self.whiteView.backgroundColor = [UIColor whiteColor];
    [self.bubbleBackgroundView addSubview:self.whiteView];
    
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mokaLabel.mas_top).offset(0);
        make.left.equalTo(self.bubbleBackgroundView.mas_left).offset(0);
        make.right.equalTo(self.mokaLabel.mas_right).offset(0);
        make.height.equalTo(@(10));
    }];
    [self.bubbleBackgroundView insertSubview:self.mokaLabel aboveSubview:self.whiteView];
    
    // 左侧红包图片
    self.redPacketImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.redPacketImageView.image = [UIImage imageNamed:@"chat_dialog_redenvelope"];
    [self.bubbleBackgroundView addSubview:self.redPacketImageView];
    
    [self.redPacketImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bubbleBackgroundView.mas_top).offset(13);
        make.left.equalTo(self.bubbleBackgroundView.mas_left).offset(13);
        make.height.equalTo(@(45));
        make.width.equalTo(@(40));
    }];
    
    //红包标题
    
    self.redPacketNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.redPacketNameLabel.text  = @"恭喜发财，大吉大利";
    [self.redPacketNameLabel setFont:[UIFont systemFontOfSize:15]];
    self.redPacketNameLabel.textColor = [UIColor whiteColor];
    self.redPacketNameLabel.backgroundColor = [UIColor clearColor];
    self.redPacketNameLabel.numberOfLines = 1;
    [self.bubbleBackgroundView addSubview:self.redPacketNameLabel];
    
    [self.redPacketNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bubbleBackgroundView.mas_top).offset(12);
        make.left.equalTo(self.redPacketImageView.mas_right).offset(10);
        make.right.equalTo(self.mokaLabel.mas_right).offset(-10);
        make.height.equalTo(@(20));
    }];
    
    
    //领取红包
    self.getLabel  = [[UILabel alloc] initWithFrame:CGRectZero];
    self.getLabel.text  = @"领取红包";
    [self.getLabel setFont:[UIFont systemFontOfSize:14]];
    self.getLabel.textColor = RGB_COLOR_HEX(0xE1E1E1);
    self.getLabel.backgroundColor = [UIColor clearColor];
    self.getLabel.numberOfLines = 1;
    [self.bubbleBackgroundView addSubview:self.getLabel];
    
    [self.getLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.redPacketNameLabel.mas_bottom).offset(8);
        make.left.equalTo(self.redPacketImageView.mas_right).offset(10);
        make.right.equalTo(self.mokaLabel.mas_right).offset(-10);
        make.height.equalTo(@(20));
    }];

    //添加手势
    [self setupGestureRecognizer];
}

- (void)setupGestureRecognizer {
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self
                                                       action:@selector(longPressedRedPacket:)];
    
    [self.bubbleBackgroundView addGestureRecognizer:longPress];
    
    UITapGestureRecognizer *textMessageTap = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(tapRedPacketMessage:)];
    textMessageTap.numberOfTapsRequired = 1;
    textMessageTap.numberOfTouchesRequired = 1;
    [self.bubbleBackgroundView addGestureRecognizer:textMessageTap];
    self.bubbleBackgroundView.userInteractionEnabled = YES;

    
    
}


- (void)longPressedRedPacket:(UILongPressGestureRecognizer *)longPressGesture {

    if (longPressGesture.state == UIGestureRecognizerStateEnded) {
        return;
    } else if (longPressGesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"长按红包");
        [self.delegate didLongTouchMessageCell:self.model
                                        inView:self.bubbleBackgroundView];
    }
}

- (void)tapRedPacketMessage:(UITapGestureRecognizer *)tapGesture {
    NSLog(@"点击红包");
    if ([self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
        [self.delegate didTapMessageCell:self.model];
    }
}


- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel:model];
    
    [self setAutoLayout];
    
    
}



- (void)setAutoLayout {
    MKRedPacketMessageContent *redPacketMessage = (MKRedPacketMessageContent *)self.model.content;
    self.redPacketNameLabel.text = redPacketMessage.redPacketTitle ? redPacketMessage.redPacketTitle : @"恭喜发财，大吉大利";
    
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
        
        if ([redPacketMessage.status isEqualToString:@"0"]) {
            //未领取
            self.bubbleBackgroundView.tintColor = RedPacketColor;
        } else if ([redPacketMessage.status isEqualToString:@"1"]) {
            //已领取
            self.bubbleBackgroundView.tintColor = RGB_COLOR_HEX(0xE18181);
            self.getLabel.text = @"已领取";
            
        } else if ([redPacketMessage.status isEqualToString:@"2"]) {
            //已过期
            self.bubbleBackgroundView.tintColor = RGB_COLOR_HEX(0xE18181);
            self.getLabel.text = @"已过期";
        }
        
        self.bubbleBackgroundView.image = [renderImage
                                           resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8,
                                                                                        image.size.width * 0.8,
                                                                                        image.size.height * 0.2,
                                                                                        image.size.width * 0.2)];
        
    
        [self.mokaLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(25));
            make.bottom.equalTo(self.bubbleBackgroundView.mas_bottom).offset(0);
            make.left.equalTo(self.bubbleBackgroundView.mas_left).offset(7);
            make.right.equalTo(self.bubbleBackgroundView.mas_right).offset(0);
        }];
        
        [self.whiteView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mokaLabel.mas_top).offset(0);
            make.left.equalTo(self.bubbleBackgroundView.mas_left).offset(7);
            make.right.equalTo(self.mokaLabel.mas_right).offset(0);
            make.height.equalTo(@(10));
        }];
        
        [self.redPacketImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bubbleBackgroundView.mas_top).offset(13);
            make.left.equalTo(self.bubbleBackgroundView.mas_left).offset(20);
            make.height.equalTo(@(45));
            make.width.equalTo(@(40));
        }];
        
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
        
        self.bubbleBackgroundView.tintColor = RedPacketColor;
        
        self.bubbleBackgroundView.image = [renderImage
                                           resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8,
                                                                                        image.size.width * 0.2,
                                                                                        image.size.height * 0.2,
                                                                                        image.size.width * 0.8)];
        
        [self.mokaLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(25));
            make.bottom.equalTo(self.bubbleBackgroundView.mas_bottom).offset(0);
            make.left.equalTo(self.bubbleBackgroundView.mas_left).offset(0);
            make.right.equalTo(self.bubbleBackgroundView.mas_right).offset(-7);
        }];
        
        [self.whiteView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mokaLabel.mas_top).offset(0);
            make.left.equalTo(self.bubbleBackgroundView.mas_left).offset(0);
            make.right.equalTo(self.mokaLabel.mas_right).offset(0);
            make.height.equalTo(@(10));
        }];
        
        [self.redPacketImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bubbleBackgroundView.mas_top).offset(13);
            make.left.equalTo(self.bubbleBackgroundView.mas_left).offset(13);
            make.height.equalTo(@(45));
            make.width.equalTo(@(40));
        }];
        
    }
    
    MKRedPacketMessageContent *messageContent = (MKRedPacketMessageContent *)self.model.content;
    if ([self.model.extra isEqualToString:@"1" ] || [self.model.extra isEqualToString:@"2"] || [self.model.extra isEqualToString:@"3"] || [messageContent.status isEqualToString:@"1"] || [messageContent.status isEqualToString:@"2"] || [messageContent.status isEqualToString:@"3"]) {
        
        self.bubbleBackgroundView.tintColor = RGB_COLOR_HEX(0xE18181);
    } else {
       self.bubbleBackgroundView.tintColor = RedPacketColor;
    }
    
    //1:已领取 2:已过期 3:已抢完
    if ([self.model.extra isEqualToString:@"1"] || [messageContent.status isEqualToString:@"1"]) {
        self.bubbleBackgroundView.tintColor = RGB_COLOR_HEX(0xE18181);
        self.getLabel.text = @"已领取";
    }else if ([self.model.extra isEqualToString:@"2"] || [messageContent.status isEqualToString:@"2"]){
        self.bubbleBackgroundView.tintColor = RGB_COLOR_HEX(0xE18181);
        self.getLabel.text = @"已过期";
    }else if ([self.model.extra isEqualToString:@"3"] || [messageContent.status isEqualToString:@"3"]){
        self.bubbleBackgroundView.tintColor = RGB_COLOR_HEX(0xE18181);
        self.getLabel.text = @"已抢完";
    }else{
        self.bubbleBackgroundView.tintColor = RedPacketColor;
        self.getLabel.text = @"领取红包";
    }
    //
    if ([messageContent.coinType isEqualToString:@"1"]) {
        self.mokaLabel.text = @"   零钱红包";
    }
    if ([messageContent.coinType isEqualToString:@"2"]) {
        self.mokaLabel.text = @"   钛值红包";
    }

}



+ (CGSize)getTextLabelSize:(MKRedPacketMessageContent *)message {
    if ([message.redPacketTitle length] > 0) {
        float maxWidth =
        [UIScreen mainScreen].bounds.size.width -
        (10 + [RCIM sharedRCIM].globalMessagePortraitSize.width + 10) * 2 - 5 -
        35;
        CGRect textRect = [message.redPacketTitle
                           boundingRectWithSize:CGSizeMake(maxWidth, 8000)
                           options:(NSStringDrawingTruncatesLastVisibleLine |
                                    NSStringDrawingUsesLineFragmentOrigin |
                                    NSStringDrawingUsesFontLeading)
                           attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15] }
                           context:nil];
        textRect.size.height = ceilf(textRect.size.height);
        textRect.size.width = ceilf(textRect.size.width);
        return CGSizeMake(textRect.size.width + 5, textRect.size.height + 5);
    } else {
        return CGSizeZero;
    }
}

+ (CGSize)getBubbleSize:(CGSize)textLabelSize {

    return CGSizeMake(240, 95);
}

+ (CGSize)getBubbleBackgroundViewSize:(MKRedPacketMessageContent *)message {
 
    return CGSizeMake(240, 95);
}


@end
