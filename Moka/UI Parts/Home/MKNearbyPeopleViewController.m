//
//  MKNearbyPeopleViewController.m
//  Moka
//
//  Created by Knight on 2017/7/19.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKNearbyPeopleViewController.h"
#import "MKNearbyPeopleCell.h"
#import "MKNearbyLayout.h"
#import "MKNearbyPeopleModel.h"


@interface MKNearbyPeopleViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

{
    NSUInteger      pageNumber;
    NSMutableArray  *nearbyArray;
    NSMutableDictionary *paramDitc;
    CGFloat         cellItemWidth;
    CGFloat         cellItemHeight;
}


@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (weak, nonatomic) IBOutlet MKNearbyLayout *myFlowLayout;
@property (nonatomic, assign) CLLocationCoordinate2D  coordinate2D;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableBottomConstraint;

@end

@implementation MKNearbyPeopleViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.myCollectionView reloadData];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideNavigationView];
    
    [self setupCollectionView];
    pageNumber = 1;
    nearbyArray = @[].mutableCopy;
    paramDitc   = @{}.mutableCopy;
    [paramDitc removeObjectForKey:@"sex"];
    [paramDitc removeObjectForKey:@"smallAge"];
    [paramDitc removeObjectForKey:@"largeAge"];
    
    _coordinate2D.latitude = [[[NSUserDefaults standardUserDefaults] objectForKey:@"coordinatex"] floatValue];
    _coordinate2D.longitude = [[[NSUserDefaults standardUserDefaults] objectForKey:@"coordinatey"] floatValue];
    [self loadNewData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:@"RefreshHomeData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadHomeCacheData) name:@"LoadHomeCacheData" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(followUserSuccess:) name:@"FollowSuccess" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unFollowUserSuccess:) name:@"UnFollowSuccess" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:@"REFRESH_PERSON_PAGE" object:nil];
    
    if (iPhone5) {
        cellItemWidth = 85.;
        cellItemHeight = 146.;
        _tableBottomConstraint.constant = 0;
        
    } else if (iPhone6) {
        
        cellItemWidth = 107.;
        cellItemHeight = 166.;
        _tableBottomConstraint.constant = 0;
    } else if (iPhone6plus) {
        
        cellItemWidth = 120.;
        cellItemHeight = 165.;
         _tableBottomConstraint.constant = 60;
    }
    
    
}

- (void)followUserSuccess:(NSNotification *)noti {
    NSString *targetId = [noti.userInfo objectForKey:@"userId"];
    for (MKNearbyPeopleModel *model in nearbyArray) {
        NSString *modelUserId = [NSString stringWithFormat:@"%ld", (long)model.id];
        if ([modelUserId isEqualToString:targetId]) {
            model.ifFollow = 1;
        }
    }
    [self.myCollectionView reloadData];
}

- (void)unFollowUserSuccess:(NSNotification *)noti {
    NSString *targetId = [noti.userInfo objectForKey:@"userId"];
    for (MKNearbyPeopleModel *model in nearbyArray) {
        NSString *modelUserId = [NSString stringWithFormat:@"%ld", (long)model.id];
        if ([modelUserId isEqualToString:targetId]) {
            model.ifFollow = 0;
        }
    }
    [self.myCollectionView reloadData];
}



-(void)loadHomeCacheData {

    id json = [JsonDataPersistent readJsonDataWithName:@"HomeData"];
    [nearbyArray removeAllObjects];
    for (NSDictionary *dict in json[@"dataObj"]) {
        MKNearbyPeopleModel *model = [[MKNearbyPeopleModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [nearbyArray addObject:model];
    }
    
    [self.myCollectionView reloadData];
    
}


- (void)setupCollectionView {
    _myCollectionView.delegate = self;
    _myCollectionView.dataSource = self;
    
    [_myCollectionView registerNib:[UINib nibWithNibName:@"MKNearbyPeopleCell" bundle:nil] forCellWithReuseIdentifier:@"MKNearbyPeopleCell"];
    [IBRefsh IBheadAndFooterWithRefreshingTarget:self refreshingAction:@selector(loadNewData) andFoootTarget:self refreshingFootAction:@selector(loadMoreData) and:_myCollectionView];
}


- (void)loadNewData {
    
    pageNumber = 1;
    [paramDitc setValue:@(pageNumber) forKey:@"pageNum"];

    
    if (_coordinate2D.latitude != 0.) {
        [paramDitc setValue:@(_coordinate2D.latitude) forKey:@"coordinatex"];
        [paramDitc setValue:@(_coordinate2D.longitude) forKey:@"coordinatey"];
    }
    
    
    [_myCollectionView.mj_footer resetNoMoreData];
    [self requsetNearbyPeoples];
}

- (void)loadMoreData {
    pageNumber ++;
    [paramDitc setValue:@(pageNumber) forKey:@"pageNum"];
    [self requsetNearbyPeoples];
}

//筛选
- (void)filterWithGender:(NSString *)sex
                smallAge:(NSInteger)smallAge
                largeAge:(NSInteger)largeAge {
    pageNumber = 1;
    [paramDitc setValue:@(pageNumber) forKey:@"pageNum"];
    [paramDitc setValue:sex forKey:@"sex"];
    [paramDitc setValue:@(smallAge) forKey:@"smallAge"];
    [paramDitc setValue:@(largeAge) forKey:@"largeAge"];
    [self requsetNearbyPeoples];
}
#pragma mark -http 请求附近的人

- (void)requsetNearbyPeoples {
    
    //[MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL,api_near_people] params:paramDitc success:^(id json) {
        STRONG_SELF;
        //[MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@"附近的人 %@",json);
        [strongSelf.myCollectionView.mj_header endRefreshing];
        [strongSelf.myCollectionView.mj_footer endRefreshing];
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
        if (status == 200) {
            if (pageNumber == 1 && [json[@"dataObj"] count] == 0) {
                //首次加载就无数据
                [nearbyArray removeAllObjects];
                [strongSelf.myCollectionView.mj_footer endRefreshingWithNoMoreData];
                [strongSelf.myCollectionView reloadData];
                return;
            }
            
            if (pageNumber != 1 && [json[@"dataObj"] count] == 0) {
                //无更多数据
                [strongSelf.myCollectionView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            
            if (pageNumber == 1 && [json[@"dataObj"] count] > 0) {
                //下拉刷新(首次加载有数据)
                [nearbyArray removeAllObjects];
                for (NSDictionary *dict in json[@"dataObj"]) {
                    MKNearbyPeopleModel *model = [[MKNearbyPeopleModel alloc] init];
                    [model setValuesForKeysWithDictionary:dict];
                    [nearbyArray addObject:model];
                }
                
                [strongSelf.myCollectionView reloadData];
                //重置上拉刷新
                [strongSelf.myCollectionView.mj_footer resetNoMoreData];
                
                //保存数据
                [JsonDataPersistent saveJsonData:json withName:@"HomeData"];
                
                return;
            }
            
            if (pageNumber != 1 && [json[@"dataObj"] count] > 0) {
                //添加更多数据
                for (NSDictionary *dict in json[@"dataObj"]) {
                    MKNearbyPeopleModel *model = [[MKNearbyPeopleModel alloc] init];
                    [model setValuesForKeysWithDictionary:dict];
                    [nearbyArray addObject:model];
                }
                
                [strongSelf.myCollectionView reloadData];
                
                
                return;
            }
            
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
        }
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        
        
        
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        NSLog(@"%@",error);
        [strongSelf.myCollectionView.mj_header endRefreshing];
        [strongSelf.myCollectionView.mj_footer endRefreshing];
        
        
        
        
    }];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return nearbyArray.count;
}




- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MKNearbyPeopleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MKNearbyPeopleCell" forIndexPath:indexPath];
    [cell configNearbyCellWith:nearbyArray[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectPeople:)]) {
        [self.delegate didSelectPeople:nearbyArray[indexPath.row]];
    }
}

/*
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    //1. Define the initial state (Before the animation)
    cell.transform = CGAffineTransformMakeTranslation(0.f, 80);
    cell.transform = CGAffineTransformMakeScale(0.5, 0.5);
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    
    //2. Define the final state (After the animation) and commit the animation
    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:0.5];
    cell.transform = CGAffineTransformMakeTranslation(0.f, 0);
    cell.transform = CGAffineTransformMakeScale(1.f, 1);
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
}
 
 */

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    return CGSizeMake(cellItemWidth, cellItemHeight);
}

//- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == nearbyArray.count - 6) {
//        [self loadMoreData];
//    }
//}

- (BOOL)isTop {
    if (self.myCollectionView.contentOffset.y == 0) {
        return YES;
    } else {
        return NO;
    }
}


- (void)scrollToTop {
    [self.myCollectionView scrollToTop];
}

@end
