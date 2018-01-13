//
//  MKNetworkManager.m
//  Moka
//
//  Created by Knight on 2017/7/25.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKNetworkManager.h"
#import "HTTPApi.h"
#import "CDDate.h"
//当前版本
#define currentSystemVersions     [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

@implementation MKNetworkManager

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"CDShareSport" reason:@"no" userInfo:nil];
}

- (instancetype)initNetworkManager{
    if (self = [super init]) {
        self.myManager = [AFHTTPSessionManager manager];
        _myManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain",@"image/jpeg", nil];
    }
    
    return self;
}


+ (instancetype)sharedManager {
    static MKNetworkManager *_shareAFNHttpRequestOPManager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _shareAFNHttpRequestOPManager = [[self alloc] initNetworkManager];;
        
    });
    
    return _shareAFNHttpRequestOPManager;
}

- (void)checkNetWorkStatusSuccess:(void (^)(id))success{
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
    
        switch (status) {
            case AFNetworkReachabilityStatusUnknown :
                if (success) {
                    success(@"-1");
                }
                break;
            case AFNetworkReachabilityStatusNotReachable:
                if (success) {
                    success(@"0");
                }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                if (success) {
                    success(@"1");
                }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                if (success) {
                    success(@"2");
                }
                break;
        }
    
    }];
    
}

- (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    //NSLog(@"请求!!!!");
    AFSecurityPolicy *policy = [[AFSecurityPolicy alloc] init];
    [policy setAllowInvalidCertificates:YES];
    // 1.获得请求管理者
    AFHTTPSessionManager * mgr = [AFHTTPSessionManager manager];
    // 2.发送GET请求
    [mgr setSecurityPolicy:policy];
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", nil];
    
    //    [mgr.requestSerializer setValue:@"10" forHTTPHeaderField:VOURLCacheAgeKey];
    //    [mgr.requestSerializer setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
    //    [mgr.requestSerializer setValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    mgr.requestSerializer.timeoutInterval = 10.f;
    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    if ([self getToken]) {
        NSString *token = [self getToken];
        NSLog(@"token = %@",token);
        [mgr.requestSerializer setValue:token forHTTPHeaderField:apiTokenKey];
        [mgr.requestSerializer setValue:[NSString stringWithFormat:@"%d",apiVersionValue] forHTTPHeaderField:apiVersionKey];
        [mgr.requestSerializer setValue:currentSystemVersions forHTTPHeaderField:Version];
        [mgr.requestSerializer setValue:[NSString stringWithFormat:@"%d",DEVICE_TYPE] forHTTPHeaderField:device];
    } else {
        DLog(@"TOKEN 不存在!");
    }
    [mgr GET:url parameters:params
     success:^(NSURLSessionDataTask *operation, id responseObj) {
         if (success) {
             success(responseObj);
         }
     } failure:^(NSURLSessionDataTask *operation, NSError *error) {
         if (failure) {
             failure(error);
         }
     }];
}

- (void)gzipPost:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFSecurityPolicy *policy = [[AFSecurityPolicy alloc] init];
    [policy setAllowInvalidCertificates:YES];
    
    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = self.myManager;
    [mgr setSecurityPolicy:policy];
    //    [mgr setreq]
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    mgr.requestSerializer.timeoutInterval = 10.f;
    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    [mgr.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //[mgr.requestSerializer setValue:[NSString stringWithFormat:@"%ld", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    // NSLog(@"%@",jsonData);
    [mgr.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
    if ([self getToken]) {
        NSString *token = [self getToken];
        NSLog(@"token = %@",token);
        [mgr.requestSerializer setValue:token forHTTPHeaderField:apiTokenKey];
        [mgr.requestSerializer setValue:[NSString stringWithFormat:@"%d",apiVersionValue] forHTTPHeaderField:apiVersionKey];
        [mgr.requestSerializer setValue:currentSystemVersions forHTTPHeaderField:Version];
        [mgr.requestSerializer setValue:[NSString stringWithFormat:@"%d",DEVICE_TYPE] forHTTPHeaderField:device];
    } else {
        DLog(@"TOKEN 不存在!");
    }
    // 2.发送POST请求
    [mgr POST:url parameters:params
      success:^(NSURLSessionDataTask *operation, id responseObj) {
          if (success) {
              success(responseObj);
          }
      } failure:^(NSURLSessionDataTask *operation, NSError *error) {
          if (failure) {
              failure(error);
          }
      }];
}

- (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    AFSecurityPolicy *policy = [[AFSecurityPolicy alloc] init];
    [policy setAllowInvalidCertificates:YES];
    
    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = self.myManager;
    [mgr setSecurityPolicy:policy];
    //    [mgr setreq]
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    mgr.requestSerializer.timeoutInterval = 10.f;
    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", nil];
    
    if ([self getToken]) {
        NSString *token = [self getToken];
        NSLog(@"token = %@",token);
        [mgr.requestSerializer setValue:token forHTTPHeaderField:apiTokenKey];
        [mgr.requestSerializer setValue:[NSString stringWithFormat:@"%d",apiVersionValue] forHTTPHeaderField:apiVersionKey];
        [mgr.requestSerializer setValue:currentSystemVersions forHTTPHeaderField:Version];
        [mgr.requestSerializer setValue:[NSString stringWithFormat:@"%d",DEVICE_TYPE] forHTTPHeaderField:device];
    } else {
        DLog(@"TOKEN 不存在!");
    }
    
    // 2.发送POST请求
    [mgr POST:url parameters:params
      success:^(NSURLSessionDataTask *operation, id responseObj) {
          if (success) {
              success(responseObj);
          }
      } failure:^(NSURLSessionDataTask *operation, NSError *error) {
          if (failure) {
              failure(error);
          }
      }];
}

- (NSString *)getToken {
    NSString *token = [[A0SimpleKeychain keychain] stringForKey:apiTokenKey];
    return token;
}

/**
 *  上传文件请求
 */
- (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure dataSource:(CDDate *)dataSource{
    
    
    // 1.获得请求管理者
    AFHTTPSessionManager * mgr = self.myManager;
    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    mgr.requestSerializer.timeoutInterval = 10.f;
    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    if ([self getToken]) {
        NSString *token = [self getToken];
        NSLog(@"token = %@",token);
        [mgr.requestSerializer setValue:token forHTTPHeaderField:apiTokenKey];
        [mgr.requestSerializer setValue:[NSString stringWithFormat:@"%d",apiVersionValue] forHTTPHeaderField:apiVersionKey];
        [mgr.requestSerializer setValue:currentSystemVersions forHTTPHeaderField:Version];
        [mgr.requestSerializer setValue:[NSString stringWithFormat:@"%d",DEVICE_TYPE] forHTTPHeaderField:device];
    }
    [mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:dataSource.data name:dataSource.name fileName:dataSource.filename mimeType:dataSource.mimeType];
    } success:^(NSURLSessionDataTask *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
//上传图片
- (void)post:(NSString *)url params:(NSDictionary *)params image:(UIImage *)myImage success:(void (^ )(id responseObject))success failure:(void (^)(NSError * error))failure{
    
    AFSecurityPolicy *policy = [[AFSecurityPolicy alloc] init];
    [policy setAllowInvalidCertificates:YES];
    
    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = self.myManager;
    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    mgr.requestSerializer.timeoutInterval = 10.f;
    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [mgr setSecurityPolicy:policy];
    //    [mgr setreq]
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain",@"image/jpeg", nil];
    
    if ([self getToken]) {
        NSString *token = [self getToken];
        NSLog(@"token = %@",token);
        [mgr.requestSerializer setValue:token forHTTPHeaderField:apiTokenKey];
        [mgr.requestSerializer setValue:[NSString stringWithFormat:@"%d",apiVersionValue] forHTTPHeaderField:apiVersionKey];
        [mgr.requestSerializer setValue:currentSystemVersions forHTTPHeaderField:Version];
        [mgr.requestSerializer setValue:[NSString stringWithFormat:@"%d",DEVICE_TYPE] forHTTPHeaderField:device];
    } else {
        DLog(@"TOKEN 不存在!");
    }
    [mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData *imageData = UIImageJPEGRepresentation(myImage, 1);
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",WAP_URL,api_myChangePortrait]]) {
            // 上传图片，以文件流的格式
            [formData appendPartWithFileData:imageData name:@"image" fileName:fileName mimeType:@"image/jpeg"];
        }else{
            
            // 上传图片，以文件流的格式
            [formData appendPartWithFileData:imageData name:@"image" fileName:fileName mimeType:@"image/jpeg"];
        }
        
    } success:^(NSURLSessionDataTask *operation, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        failure(error);
    }];
    
    
}


//上传多张图片
- (void)post:(NSString *)url params:(NSDictionary *)params mutiImages:(NSArray *)imagesArray  success:(void (^ )(id responseObject))success failure:(void (^)(NSError * error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    if ([self getToken]) {
        NSString *token = [self getToken];
        NSLog(@"token = %@",token);
        [manager.requestSerializer setValue:token forHTTPHeaderField:apiTokenKey];
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"%d",apiVersionValue] forHTTPHeaderField:apiVersionKey];
        [manager.requestSerializer setValue:currentSystemVersions forHTTPHeaderField:Version];
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"%d",DEVICE_TYPE] forHTTPHeaderField:device];
    } else {
        DLog(@"TOKEN 不存在!");
    }
    [manager POST:url parameters:params constructingBodyWithBlock:^(id< AFMultipartFormData >  _Nonnull formData) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *name = [NSString stringWithFormat:@"%@.jpg", str];
        
        for (int i = 0; i < imagesArray.count; i++) {
            
            //NSData *imageData = UIImageJPEGRepresentation(imagesArray[i], 0.5);
            NSData *imageData = [self oldImage:imagesArray[i] toSize:CGSizeMake(800, 600)];
            NSString *imageName = [NSString stringWithFormat:@"%@[%i]", name, i];
            
            [formData appendPartWithFileData:imageData name:@"image" fileName:imageName mimeType:@"image/png"];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)loginpost:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFSecurityPolicy *policy = [[AFSecurityPolicy alloc] init];
    [policy setAllowInvalidCertificates:YES];
    
    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = self.myManager;
    [mgr setSecurityPolicy:policy];
    //    [mgr setreq]
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [mgr.requestSerializer setValue:currentSystemVersions forHTTPHeaderField:Version];
    [mgr.requestSerializer setValue:[NSString stringWithFormat:@"%d",DEVICE_TYPE] forHTTPHeaderField:device];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain",@"image/jpeg", nil];
    // 2.发送POST请求
    [mgr POST:url parameters:params
      success:^(NSURLSessionDataTask *operation, id responseObj) {
          if (success) {
              success(responseObj);
          }
      } failure:^(NSURLSessionDataTask *operation, NSError *error) {
          if (failure) {
              failure(error);
          }
      }];
}


//上传音频
- (void)post:(NSString *)url params:(NSDictionary *)params voiceFilePath:(NSString *)filePath success:(void (^ )(id responseObject))success failure:(void (^)(NSError * error))failure {
    
    AFSecurityPolicy *policy = [[AFSecurityPolicy alloc] init];
    [policy setAllowInvalidCertificates:YES];
    
    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = self.myManager;
    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    mgr.requestSerializer.timeoutInterval = 10.f;
    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [mgr setSecurityPolicy:policy];
    //    [mgr setreq]
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    if ([self getToken]) {
        NSString *token = [self getToken];
        NSLog(@"token = %@",token);
        [mgr.requestSerializer setValue:token forHTTPHeaderField:apiTokenKey];
        [mgr.requestSerializer setValue:[NSString stringWithFormat:@"%d",apiVersionValue] forHTTPHeaderField:apiVersionKey];
        [mgr.requestSerializer setValue:currentSystemVersions forHTTPHeaderField:Version];
        [mgr.requestSerializer setValue:[NSString stringWithFormat:@"%d",DEVICE_TYPE] forHTTPHeaderField:device];
    } else {
        DLog(@"TOKEN 不存在!");
    }
    [mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *voiceData = [NSData dataWithContentsOfFile:filePath];
        //NSLog(@"voiceData = %@", voiceData);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.mp4", str];
        
        // 上传，以文件流的格式
        [formData appendPartWithFileData:voiceData name:@"voice" fileName:fileName mimeType:@"audio/mpeg4"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

#pragma mark 取消网络请求

- (void)cancelRequest{
    
    NSLog(@"cancelRequest");
    [[[[self class] sharedManager] operationQueue] cancelAllOperations];
    
}

#pragma mark -- 等比例
//等比例压缩
-(NSData *)oldImage:(UIImage *)oldImage toSize:(CGSize)size{
    
    UIImage *newImage = nil;//新照片对象
    CGSize theSize = oldImage.size;//压缩前图片size
    
    CGFloat width = theSize.width; //压缩前图片width
    CGFloat height = theSize.height;//压缩前图片height
    
    CGFloat newWidth = size.width; //压缩后图片width
    CGFloat newHeight = size.height;//压缩后图片height
    
    CGFloat scaleFactor = 0.0;//初值
    
    CGFloat toWidth = newWidth;//压缩后图片width
    CGFloat toHeight = newHeight;//压缩后图片height
    
    CGPoint thumnailPoint = CGPointMake(0.0, 0.0);//给初值
    
    if (CGSizeEqualToSize(theSize, size) == NO) {
        //判断是不是已经满足 theSize = size 要求
        
        CGFloat widthFac = newWidth/width;
        CGFloat heithrFac = newHeight/height;
        if (widthFac > heithrFac) {
            scaleFactor = widthFac;
        }else {
            scaleFactor = heithrFac;
        }
        //不满足做等比例缩小处理
        toWidth = width *scaleFactor;
        toHeight = height *scaleFactor;
        
        if (widthFac > heithrFac) {
            thumnailPoint.y = (newHeight - toHeight)* 0.5;
        }else if (widthFac < heithrFac){
            thumnailPoint.x = (newWidth - toWidth)* 0.5;
        }
    }
    
    //创建context,并将其设置为正在使用的context
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect  = CGRectZero;
    thumbnailRect.origin = thumnailPoint;
    thumbnailRect.size.width = toWidth;
    thumbnailRect.size.height = toHeight;
    
    //绘制出图片(大小已经改变)
    [oldImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //进行图像的画面质量压缩
    NSData *data=UIImageJPEGRepresentation(newImage, 0.4);
    
    return data;
}

@end
