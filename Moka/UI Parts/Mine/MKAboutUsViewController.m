//
//  MKAboutUsViewController.m
//  Moka
//
//  Created by  moka on 2017/8/22.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKAboutUsViewController.h"
#import <Messages/Messages.h>
#import <MessageUI/MessageUI.h>
#import "MKUserAgreementViewController.h"

#define MOKA_EMAIL @"business@btc123.com"

@interface MKAboutUsViewController ()<MFMailComposeViewControllerDelegate>
{
    NSString *_downURLStr;
    NSString *_msgStr;
}
@property (weak, nonatomic) IBOutlet UILabel *appVersionLabel;

- (IBAction)checkUpdateClick:(UIButton *)sender;

@end

@implementation MKAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"关于我们"];
    self.title = @"关于我们";
    
    self.appVersionLabel.text = [NSString stringWithFormat:@"钛值 v%@",currentPhoneSystemVersion];
}

- (IBAction)gotoWebHomePage:(UIButton *)sender {
    //跳转到对应网页(外部, 使用Safari打开)
    
    if (IOS10) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.t.top"] options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.t.top"]];
    }
    
}

- (IBAction)sendEmail:(UIButton *)sender {
    // 1. 先判断能否发送邮件
    if (![MFMailComposeViewController canSendMail]) {
        // 提示用户设置邮箱
        NSURL *mailURL = [NSURL URLWithString:@"mailto:business@btc123.com"];
        [[UIApplication sharedApplication] openURL:mailURL];
        return;
    }
    
    // 2. 实例化邮件控制器，准备发送邮件
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    
    // 1) 主题 xxx的工作报告
    [controller setSubject:@""];
    // 2) 收件人
    [controller setToRecipients:@[MOKA_EMAIL]];
    
    // 3) cc 抄送
    // 4) bcc 密送(偷偷地告诉，打个小报告)
    // 5) 正文
    [controller setMessageBody:@"" isHTML:YES];
    
    // 6) 附件
//    UIImage *image = [UIImage imageNamed:@"1.png"];
//    NSData *imageData = UIImagePNGRepresentation(image);
    // 1> 附件的二进制数据
    // 2> MIMEType 使用什么应用程序打开附件
    // 3> 收件人接收时看到的文件名称
    // 可以添加多个附件
//    [controller addAttachmentData:imageData mimeType:@"image/png" fileName:@"头像.png"];
    
    // 7) 设置代理
    [controller setMailComposeDelegate:self];
    
    // 显示控制器
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - 邮件代理方法
/**
 MFMailComposeResultCancelled,      取消
 MFMailComposeResultSaved,          保存邮件
 MFMailComposeResultSent,           已经发送
 MFMailComposeResultFailed          发送失败
 */
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    // 根据不同状态提示用户
    NSLog(@"%ld", (long)result);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)seeUserInstruction:(UIButton *)sender {
    MKUserAgreementViewController *vc = [[MKUserAgreementViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//更新版本
- (IBAction)checkUpdateClick:(UIButton *)sender {
    
    //获取当前版本
    NSDictionary *info= [[NSBundle mainBundle] infoDictionary];
    NSString *versionCode = [NSString stringWithFormat:@"%@",info[@"CFBundleVersion"]];
    NSDictionary *paraDic = @{@"os": @"1",
                              @"currentVersion":versionCode
                              };
    //
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL,api_checkAppUpdate] params:paraDic success:^(id json) {
        DLog(@"版本更新 %@", json);
        if ([json[@"status"] isEqualToString:@"200"]) {
            _downURLStr = json[@"dataObj"][@"downloadUrl"];
            //转换
            _msgStr = [NSString stringWithFormat:@"%@",[json[@"dataObj"][@"msg"] stringByReplacingOccurrencesOfString:@"\\n" withString:@" \r\n" ]];
            //更新
            int code = [json[@"dataObj"][@"updateType"] intValue];
            
            if (code == 0) {
                [self alertNoticeUpdate];
            }else{
                //强制更新
                [self alertNoticeMustUpdate];
            }
            
        }else{
            [MKUtilHUD showHUD:json[@"exception"] inView:nil];
        }
    } failure:^(NSError *error) {
        DLog(@"版本更新检查失败 %@", error);
    }];
}

-(void)alertNoticeUpdate{
    //有新版本
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"更新提示" message:_msgStr preferredStyle:UIAlertControllerStyleAlert];
    //行设置
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    //行间距
    paragraphStyle.lineSpacing = 5.0;
    //字体
    NSDictionary * attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14.0], NSParagraphStyleAttributeName : paragraphStyle};
    //
    NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:_msgStr];
    [attributedTitle addAttributes:attributes range:NSMakeRange(0, _msgStr.length)];
    [alertController setValue:attributedTitle forKey:@"attributedMessage"];
    //
    [alertController addAction:[UIAlertAction actionWithTitle:@"去下载" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        [self gotoAppStore];
        
    }]];
    //取消
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    //
    [self presentViewController:alertController animated:YES completion:nil];
}


-(void)alertNoticeMustUpdate{
    //有新版本
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"更新提示" message:_msgStr preferredStyle:UIAlertControllerStyleAlert];
    //行设置
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    //行间距
    paragraphStyle.lineSpacing = 5.0;
    //字体
    NSDictionary * attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14.0], NSParagraphStyleAttributeName : paragraphStyle};
    //
    NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:_msgStr];
    [attributedTitle addAttributes:attributes range:NSMakeRange(0, _msgStr.length)];
    [alertController setValue:attributedTitle forKey:@"attributedMessage"];
    //
    [alertController addAction:[UIAlertAction actionWithTitle:@"去下载" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        [self gotoAppStore];
        
    }]];
    //
    [self presentViewController:alertController animated:YES completion:nil];
}




-(void)gotoAppStore{
    if (IOS10) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_downURLStr] options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_downURLStr]];
    }
}
@end
