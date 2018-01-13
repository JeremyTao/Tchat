//
//  CBNOData.h
//  CrunClub
//
//  Created by 郑克 on 16/4/5.
//  Copyright © 2016年 sanfenqiu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol KSNoDataViewDelegate  <NSObject>

- (void)reloadDataworkDataSource;

@end
@interface CBNOData : UIView
@property (nonatomic, strong) id<KSNoDataViewDelegate>delegate;

/**
 *  初始化方法,可以自定义,
 *
 *  @return KSNotNetView
 */
+ (instancetype) instanceNoDataView;

- (IBAction)refshBtn:(id)sender;

@end
