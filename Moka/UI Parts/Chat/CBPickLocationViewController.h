//
//  CBPickLocationViewController.h
//  CrunClub
//
//  Created by Knight on 2017/6/17.
//  Copyright © 2017年 Chengdu Sports Club Company. All rights reserved.
//





@protocol CBPickLocationViewControllerDelegate <NSObject>



/**
 *  通知delegate，已经获取到相关的地理位置信息
 *
 *  @param location       location
 *  @param locationName   locationName
 *  @param mapScreenShot  mapScreenShot
 */
- (void)didSelectLocation:(CLLocationCoordinate2D)location
          locationName:(NSString *)locationName
         mapScreenShot:(UIImage *)mapScreenShot;

@end

@interface CBPickLocationViewController : UIViewController

@property (nonatomic, weak) id<CBPickLocationViewControllerDelegate> delegate;

@property (nonatomic, assign) double  latitude;
@property (nonatomic, assign) double  longtitude;
@property (nonatomic, copy) NSString *locationString;

@end
