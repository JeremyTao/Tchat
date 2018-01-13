//
//  KSNoNetView.m
//  Test
//
//  Created by KS on 15/11/25.
//  Copyright © 2015年 xianhe. All rights reserved.
//

#import "KSNoNetView.h"

@implementation KSNoNetView

+ (instancetype) instanceNoNetView
{
    static KSNoNetView* noNetView = nil;

    
    noNetView = [[[NSBundle mainBundle]loadNibNamed:@"KSNoNetView" owner:self options:nil]lastObject];
    noNetView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    return noNetView;
}

- (IBAction)reloadNetworkDataSource:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(reloadNetworkDataSource)]) {
        [self.delegate performSelector:@selector(reloadNetworkDataSource) withObject:sender];
    }
}
@end
