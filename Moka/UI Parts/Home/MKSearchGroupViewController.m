//
//  MKSearchGroupViewController.m
//  Moka
//
//  Created by Knight on 2017/7/21.
//  Copyright © 2017年 moka. All rights reserved.
//


#import "MKSearchGroupViewController.h"
#import "PYSearchConst.h"
#import "MKRecomondGroupCell.h"
#import "MKInterestTagModel.h"
#import "MKGroupInfoViewController.h"

@interface MKSearchGroupViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

{
    NSMutableArray *myTagsArray;    //标签
    NSArray        *tagsArr;        ///<Label*>数组
    NSMutableArray *tagModelArray;   //标签模型数字
    NSInteger      lastClickIndex;
    
    NSUInteger pageNumber;
    NSUInteger pageSize;
    NSMutableArray *circleArray;
    NSString   *searchLabelId;
    NSString   *selectTagName;
}


@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSearchViewHeight;//热门搜索View高度
@property (weak, nonatomic) IBOutlet UIView *hotSearchView;
@property (weak, nonatomic) IBOutlet UILabel *navigationTitle;
@property (weak, nonatomic) IBOutlet UIView *noDataView;


@end

@implementation MKSearchGroupViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideNavigationView];
    self.title = @"搜索";
    [self setupTextField];
    [self setMyTableView];
    
    myTagsArray   = @[].mutableCopy;
    tagModelArray = @[].mutableCopy;
    circleArray   = @[].mutableCopy;
    pageNumber    = 1;
    pageSize      = 20;
    
    [self requestGetTags];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCircle) name:@"RefreshCircle" object:nil];
}

- (void)refreshCircle {
    [self.myTableView reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshCircleHome" object:nil];
}

- (void)setupTextField {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 1)];
    self.searchTextField.leftView = view;
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    self.searchTextField.placeholder = @"搜索圈子ID或圈子名";
    UIImageView *rightView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 24)];
    rightView.contentMode = UIViewContentModeScaleAspectFit;
    rightView.image = [UIImage imageNamed:@"search"];
    _searchTextField.rightView = rightView;
    _searchTextField.rightViewMode = UITextFieldViewModeAlways;
    [self.searchTextField becomeFirstResponder];
    self.searchTextField.delegate = self;
    [self.searchTextField addTarget:self  action:@selector(textFieldChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    //_searchTextField.textAlignment = NSTextAlignmentCenter;
}

- (void)setMyTableView {
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.rowHeight = 120;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.myTableView registerNib:[UINib nibWithNibName:@"MKRecomondGroupCell" bundle:nil] forCellReuseIdentifier:@"MKRecomondGroupCell"];
    [IBRefsh IBheadAndFooterWithRefreshingTarget:self refreshingAction:@selector(loadNewData) andFoootTarget:self refreshingFootAction:@selector(loadMoreData) and:self.myTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return circleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKRecomondGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKRecomondGroupCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configCellWith:circleArray[indexPath.row]];
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    lastClickIndex = indexPath.row;
    MKCircleListModel *model = circleArray[indexPath.row];
    MKGroupInfoViewController *groupInfoVC = [[MKGroupInfoViewController alloc] init];
    groupInfoVC.circleListModel = model;
    [self.navigationController pushViewController:groupInfoVC animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.text.length > 0) {
        [self requestSearchResults];
    }
    
    return YES;
}

- (void)textFieldChanged:(UITextField *)textField {
    if (textField.text.length == 0) {
        _myTableView.hidden = YES;
        self.noDataView.hidden = YES;
        [circleArray removeAllObjects];
        pageNumber = 1;
        self.navigationTitle.text = @"搜索";
        
        [_myTableView reloadData];
    }
}

- (void)loadNewData {
    pageNumber = 1;
    [self.myTableView.mj_footer resetNoMoreData];
    [self requestSearchResults];
}

- (void)loadMoreData {
    pageNumber ++;
    [self requestSearchResults];
}

#pragma mark - http :获取标签

- (void)requestGetTags {
    NSDictionary *param = @{@"state":@(6)};
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL,api_getTags] params:param success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        NSLog(@"获取标签 %@",json);
        if (status == 200) {
            
            for (NSDictionary *dict in json[@"dataObj"]) {
                MKInterestTagModel *model = [[MKInterestTagModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [tagModelArray addObject:model];
                [myTagsArray addObject:model.name];
            }
            //创建标签视图
            [strongSelf removeTagsWith:tagsArr];
            tagsArr = [strongSelf createMovieLabelsWithContentView:_hotSearchView
                                                  layoutConstraint:_topSearchViewHeight
                                                         tagsArray:myTagsArray];
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
        }
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        
        
        NSLog(@"%@",error);
        
    }];
    
}

#pragma mark - HTTP: search request

- (void)requestSearchResults {
    self.myTableView.hidden = NO;
    //
    NSString * str1 = [_searchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //
    NSDictionary *param = @{@"pageNum" : @(pageNumber),
                            @"pageSize": @(pageSize),
                            @"query"   : str1 ? str1 : @"",
                            @"lableids": searchLabelId ? searchLabelId : @""};
   // NSString *title = _searchTextField.text.length > 0 ? _searchTextField.text : selectTagName;
//    self.navigationTitle.text = [NSString stringWithFormat:@"搜索“%@”结果", title];
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL,api_find_circle] params:param success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        NSLog(@"推荐的圈子 %@",json);
        [strongSelf.myTableView.mj_header endRefreshing];
        [strongSelf.myTableView.mj_footer endRefreshing];
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
        if (status == 200) {
            NSArray *listAll = json[@"dataObj"][@"listAll"];
            if (pageNumber == 1 && [listAll count] == 0) {
                //首次加载就无数据
                [circleArray removeAllObjects];
                [strongSelf.myTableView.mj_footer endRefreshingWithNoMoreData];
                [strongSelf.myTableView reloadData];
                _noDataView.hidden = NO;
                
                return;
            }
            
            if (pageNumber != 1 && [listAll count] == 0) {
                //无更多数据
                [strongSelf.myTableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            
            _noDataView.hidden = YES;
            
            if (pageNumber == 1 && [listAll count] > 0) {
                //下拉刷新
                [circleArray removeAllObjects];
                for (NSDictionary *dict in listAll) {
                    MKCircleListModel *model = [[MKCircleListModel alloc] init];
                    [model setValuesForKeysWithDictionary:dict];
                    [circleArray addObject:model];
                }
                
                [strongSelf.myTableView reloadData];
                //重置上拉刷新
                [strongSelf.myTableView.mj_footer resetNoMoreData];
                return;
            }
            
            if (pageNumber != 1 && [listAll count] > 0) {
                //添加更多数据
                for (NSDictionary *dict in listAll) {
                    MKCircleListModel *model = [[MKCircleListModel alloc] init];
                    [model setValuesForKeysWithDictionary:dict];
                    [circleArray addObject:model];
                }
                
                [strongSelf.myTableView reloadData];
                return;
            }

        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
        }
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        NSLog(@"%@",error);
        [strongSelf.myTableView.mj_header endRefreshing];
        [strongSelf.myTableView.mj_footer endRefreshing];
    }];

}



#pragma mark - 创建标签
- (NSArray *)createMovieLabelsWithContentView:(UIView *)contentView layoutConstraint:(NSLayoutConstraint *)heightConstraint tagsArray:(NSArray *)tagTexts {
    if (tagTexts.count == 0) {
        return nil;
    }
    
    
    NSMutableArray *tagsM = [NSMutableArray array];
    for (int i = 0; i < tagTexts.count; i++) {
        UILabel *label = [self labelWithTitle:tagTexts[i]];
        [contentView addSubview:label];
        [tagsM addObject:label];
        label.tag = 1000 + i;
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTagLabel:)];
        [label addGestureRecognizer:tap];
    }
    
    CGFloat currentX = 0;
    CGFloat currentY = 0;
    CGFloat countRow = 0;
    CGFloat countCol = 0;
    CGFloat offsetX = 15;
    CGFloat offsetY = 10;
    
    
    for (int i = 0; i < contentView.subviews.count; i++) {
        UILabel *subView = contentView.subviews[i];
        // When the number of search words is too large, the width is width of the contentView
        if (subView.py_width > contentView.py_width) subView.py_width = contentView.py_width;
        if (currentX + subView.py_width + PYSEARCH_MARGIN * countRow > contentView.py_width) {
            subView.py_x = offsetX;
            subView.py_y = (currentY += subView.py_height) + PYSEARCH_MARGIN * ++countCol + offsetY;
            currentX = subView.py_width;
            countRow = 1;
        } else {
            subView.py_x = (currentX += subView.py_width) - subView.py_width + PYSEARCH_MARGIN * countRow + offsetX;
            subView.py_y = currentY + PYSEARCH_MARGIN * countCol + offsetY;
            countRow ++;
        }
    }
    
    contentView.py_height = CGRectGetMaxY(contentView.subviews.lastObject.frame);
    heightConstraint.constant = contentView.py_height + 10;
    
    [self.view layoutIfNeeded];
    //设置边框
    for (UILabel *tag in tagsM) {
        tag.backgroundColor = [UIColor clearColor];
        tag.layer.borderColor = RGB_COLOR_HEX(0xC4D0FF).CGColor;
        tag.layer.borderWidth = 1;
        tag.layer.cornerRadius = tag.py_height * 0.5;
    }
    
    return tagsM;
}

#pragma mark - 标签点击

- (void)tapTagLabel:(UITapGestureRecognizer *)gr {
    UILabel *label = (UILabel *)gr.view;
    NSInteger index = label.tag - 1000;
    PYSEARCH_LOG(@"点击标签 %@, index %ld", label.text, (long)index);
    //从模型数组取出model
    MKInterestTagModel *tagModel = tagModelArray[index];
    searchLabelId  =  [NSString stringWithFormat:@"%ld", (long)tagModel.id];
    selectTagName  = tagModel.name;
    
    [self.view endEditing:YES];
    [self requestSearchResults];
}


- (UILabel *)labelWithTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc] init];
    label.userInteractionEnabled = YES;
    label.font = [UIFont systemFontOfSize:12];
    label.text = title;
    label.textColor = RGB_COLOR_HEX(0x666666);
    label.backgroundColor = [UIColor whiteColor];
    label.layer.cornerRadius = 3;
    label.clipsToBounds = YES;
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    label.py_width += 30;
    label.py_height += 20;
    return label;
}

- (void)removeTagsWith:(NSArray *)arr {
    for (UILabel *label in arr) {
        [label removeFromSuperview];
    }
}



- (IBAction)backButtonEvent:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
