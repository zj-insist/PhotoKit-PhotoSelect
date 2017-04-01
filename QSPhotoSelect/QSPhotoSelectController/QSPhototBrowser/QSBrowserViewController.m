//
//  QSBrowserViewController.m
//  QSPhotoSelect
//
//  Created by ZJ-Jie on 2017/3/28.
//  Copyright © 2017年 ZJ-Jie. All rights reserved.
//

#import "QSBrowserViewController.h"
#import "QSBrowserCell.h"
#import "UIView+GetViewLayout.h"
#import "Constants.h"
#import "QSPhotosBottomView.h"
#import "QSBrowserHeadView.h"
#import "Utils.h"
#import "MacroDefinition.h"

@interface QSBrowserViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,QSBottomViewDelegate,QSBrowserHeadViewDelegate>
{
    RecordSelectCount _recordCallBack;
}

@property(nonatomic, strong) UICollectionView *collection;
@property(nonatomic, strong) QSPhotosBottomView *bottomView;
@property(nonatomic, strong) QSBrowserHeadView *headerView;
@property(nonatomic, strong) UILabel *indexLabel;

@property(nonatomic, assign) NSUInteger currentIndex;

@end

@implementation QSBrowserViewController

#pragma mark - life cycle

- (instancetype)initWithCurrentIndex:(NSUInteger)currentIndex recordSelectCount:(RecordSelectCount)callBack {
    self = [super init];
    if (self) {
        _currentIndex = currentIndex;
        _recordCallBack = callBack;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViewController];
    self.indexLabel.alpha = 0.f;
    
    CGPoint point = CGPointMake(self.currentIndex * self.collection.width, 0);
    self.collection.contentOffset = point;
    
    [self setupHeaderViewRightBtnWithIndex:self.currentIndex];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    _recordCallBack();
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}


#pragma mark - private methods

- (void)setupViewController {
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self addTapGesture];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)addTapGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapSetupUI)];
    [self.view addGestureRecognizer:tap];
}

- (void)singleTapSetupUI {
    static CGFloat alphaValue = 1;
    alphaValue = alphaValue? 0 : 1;
    [UIView animateWithDuration:0.3 animations:^(void) {
        [_headerView setAlpha:alphaValue];
        [_bottomView setAlpha:alphaValue];
        [_indexLabel setAlpha:!alphaValue];
    } completion:nil];
}

- (void)setupHeaderViewRightBtnWithIndex:(NSUInteger)index {
    self.headerView.isSelected = NO;
    
    QSPhotoAsset *asset = self.assets[self.currentIndex];
    self.bottomView.orginalLength = [asset getOrginalLengthWithUtil];
    
    __weak __typeof(self)weakSelf = self;
    [QSPhotoManage.selectAssets enumerateObjectsUsingBlock:^(QSPhotoAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([strongSelf.assets[index].assetIdentifier isEqualToString:obj.assetIdentifier]) {
            strongSelf.headerView.isSelected = YES;
            *stop = YES;
        }
    }];
}

#pragma mark - CollectionDelegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QSBrowserCell *cell = [QSBrowserCell cellWithCollectionView:collectionView cellForItemAtIndexPath:indexPath];
    QSPhotoAsset *asset = self.assets[indexPath.item];
//    [asset getOriginalWithCallback:^(UIImage *image, NSString *assetIdentifier) {
//        cell.image = image;
//    }];
    
    [asset getImageWithCallback:^(UIImage *image, NSString *assetIdentifier) {
        cell.image = image;
    }];
    
    return cell;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

//添加一个与间隔等宽的断尾，避免最后一张图片显示偏离位置
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(20, self.view.frame.size.height);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.currentIndex = (NSInteger)((scrollView.contentOffset.x / scrollView.frame.size.width) + 0.5);
}

#pragma mark - custom delegate

-(void)QS_bottomViewOrginalBtnTouched:(BOOL)isSelect {
    QSPhotoManage.isOrginal = isSelect;
}

-(void)QS_bottomViewRightBtnTouched {
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"completeSelect"
                                                        object:@{@"selectAssets" : QSPhotoManage.selectAssets,
                                                                 @"isOrginal" : @(QSPhotoManage.isOrginal)}];
}

-(BOOL)QS_headerViewRightBtnTouched:(BOOL)isSelected {
    QSPhotoAsset *asset = self.assets[self.currentIndex];
    if(QSPhotoManage.selectAssets.count == self.maxCount && !isSelected){
        NSString *message = [NSString stringWithFormat:@"最多只能选择%ld张图片",(unsigned long)QSPhotoManage.selectAssets.count];
        [Utils showAlertViewWithController:self title:@"提示" message:message confirmButton:nil];
        return NO;
    } else if (isSelected)  {
        for (QSPhotoAsset *result in QSPhotoManage.selectAssets) {
            if ([result.assetIdentifier isEqualToString:asset.assetIdentifier]) {
                [QSPhotoManage.selectAssets removeObject:result];
                break;
            }
        }
    } else {
        [QSPhotoManage.selectAssets addObject:asset];
    }
    self.bottomView.selectCount = QSPhotoManage.selectAssets.count;
    return YES;
}

-(void)QS_headerViewLeftBtnTouched {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - setter and getter 

-(UICollectionView *)collection {
    if (!_collection) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = CELL_SPACE;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.itemSize = self.view.bounds.size;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width + CELL_SPACE,self.view.height) collectionViewLayout:flowLayout];
        
        collectionView.showsHorizontalScrollIndicator = YES;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.pagingEnabled = YES;
        collectionView.backgroundColor = [UIColor blackColor];
        collectionView.bounces = YES;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        
        [collectionView registerClass:[QSBrowserCell class] forCellWithReuseIdentifier:QSBrowserCellIdentifier];
        
        [self.view addSubview:collectionView];
        _collection = collectionView;
    }
    return _collection;
}

-(QSBrowserHeadView *)headerView {
    if (!_headerView) {
        QSBrowserHeadView *headView = [[QSBrowserHeadView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, HEADBAR_HEIGHT)];
        headView.delegate = self;
        headView.needCheckedBtn = self.needRightBtn;
        [self.view addSubview:headView];
        _headerView = headView;
    }
    return _headerView;
}

-(QSPhotosBottomView *)bottomView {
    if (!_bottomView) {
        QSPhotosBottomView *bottomView = [[QSPhotosBottomView alloc] initBrowserBottomViewWithFrame:CGRectMake(0, CGRectGetMaxY(self.collection.frame) - TOOLBAR_HEIGHT, self.headerView.frame.size.width, TOOLBAR_HEIGHT) selectState:QSPhotoManage.isOrginal];
        
        bottomView.delegate = self;
        bottomView.selectCount = QSPhotoManage.selectAssets.count;
        [self.view addSubview:bottomView];
        _bottomView = bottomView;
    }
    return _bottomView;
}

-(UILabel *)indexLabel {
    if (!_indexLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:self.bottomView.frame];
        [label setFont:[UIFont systemFontOfSize:15]];
        [label setTextColor:[UIColor whiteColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setText:[NSString stringWithFormat:@"%ld/%ld",(unsigned long)(self.currentIndex+1),(unsigned long)self.assets.count]];
        [self.view addSubview:label];
        _indexLabel = label;
    }
    return _indexLabel;
}

-(void)setCurrentIndex:(NSUInteger)currentIndex {
    _currentIndex = currentIndex;
    [self setupHeaderViewRightBtnWithIndex:currentIndex];
    [self.indexLabel setText:[NSString stringWithFormat:@"%ld/%ld",(currentIndex+1),self.assets.count]];
    
    QSPhotoAsset *asset = self.assets[self.currentIndex];
    self.bottomView.orginalLength = [asset getOrginalLengthWithUtil];
}


@end
