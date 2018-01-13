//
//  QRCodeVC.m
//

#import "QRCodeVC.h"
#import <AVFoundation/AVFoundation.h>
#import "QRCodeAreaView.h"
#import "QRCodeBacgrouView.h"
#import "UIViewExt.h"
#import "MKWithdrawDetailViewController.h"


#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height

@interface QRCodeVC()<AVCaptureMetadataOutputObjectsDelegate> {
    AVCaptureDevice *captureDevice;
    AVCaptureSession * session;//输入输出的中间桥梁
    QRCodeAreaView *_areaView;//扫描区域视图
    BOOL isFirstLoad;
    BOOL isInScanMode;
    NSString *detectionString;
}




@end

@implementation QRCodeVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        
        NSLog(@"相机权限受限");
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"相机使用权限受限" message:@"请在设置中打开相机使用权限" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionDefault = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:actionDefault];
        [alertController addAction:actionCancel];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!isFirstLoad) {
        //重新开始扫码
        [session startRunning];
        [_areaView startAnimaion];
    }
   
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    isFirstLoad = NO;
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        isInScanMode = YES;
    }
    return self;
}

- (void)restartScan:(NSNotification *) note {
    //重新开始扫码
    [session startRunning];
    [_areaView startAnimaion];
}


-(void)viewDidLoad{
    [super viewDidLoad];
    [self initUserInterface];
    [self setNavigationBarStyle:NavigationBarStyleBlack];
    
    [self setNavigationTitle:@"二维码"];
    [self bringNavigationViewToFront];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(restartScan:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    /**
     *  初始化二维码扫描
     */
    
    //获取摄像设备
    captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:nil];
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //设置识别区域，这个值是按比例0~1设置，而且X、Y要调换位置，width、height调换位置
    output.rectOfInterest = CGRectMake(_areaView.y/screen_height, _areaView.x/screen_width, _areaView.height/screen_height, _areaView.width/screen_width);
    
    //初始化链接对象
    session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if (!input) {
        return;
    }
    
    [session addInput:input];
    [session addOutput:output];
    
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = self.view.layer.bounds;

    [self.view.layer insertSublayer:layer atIndex:0];

    //开始捕获
    [session startRunning];
    
}

- (void)initUserInterface {
    
   
    isFirstLoad = YES;
    
    //扫描区域
    CGRect areaRect = CGRectMake((screen_width - 240)/2, (screen_height - 240)/2.8, 240, 240);
    
    //半透明背景
    QRCodeBacgrouView *bacgrouView = [[QRCodeBacgrouView alloc] initWithFrame:self.view.bounds];
    bacgrouView.scanFrame = areaRect;
    [self.view addSubview:bacgrouView];
    
    //设置扫描区域
    _areaView = [[QRCodeAreaView alloc] initWithFrame:areaRect];
    [self.view addSubview:_areaView];
    
    //提示文字
    UILabel *label = [UILabel new];
    label.text = @"将二维码放入框内，即可完成扫描";
    label.textColor = [UIColor lightGrayColor];
    label.y = CGRectGetMaxY(_areaView.frame) + 20;
    label.font = [UIFont systemFontOfSize:14];
    [label sizeToFit];
    label.center = CGPointMake(_areaView.center.x, label.center.y);
    [self.view addSubview:label];
    
    
}

#pragma 二维码扫描的回调
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count > 0) {
        [session stopRunning];//停止扫描
        [_areaView stopAnimaion];//暂停动画
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex : 0 ];
        //处理扫描结果
        [self handelScanResult:metadataObject];
        
    }
    
}


- (void)handelScanResult:(AVMetadataMachineReadableCodeObject *)metadataObject {
    
    //输出扫描字符串
    detectionString = metadataObject.stringValue;
    NSLog(@"%@",detectionString);
    
    if(!detectionString) {
        return;
    }
   
    
   
    // --------- 二维码 -----------
    if([metadataObject.type isEqualToString:AVMetadataObjectTypeQRCode]){
        
        if (![detectionString hasPrefix:@"http"]) {
            
            MKWithdrawDetailViewController *vc = [[MKWithdrawDetailViewController alloc] init];
            vc.withdrawURL = detectionString;
            [self.navigationController pushViewController:vc animated:YES];
            
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"扫描结果" message:[NSString stringWithFormat:@"%@", detectionString] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        
            UIAlertAction *actionDefault = [UIAlertAction actionWithTitle:@"复制" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                [MKUtilHUD showAutoHiddenTextHUD:@"已复制到剪贴板" withSecond:1.5 inView:self.view];
                NSString *copyStringverse = detectionString;
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                [pasteboard setString:copyStringverse];
            }];
        
        
            [alertController addAction:actionCancel];
            [alertController addAction:actionDefault];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
    }
    
    

}






- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
    
}


@end
