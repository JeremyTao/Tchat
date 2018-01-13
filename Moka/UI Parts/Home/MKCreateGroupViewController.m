//
//  MKCreateGroupViewController.m
//  Moka
//
//  Created by Knight on 2017/7/21.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKCreateGroupViewController.h"
#import "MKCreateGroupCell.h"
#import "MKGroupTypeViewController.h"

@interface MKCreateGroupViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation MKCreateGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setMyTableView];
    [self setNavigationTitle:@"类型"];
}

- (void)setMyTableView {
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.rowHeight = 80;
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"MKCreateGroupCell" bundle:nil] forCellReuseIdentifier:@"MKCreateGroupCell"];
    self.myTableView.tableFooterView = [UIView new];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKCreateGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKCreateGroupCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MKGroupTypeViewController *vc = [[MKGroupTypeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
