//
//  CBNOData.m
//  CrunClub
//
//  Created by 郑克 on 16/4/5.
//  Copyright © 2016年 sanfenqiu. All rights reserved.
//

#import "CBNOData.h"

@implementation CBNOData

+ (instancetype) instanceNoDataView
{
    static CBNOData* noNetView = nil;
    
    
    noNetView = [[[NSBundle mainBundle]loadNibNamed:@"CBNOData" owner:self options:nil]lastObject];
    noNetView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    return noNetView;
}

- (IBAction)refshBtn:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(reloadDataworkDataSource)]) {
        [self.delegate performSelector:@selector(reloadDataworkDataSource) withObject:sender];
    }
    
    
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}

@end
