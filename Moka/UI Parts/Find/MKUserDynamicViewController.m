//
//  MKUserDynamicViewController.m
//  Moka
//
//  Created by Knight on 2017/8/6.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKUserDynamicViewController.h"
#import "MKDynamicTableViewCell.h"

@interface MKUserDynamicViewController ()<UITableViewDataSource, UITableViewDelegate, MKDynamicTableViewCellDelegate>




@end

@implementation MKUserDynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideNavigationView];
    [self setMyTableView];
}

- (void)setMyTableView {
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.estimatedRowHeight = 500;
    self.myTableView.rowHeight = UITableViewAutomaticDimension;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.myTableView registerNib:[UINib nibWithNibName:@"MKDynamicTableViewCell" bundle:nil] forCellReuseIdentifier:@"MKDynamicTableViewCell"];

    //[IBRefsh IBheadAndFooterWithRefreshingTarget:self refreshingAction:@selector(loadNewData) andFoootTarget:self refreshingFootAction:@selector(loadMoreData) and:self.myTableView];
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKDynamicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKDynamicTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.type = DynamicCellTypeHome;
    cell.delegate = self;
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectDynamic)]) {
//        [self.delegate didSelectDynamic];
//    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y == 0) {
        self.myTableView.userInteractionEnabled = NO;
    }
    
}



@end
