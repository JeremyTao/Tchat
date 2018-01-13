//
//  XWCountryCodeController.m
//  XWCountryCodeDemo
//
//  Created by 邱学伟 on 16/4/19.
//  Copyright © 2016年 邱学伟. All rights reserved.
//

#import "XWCountryCodeController.h"


//判断系统语言
#define CURR_LANG ([[NSLocale preferredLanguages] objectAtIndex:0])
#define LanguageIsEnglish ([CURR_LANG isEqualToString:@"en-US"] || [CURR_LANG isEqualToString:@"en-CA"] || [CURR_LANG isEqualToString:@"en-GB"] || [CURR_LANG isEqualToString:@"en-CN"] || [CURR_LANG isEqualToString:@"en"])

@interface XWCountryCodeController()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate, UIScrollViewDelegate, UITextFieldDelegate>{
    //国际代码主tableview
    UITableView *countryCodeTableView;
    //结果tableview
    UITableView *searchTableView;
    //取消按钮
    UIButton   *cancelButton;
    //搜索

    UITextField *searchTextField;

    //代码字典
    NSDictionary *sortedNameDict; 
    
    NSArray *indexArray;
    NSMutableArray *searchResultValuesArray;
    
    
}

@end

@interface XWCountryCodeController ()

@end

@implementation XWCountryCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    //背景
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //顶部标题
    [self setNavigationTitle:@"选择国家或地区"];
    
    //创建子视图
    [self creatSubviews];
}
 //创建子视图
-(void)creatSubviews{
    searchResultValuesArray = [[NSMutableArray alloc] init];
    [self setupSearchTextField];
    [self setupSearchTableView];

    NSString *plistPathCH = [[NSBundle mainBundle] pathForResource:@"sortedChnames" ofType:@"plist"];
    NSString *plistPathEN = [[NSBundle mainBundle] pathForResource:@"sortedEnames" ofType:@"plist"];
    
    //判断当前系统语言
    if (LanguageIsEnglish) {
        sortedNameDict = [NSDictionary dictionaryWithContentsOfFile:plistPathEN];
    }else{
        sortedNameDict = [NSDictionary dictionaryWithContentsOfFile:plistPathCH];
    }
    
    indexArray = [sortedNameDict allKeys];
    indexArray = [indexArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    //NSLog(@"sortedChnamesDict %@",sortedNameDict);

}



- (void)setupSearchTextField {
    searchTextField = [[UITextField alloc] init];
    searchTextField.delegate = self;
    [searchTextField addTarget:self action:@selector(searchTextChanged:) forControlEvents:UIControlEventAllEditingEvents];
    searchTextField.frame = CGRectMake(15, 10, SCREEN_WIDTH - 30, 30);
    searchTextField.borderStyle = UITextBorderStyleNone;
    searchTextField.layer.cornerRadius = 15;
    searchTextField.backgroundColor = RGB_COLOR_HEX(0xE9EDFE);
    searchTextField.font = [UIFont systemFontOfSize:14];
    searchTextField.placeholder = @"Search";
    searchTextField.returnKeyType = UIReturnKeySearch;
    searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchTextField.clearsOnBeginEditing = YES;
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 1)];
    searchTextField.leftView = leftView;
    searchTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *rightView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 24)];
    rightView.contentMode = UIViewContentModeScaleAspectFit;
    rightView.image = [UIImage imageNamed:@"search"];
    searchTextField.rightView = rightView;
    searchTextField.rightViewMode = UITextFieldViewModeAlways;
}

- (void)setupSearchTableView {
    countryCodeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64) style:UITableViewStylePlain];
    [self.view addSubview:countryCodeTableView];
    countryCodeTableView.tag = 1000;
    
    searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 114, self.view.bounds.size.width, self.view.bounds.size.height-114) style:UITableViewStylePlain];
    searchTableView.backgroundColor = [UIColor whiteColor];
    searchTableView.dataSource = self;
    searchTableView.delegate = self;
    [self.view addSubview:searchTableView];
    [searchTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"searchTableViewCell"];
    searchTableView.tag = 2000;
    searchTableView.alpha = 0.f;
    
    //自动调整自己的宽度，保证与superView左边和右边的距离不变。
    [countryCodeTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [countryCodeTableView setDataSource:self];
    [countryCodeTableView setDelegate:self];
    [countryCodeTableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    countryCodeTableView.tintColor = RGB_COLOR_HEX(0x7894F9);
    
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    tableHeaderView.backgroundColor = [UIColor whiteColor];
    [tableHeaderView addSubview:searchTextField];
    countryCodeTableView.tableHeaderView = tableHeaderView;
    [self.view bringSubviewToFront:searchTableView];
    
    //cancelButton
    cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, 10, 40, 30);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:RGB_COLOR_HEX(0x7894F9) forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [tableHeaderView addSubview:cancelButton];
    [cancelButton addTarget:self action:@selector(cancelSearch) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tableHeaderView.mas_top).offset(10);
        make.left.equalTo(searchTextField.mas_right).offset(15);
        make.width.equalTo(@40);
        make.height.equalTo(@30);
    }];
    
}

- (void)cancelSearch {

    [self.view endEditing:YES];
    [countryCodeTableView reloadSectionIndexTitles];
    [UIView animateWithDuration:0.2 animations:^{
        searchTableView.alpha = 0;
        searchTextField.text = @"";
        //countryCodeTableView.sectionIndexColor = RGB_COLOR_HEX(0x7894F9);
        searchTextField.frame = CGRectMake(15, 10, SCREEN_WIDTH - 30, 30);
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
    
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [searchResultValuesArray removeAllObjects];
    [searchTableView reloadData];
    [countryCodeTableView reloadSectionIndexTitles];
    [UIView animateWithDuration:0.2 animations:^{
        searchTableView.alpha = 1.0;
        //countryCodeTableView.sectionIndexColor = [UIColor clearColor];
        searchTextField.frame = CGRectMake(15, 10, SCREEN_WIDTH - 80, 30);
        [self.view layoutIfNeeded];
    }];
    return YES;
}




- (void)searchTextChanged:(UITextField *)textField {
    
    if (textField.text.length > 0 ) {
        [searchResultValuesArray removeAllObjects];
        
        for (NSArray *array in [sortedNameDict allValues]) {
            for (NSString *value in array) {
                if ([value containsString:textField.text]) {
                    [searchResultValuesArray addObject:value];
                }
            }
        }
        [searchTableView reloadData];

    }
    
    
}



#pragma mark - UITableView 
//section
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    if (tableView.tag == 1000) {
        return [sortedNameDict allKeys].count;
    } else {
        return 1;
    }
}
//row
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView.tag == 1000) {
        NSArray *array = [sortedNameDict objectForKey:[indexArray objectAtIndex:section]];
        return array.count;
    } else {
        return [searchResultValuesArray count];

    }

}
//height
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
//初始化cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 1000) {
        static NSString *ID1 = @"cellIdentifier1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID1];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID1];
        }
        //初始化cell数据!
        NSInteger section = indexPath.section;
        NSInteger row = indexPath.row;
        
        cell.textLabel.text = [[sortedNameDict objectForKey:[indexArray objectAtIndex:section]] objectAtIndex:row];
        [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
        cell.textLabel.textColor = RGB_COLOR_HEX(0x2a2a2a);
        return cell;
    }else{
        static NSString *ID2 = @"cellIdentifier2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID2];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID2];
        }
        if ([searchResultValuesArray count] > 0) {
            cell.textLabel.text = [searchResultValuesArray objectAtIndex:indexPath.row];
            [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
            cell.textLabel.textColor = RGB_COLOR_HEX(0x2a2a2a);
        }
        return cell;
    }
}
//indexTitle
-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    if (tableView.tag == 1000 && !searchTextField.isFirstResponder) {
        return indexArray;
    }else{
        return nil;
    }
}
//
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    if (tableView.tag == 1000) {
        return index;
    }else{
        return 0;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == 1000) {
        if (section == 0) {
            return 0;
        }
        return 30;
    }else {
        return 0;
    }
    
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [indexArray objectAtIndex:section];
}

#pragma mark - 选择国际获取代码
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"选择相应国家,输出:%@",cell.textLabel.text);
    
//    //1.代理传值
//    if (self.deleagete && [self.deleagete respondsToSelector:@selector(returnCountryCode:)]) {
//        [self.deleagete returnCountryCode:cell.textLabel.text];
//    }
//    [self dismissViewControllerAnimated:YES completion:nil];
    
    //2.block传值
    if (self.returnCountryCodeBlock != nil) {
        self.returnCountryCodeBlock(cell.textLabel.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}


#pragma mark - 代理传值
-(void)toReturnCountryCode:(returnCountryCodeBlock)block{
    self.returnCountryCodeBlock = block;
}

- (void)backButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}



@end
