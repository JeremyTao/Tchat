//
//  MKChatHeaderView.m
//  Moka
//
//  Created by  moka on 2017/8/11.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKChatHeaderView.h"
#import "MKNearbyPeopleCell.h"
#import "MKHelloFansCountModel.h"

@interface MKChatHeaderView ()<UICollectionViewDataSource, UICollectionViewDelegate>

{
    NSMutableArray *dataSource;
}

@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;

@property (weak, nonatomic) IBOutlet UIView *sayHelloView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sayHelloViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *sayHelloTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sayHelloContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *sayHelloTimeLabel;


@property (weak, nonatomic) IBOutlet UIView *fansView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fansViewHeight;

@property (weak, nonatomic) IBOutlet UILabel *fansTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *fansContentLabel;

@property (weak, nonatomic) IBOutlet UILabel *fansTimeLabel;

@end

@implementation MKChatHeaderView


+ (instancetype)newChatHeaderView {
    MKChatHeaderView *customView = [[[NSBundle mainBundle] loadNibNamed:@"MKChatHeaderView" owner:nil options:nil] objectAtIndex:0];
    if ([customView isKindOfClass:[MKChatHeaderView class]]) {
        
        customView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
        return customView;
    }
    else
        return nil;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupCollectionView];
    self.hidden = YES;
    dataSource = @[].mutableCopy;
}

- (void)setupCollectionView {
    _myCollectionView.delegate = self;
    _myCollectionView.dataSource = self;
    [_myCollectionView registerNib:[UINib nibWithNibName:@"MKNearbyPeopleCell" bundle:nil] forCellWithReuseIdentifier:@"MKNearbyPeopleCell"];
    
}

- (void)configOnlinePeopleWith:(NSArray *)onlineArray {
    dataSource = [onlineArray mutableCopy];
    if (dataSource.count == 0) {
        _myCollectionView.hidden = YES;
        _collectionViewHeight.constant = 0;
    } else {
        self.hidden = NO;
        _myCollectionView.hidden = NO;
        _collectionViewHeight.constant = 100;
    }
    [_myCollectionView reloadData];
    
}


- (void)configSayHelloAndFansWith:(MKHelloFansCountModel *)model {
    
    if (model.sayHelloSize == 0) {
        _sayHelloView.hidden = YES;
        _sayHelloViewHeight.constant = 0;
    } else {
        self.hidden = NO;
        _sayHelloView.hidden = NO;
        _sayHelloViewHeight.constant = 60;
    }
    
    if (model.followSize == 0) {
        _fansView.hidden = YES;
        _fansViewHeight.constant = 0;
    } else {
        _fansView.hidden = NO;
        self.hidden = NO;
        _fansViewHeight.constant = 60;
    }
    
    _sayHelloTitleLabel.text = [NSString stringWithFormat:@"附近有%ld个人和你打招呼", (long)model.sayHelloSize];
    _sayHelloContentLabel.text = model.sayHello;
    _sayHelloTimeLabel.text = [NSString compareCurrentTime:model.sayHelloTime];
    
    _fansTitleLabel.text = [NSString stringWithFormat:@"您有%ld个新粉丝",(long)model.followSize];
    _fansContentLabel.text = model.follow;
    _fansTimeLabel.text = [NSString compareCurrentTime:model.followTime];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return dataSource.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MKNearbyPeopleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MKNearbyPeopleCell" forIndexPath:indexPath];
    [cell setSmallSize:YES];
    [cell configOnlinePeopleWith:dataSource[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    MKOnlineModel *onlineModel = dataSource[indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedOnlinePeopleWith:)]) {
        [self.delegate didClickedOnlinePeopleWith:onlineModel];
    }
    
}



- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1.0;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemWidth = 62.5;
    CGFloat itemHeight = itemWidth + 25;
    
    if (iPhone6plus) {
        itemWidth += 12;
        itemHeight += 5;
    }
    
    return CGSizeMake(itemWidth, itemHeight);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(2, 12, 8, 12);
}

- (IBAction)sayHelloButtonClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedSayHelloButton)]) {
        [self.delegate didClickedSayHelloButton];
    }
}

- (IBAction)newFansButtonClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedNewFansButton)]) {
        [self.delegate didClickedNewFansButton];
    }
}

- (IBAction)toKefuClicked:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedToKeFuButton)]) {
        
        [self.delegate didClickedToKeFuButton];
    }
}


@end
