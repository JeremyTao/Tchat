//
//  YPPhotosView.m
//  YPCommentDemo
//
//

#import "YPPhotosView.h"
#import "YPCollectionViewCell.h"
#import "YPCollectionViewFlowLayout.h"

//#define upLoadImgWidth            720
#define upLoadImgWidth            320
#define KScreen_Size  [UIScreen mainScreen].bounds.size
@interface YPPhotosView ()
<
UICollectionViewDataSource,
UICollectionViewDelegate>{
    NSInteger tempCount;
    NSInteger rowH;
}


/***/
@property (nonatomic,weak) UIImageView *imgView;
@property (nonatomic,assign)BOOL hidden;
@end

@implementation YPPhotosView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];

        if (iPhone5) {
            tempCount = 3;
            rowH = 85;
        }else if(iPhone6){
            tempCount = 3;
            rowH = 110;
        }else{
            tempCount = 3;
            rowH = 120;
        }
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero  collectionViewLayout:layout];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor] ;
        _collectionView.scrollEnabled = NO;
        
        // 关闭水平划线
        _collectionView.showsVerticalScrollIndicator = NO ;
        [_collectionView registerClass:[YPCollectionViewCell class] forCellWithReuseIdentifier:@"CELL"];
        [_collectionView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        [self addSubview:_collectionView];
        
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(10);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
            make.left.equalTo(self.mas_left).offset(20);
            make.right.equalTo(self.mas_right).offset(-20);
        }];
        
    }
    return self;
}

#pragma mark - collectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _photoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"CELL";
    YPCollectionViewCell *cell = (YPCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    //标记第一张为当前头像
    if (indexPath.row == 0) {
        //
        cell.preLabel.hidden = NO;
    }else{
        cell.preLabel.hidden = YES;
    }

/*让选择图片上面的delete安钮不显示*/
    if (_photoArray.count == 7) {
        if (indexPath.row < 6) {
            
            _hidden = NO ;
            [cell setCellWithImage:_photoArray[indexPath.row] IsFirstOrLastObjectHiddenBtn:_hidden];
            //[cell.btn addTarget:self action:@selector(deleteImageClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.btn.tag = 2016 + indexPath.row;
        }else{
            _hidden = YES ;
            [cell setCellWithImage:[[UIImage alloc] init] IsFirstOrLastObjectHiddenBtn:_hidden];
            //[cell.btn addTarget:self action:@selector(deleteImageClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }else{
        if (_photoArray.count==1 || indexPath.row == _photoArray.count-1) {
            _hidden = YES ;
        }
        else {
            
            _hidden = NO ;
        }
        [cell setCellWithImage:_photoArray[indexPath.row] IsFirstOrLastObjectHiddenBtn:_hidden];
        //[cell.btn addTarget:self action:@selector(deleteImageClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.btn.tag = 2016 + indexPath.row ;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 调用TZImagePickerController选择器选择图片
    if (_photoArray.count == 1 ) {
        if (self.clickChooseView) {
            self.clickChooseView();
        }
    }else {
    
        if (indexPath.row < _photoArray.count - 1) {
            NSLog(@"%ld",(long)indexPath.row);
            if (_myPhotoDelegate && [_myPhotoDelegate respondsToSelector:@selector(didSelectPhotoAtIndexRow:)]) {
                [_myPhotoDelegate didSelectPhotoAtIndexRow:indexPath.row];
            }
        } else {
            if (self.clickChooseView) {
                self.clickChooseView();
            }
        }
        
    }
    
    

}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 8.0;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat itemWidth = 70;
    
    if (iPhone5) {
        itemWidth = 85;
    } else if (iPhone6) {
        itemWidth = 100;
    } else if (iPhone6plus) {
        itemWidth = 116;
    }
    return CGSizeMake(itemWidth, itemWidth);
}


#pragma mark - 删除某一张图片
- (void)deleteImageAtIndex:(NSInteger)index {
  
    NSMutableArray *dataSourse = [NSMutableArray arrayWithArray:_photoArray];
    [dataSourse removeObjectAtIndex:index];
    _photoArray = dataSourse ;
    
    
    if (_photoArray.count >= tempCount + 1) {
        if (_photoArray.count % tempCount == 0) {
            CGFloat tempH = (_photoArray.count / tempCount) * rowH;
            if (iPhone6plus) {
                tempH += 15;
            }
            if (_myHDelegaher && [_myHDelegaher respondsToSelector:@selector(uplodeMyH:)]) {
                [_myHDelegaher uplodeMyH:tempH];
            }
            
            //_collectionView.frame = CGRectMake(6, 0, self.frame.size.width - 12, tempH);
        }else{
            CGFloat tempH = (_photoArray.count / tempCount + 1) * rowH;
            if (iPhone6plus) {
                tempH += 15;
            }
            if (_myHDelegaher && [_myHDelegaher respondsToSelector:@selector(uplodeMyH:)]) {
                [_myHDelegaher uplodeMyH:tempH];
            }
            
            //_collectionView.frame = CGRectMake(6, 0, self.frame.size.width - 12, tempH);
        }
        
    }else{
        CGFloat tempH = rowH;
        if (iPhone6plus) {
            tempH += 15;
        }
        if (_myHDelegaher && [_myHDelegaher respondsToSelector:@selector(uplodeMyH:)]) {
            [_myHDelegaher uplodeMyH:tempH];
        }
        
        //_collectionView.frame = CGRectMake(6, 0, self.frame.size.width - 12, tempH);
        
    }
    
    [_collectionView reloadData];
    
    // 回调TZImagePickerController选择器删除图片
    //self.clickcloseImage(btn.tag - 2016);
}
-(void)setImg:(NSArray *)arr{
    _photoArray = arr ;
    
   
    
    if (_photoArray.count >= tempCount + 1) {
        if (_photoArray.count % tempCount == 0) {
            CGFloat tempH = (_photoArray.count / tempCount) * rowH;
            if (iPhone6plus) {
                tempH += 15;
            }
            //_collectionView.frame = CGRectMake(6, 0, self.frame.size.width - 12, tempH);
        }else{
            CGFloat tempH = (_photoArray.count / tempCount + 1) * rowH;
            if (iPhone6plus) {
                tempH += 15;
            }
            //_collectionView.frame = CGRectMake(6, 0, self.frame.size.width - 12, tempH);
        }
        
    }else{
        
        //_collectionView.frame = CGRectMake(6, 0, self.frame.size.width - 12, rowH);

    }

    [_collectionView reloadData];

    
}
#pragma mark - 外部API 选择图片完成是调用
- (void)setYPPhotosView:(NSArray *)photoArray {
    
       
    _photoArray = photoArray ;
    
    
    if (_photoArray.count >= tempCount + 1) {
        if (_photoArray.count % tempCount == 0) {
            CGFloat tempH = (_photoArray.count / tempCount) * rowH;
            if (iPhone6plus) {
                tempH += 15;
            }
            if (_myHDelegaher && [_myHDelegaher respondsToSelector:@selector(uplodeMyH:)]) {
                [_myHDelegaher uplodeMyH:tempH];
            }
           // _collectionView.frame = CGRectMake(6, 0, self.frame.size.width - 12, tempH);
        }else{
            CGFloat tempH = (_photoArray.count / tempCount + 1) * rowH;
            if (iPhone6plus) {
                tempH += 15;
            }
            if (_myHDelegaher && [_myHDelegaher respondsToSelector:@selector(uplodeMyH:)]) {
                [_myHDelegaher uplodeMyH:tempH];
            }
          //  _collectionView.frame = CGRectMake(6, 0, self.frame.size.width - 12, tempH);
        }
        
    }else{
        CGFloat tempH = rowH;
        if (iPhone6plus) {
            tempH += 15;
        }
        if (_myHDelegaher && [_myHDelegaher respondsToSelector:@selector(uplodeMyH:)]) {
            [_myHDelegaher uplodeMyH:tempH];
        }
        //_collectionView.frame = CGRectMake(6, 0, self.frame.size.width - 12, tempH);
        
    }
    
    
    [_collectionView reloadData];
}

@end
