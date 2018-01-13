//
//  MKNetworkManager.h
//  Moka
//
//  Created by Knight on 2017/7/25.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
//#import "CDDate.h"

@interface MKNetworkManager : NSObject

@property (nonatomic,strong) AFHTTPSessionManager *myManager;

//网络请求单例
+ (instancetype)sharedManager;

//检查网络状态
- (void)checkNetWorkStatusSuccess:(void (^)(id str))success;

//get 请求
- (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

//post 请求
- (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

//图片上传
- (void)post:(NSString *)url params:(NSDictionary *)params image:(UIImage *)myImage success:(void (^ )(id responseObject))success failure:(void (^)(NSError * error))failure;

- (void)post:(NSString *)url params:(NSDictionary *)params mutiImages:(NSArray *)imagesArray  success:(void (^ )(id responseObject))success failure:(void (^)(NSError * error))failure;

//音频上传
- (void)post:(NSString *)url params:(NSDictionary *)params voiceFilePath:(NSString *)filePath success:(void (^ )(id responseObject))success failure:(void (^)(NSError * error))failure;

//大文件上传
- (void)gzipPost:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure;

//登录 post
- (void)loginpost:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure;

@end
