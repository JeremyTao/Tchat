//
//  IBCommShare.m
//  InnerBuy
//
//  Created by 郑克 on 2017/3/2.
//  Copyright © 2017年 sanfenqiu. All rights reserved.
//

#import "IBCommShare.h"
//#import <TencentOpenAPI/QQApiInterface.h>
//#import <TencentOpenAPI/TencentOAuth.h>
//#import <TencentOpenAPI/TencentApiInterface.h>
//#import <TencentOpenAPI/QQApiInterfaceObject.h>

@implementation IBCommShare

+ (BOOL)isWXAppInstalled {
    // 1.判断是否安装微信
    if (![WXApi isWXAppInstalled]) {
        [MKUtilHUD showMoreHUD:@"您尚未安装\"微信\"，请先安装后再返回钛值" inView:[UIApplication sharedApplication].keyWindow];
        
        return NO;
    }
    // 2.判断微信的版本是否支持最新Api
    if (![WXApi isWXAppSupportApi]) {
        [MKUtilHUD showMoreHUD:@"您微信当前版本不支持此功能，请先升级微信应用" inView:[UIApplication sharedApplication].keyWindow];
        return NO;
    }
    return YES;
}
/*
+(BOOL)isQQAppInstalled{
    if (![QQApiInterface isQQInstalled]) {
        [UPSUtilHUD showMoreHUD:@"您尚未安装\"QQ\"，请先安装后再返回钛值" inView:[UIApplication sharedApplication].keyWindow];
        
        return NO;
    }
    if (![QQApiInterface isQQSupportApi]) {
        [UPSUtilHUD showMoreHUD:@"您QQ当前版本不支持此功能，请先升级微信应用" inView:[UIApplication sharedApplication].keyWindow];
        return NO;
    }
    
    return YES;
}


+ (void)handleSendResult:(QQApiSendResultCode)sendResult {
    switch (sendResult) {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
            
        default:
            break;
    }
}
+(void)shareToQQMoments:(NSString *)shareTitle shareDescription:(NSString *)shareDescription shareThumbImg:(NSString *)shareThumbImg shareUrl:(NSString *)shareUrl{
    
#pragma mark--分享纯文本 success
    //    QQApiTextObject *txtObj = [QQApiTextObject objectWithText:@"分享内容的text"];
#pragma mark--分享news success
    //    NSURL *previewURL = [NSURL URLWithString:@"http://v.youku.com/v_show/id_XMTQ3OTM4MzMxMg==_ev_3.html?from=y1.3-idx-uhome-1519-20887.205805-205902.3-1"];
    NSURL *previewURL = [NSURL URLWithString:shareUrl];
    NSString *imgURL = [NSString stringWithFormat:@"%@_200x200.jpg", shareThumbImg];
    NSData * previeImgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgURL]];
    QQApiNewsObject *imgObj = [QQApiNewsObject objectWithURL:previewURL title:shareTitle description:shareDescription previewImageData:previeImgData];
    [imgObj setCflag:kQQAPICtrlFlagQZoneShareOnStart];
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
    [self handleSendResult:sent];
    
}
+(void)shareToQQFriends:(NSString *)shareTitle shareDescription:(NSString *)shareDescription shareThumbImg:(NSString *)shareThumbImg shareUrl:(NSString *)shareUrl{
    
    NSURL *previewURL = [NSURL URLWithString:shareUrl];

    NSString *imgURL = [NSString stringWithFormat:@"%@_200x200.jpg", shareThumbImg];
    NSData * previeImgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgURL]];
    QQApiNewsObject *imgObj = [QQApiNewsObject objectWithURL:previewURL title:shareTitle description:shareDescription previewImageData:previeImgData];
    [imgObj setCflag:kQQAPICtrlFlagQQShare];
    
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent];
 
}
 
 */


+ (void)shareToWeichatMoments:(NSString *)shareTitle shareDescription:(NSString *)shareDescription shareThumbImg:(NSString *)shareThumbImg shareUrl:(NSString *)shareUrl{
    
    if (![IBCommShare isWXAppInstalled]) {
        return;
    }
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.text = @"";
        req.bText = NO;//不使用文本信息
        req.scene = WXSceneTimeline;//0 = 好友列表 1 = 朋友圈 2 = 收藏
        //创建分享内容对象
        WXMediaMessage *urlMessage = [WXMediaMessage message];
        urlMessage.title = shareTitle; //分享标题
        urlMessage.description = shareDescription;//分享描述
        NSString *imgURL = [NSString stringWithFormat:@"%@", shareThumbImg];
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgURL]];
        [urlMessage setThumbImage:[UIImage imageWithData:data]];//分享图片,使用SDK的setThumbImage方法可压缩图片大小
        
        //创建多媒体对象
        WXWebpageObject *webObj = [WXWebpageObject object];
        webObj.webpageUrl = shareUrl;//分享链接
        
        //完成发送对象实例
        urlMessage.mediaObject = webObj;
        req.message = urlMessage;
        
        //发送分享信息
        [WXApi sendReq:req];
    });
    
}

+ (void)shareToWeichatFriends:(NSString *)shareTitle shareDescription:(NSString *)shareDescription shareThumbImg:(NSString *)shareThumbImg shareUrl:(NSString *)shareUrl {
    if (![IBCommShare isWXAppInstalled]) {
        return;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.text = @"";
        req.bText = NO;//不使用文本信息
        req.scene = WXSceneSession;//0 = 好友列表 1 = 朋友圈 2 = 收藏
        //创建分享内容对象
        WXMediaMessage *urlMessage = [WXMediaMessage message];
        urlMessage.title = shareTitle;//分享标题
        urlMessage.description = shareDescription;//分享描述
        
        //NSString *imgURL = [NSString stringWithFormat:@"%@_200x200.jpg", shareThumbImg];
        NSString *imgURL = [NSString stringWithFormat:@"%@", shareThumbImg];
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgURL]];
        [urlMessage setThumbImage:[UIImage imageWithData:data]];//分享图片,使用SDK的setThumbImage方法可压缩图片大小
        
        //创建多媒体对象
        WXWebpageObject *webObj = [WXWebpageObject object];
        webObj.webpageUrl = shareUrl;//分享链接
        
        //完成发送对象实例
        urlMessage.mediaObject = webObj;
        req.message = urlMessage;
        [WXApi sendReq:req];
    });
}



@end
