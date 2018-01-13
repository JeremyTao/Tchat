//
//  MKBusinessCardCell.m
//  Moka
//
//  Created by  moka on 2017/8/23.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKBusinessCardCell.h"

@implementation MKBusinessCardCell
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
    MKBusinessCardMessage *message = (MKBusinessCardMessage *)model.content;
    CGSize size = [MKBusinessCardCell getBubbleBackgroundViewSize:message];
    
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
    
    
    // 图片
    self.userImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.userImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.userImageView.layer.cornerRadius = 5;
    self.userImageView.layer.masksToBounds = YES;
    [self.bubbleBackgroundView addSubview:self.userImageView];
    
    [self.userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bubbleBackgroundView.mas_top).offset(8);
        make.left.equalTo(self.bubbleBackgroundView.mas_left).offset(8);
        make.right.equalTo(self.bubbleBackgroundView.mas_right).offset(-15);
        make.height.equalTo(@(138));
    }];
    
    // 用户名
    
    self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
    [self.userNameLabel sizeToFit];
    [self.userNameLabel setFont:[UIFont systemFontOfSize:15]];
    self.userNameLabel.textColor = RGB_COLOR_HEX(0x2A2A2A);
    self.userNameLabel.backgroundColor = [UIColor clearColor];
    self.userNameLabel.numberOfLines = 1;
    [self.bubbleBackgroundView addSubview:self.userNameLabel];
    
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userImageView.mas_bottom).offset(12);
        make.left.equalTo(self.userImageView.mas_left).offset(0);
        make.height.equalTo(@(20));
        make.width.equalTo(@(130));
    }];
    
    
    //年龄
    self.userAgeLabel  = [[UILabel alloc] initWithFrame:CGRectZero];
    
    [self.userAgeLabel setFont:[UIFont systemFontOfSize:14]];
    self.userAgeLabel.textColor = RGB_COLOR_HEX(0x4A4A4A);
    self.userAgeLabel.backgroundColor = [UIColor clearColor];
    self.userAgeLabel.numberOfLines = 1;
    [self.bubbleBackgroundView addSubview:self.userAgeLabel];
    
    [self.userAgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userImageView.mas_bottom).offset(12);
        make.left.equalTo(self.userNameLabel.mas_right).offset(10);
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
    MKBusinessCardMessage *cardMessage = (MKBusinessCardMessage *)self.model.content;
    
    [self.userImageView setImageUPSUrl:cardMessage.userPortrait];
    self.userNameLabel.text   = cardMessage.userName;
//    self.userAgeLabel.text    = cardMessage.userAge;
    self.userAgeLabel.text    = @"";
    CGSize textLabelSize = [[self class] getTextLabelSize:cardMessage];
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
        
        [self.userImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bubbleBackgroundView.mas_top).offset(8);
            make.left.equalTo(self.bubbleBackgroundView.mas_left).offset(15);
            make.right.equalTo(self.bubbleBackgroundView.mas_right).offset(-7);
            make.height.equalTo(@(138));
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
        
        self.bubbleBackgroundView.tintColor = [UIColor whiteColor];
        
        self.bubbleBackgroundView.image = [renderImage
                                           resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8,
                                                                                        image.size.width * 0.2,
                                                                                        image.size.height * 0.2,
                                                                                        image.size.width * 0.8)];
      
        [self.userImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bubbleBackgroundView.mas_top).offset(8);
            make.left.equalTo(self.bubbleBackgroundView.mas_left).offset(8);
            make.right.equalTo(self.bubbleBackgroundView.mas_right).offset(-15);
            make.height.equalTo(@(138));
        }];

        
    }
    
    
    
}



+ (CGSize)getTextLabelSize:(MKBusinessCardMessage *)message {
    return CGSizeZero;
}

+ (CGSize)getBubbleSize:(CGSize)textLabelSize {
    
    return CGSizeMake(160, 190);
}

+ (CGSize)getBubbleBackgroundViewSize:(MKBusinessCardMessage *)message {
    
    return CGSizeMake(160, 190);
}



@end
