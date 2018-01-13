//
//  MKSelectTagsViewController.m
//  Moka
//
//  Created by Knight on 2017/7/19.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKSelectTagsViewController.h"
#import "MKTabBarViewController.h"
#import "MKTagsCollectionViewCell.h"


@interface MKSelectTagsViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSArray *dataArray;
}
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;

@end

@implementation MKSelectTagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"您感兴趣的标签"];
    [self setupCollectionView];
    [self setRightButtonWithTitle:@"跳过" titleColor:[UIColor whiteColor] imageName:nil addTarget:self action:@selector(skipButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setupCollectionView {
    dataArray = @[@"比特币", @"区域链", @"交友", @"搬砖", @"互联网技术", @"以太坊", @"比特中国", @"挖矿"];
    _myCollectionView.delegate = self;
    _myCollectionView.dataSource = self;
    _myCollectionView.backgroundColor = [UIColor whiteColor];
    [_myCollectionView registerNib:[UINib nibWithNibName:@"MKTagsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MKTagsCollectionViewCell"];
    
    
}

- (void)skipButtonEvent {
    [self gotoMainPage];
}

- (IBAction)startMokaButtonClicked:(UIButton *)sender {
    [self gotoMainPage];
}

- (void)gotoMainPage {
    MKTabBarViewController *tabBarVC = [[MKTabBarViewController alloc] init];
    tabBarVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:tabBarVC animated:YES completion:nil];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return dataArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MKTagsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MKTagsCollectionViewCell" forIndexPath:indexPath];
    [self calculateTopSearchViewRealHeight];
    [cell configWith:dataArray[indexPath.row]];
    return cell;
}

#pragma mark -UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *topSearchWords = dataArray[indexPath.row];
    CGSize textSize = [self textSize:topSearchWords font:[UIFont systemFontOfSize:15.f]];
    CGFloat width = MIN(textSize.width + 60.0f, 290.f);
    //NSLog(@"%@", NSStringFromCGSize(CGSizeMake(width, 25.f)));
    return CGSizeMake(width, 72.f);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(2, 0, 2, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}



- (CGSize)textSize:(NSString *)text font:(UIFont *)font
{
    return [text sizeWithAttributes:@{NSFontAttributeName:font}];
}

- (void)calculateTopSearchViewRealHeight {
    
    CGSize size = self.myCollectionView.contentSize;
    //NSLog(@"%@", NSStringFromCGSize(size));
    self.collectionViewHeight.constant = size.height + 200;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}
//
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    return 0.0;
//}
//
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    CGFloat itemWidth = _myCollectionView.frame.size.width / 4.0 - 8;
//    CGFloat itemHeight = 0;
//    if (iPhone5) {
//        itemHeight = 45;
//    } else {
//        itemHeight = 50;
//    }
//    
//    return CGSizeMake(itemWidth, itemHeight);
//}




@end
