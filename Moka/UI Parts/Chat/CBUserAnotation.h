//
//  CBUserAnotation.h
//  CrunClub
//
//  Created by Knight on 2017/6/9.
//  Copyright © 2017年 Chengdu Sports Club Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CBUserAnotation : NSObject<MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable) NSString *subtitle;
@property (nonatomic, copy, nullable) NSString *userImage;

@end
