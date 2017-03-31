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

@interface QSBrowserViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,QSBottomViewDelegate,QSBrowserHeadViewDelegate>

@property(nonatomic, strong) UICollectionView *collection;
@property(nonatomic, strong) QSPhotosBottomView *bottom;
@property(nonatomic, strong) QSBrowserHeadView *headView;
@property(nonatomic, strong) UILabel *indexLabel;

@end

@implementation QSBrowserViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViewController];
    [self setupBottomView];
    [self setupIndexLabel];
    [self setupHeadView];
    [self setupHeaderViewRightBtnWithIndex:self.currentIndex];
    [self addTapGesture];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    self.recordCallBack(self.selectAssets);
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}


#pragma mark - private methods

- (void)setupIndexLabel {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.height - TOOLBAR_HEIGHT, self.view.frame.size.width, TOOLBAR_HEIGHT)];
    [label setFont:[UIFont systemFontOfSize:15]];
    [label setTextColor:[UIColor whiteColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:[NSString stringWithFormat:@"%ld/%ld",self.currentIndex+1,self.assets.count]];
    [self.view addSubview:label];
    self.indexLabel = label;
    label.alpha = 0.f;
}

- (void)setupHeadView {
    QSBrowserHeadView *headView = [[QSBrowserHeadView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, HEADBAR_HEIGHT)];
    headView.delegate = self;
    headView.needCheckedBtn = self.needRightBtn;
    [self.view addSubview:headView];
    [self.view bringSubviewToFront:headView];
    self.headView = headView;
}

-(void)setupBottomView {
    QSPhotosBottomView *bottomView = [[QSPhotosBottomView alloc]
                                      initWithFrame:CGRectMake(0, CGRectGetMaxY(self.collection.frame) - TOOLBAR_HEIGHT, self.view.frame.size.width, TOOLBAR_HEIGHT) bottomViewStyle:QSBottomViewStyleBrowser];
    bottomView.delegate = self;
    bottomView.selectCount = self.selectAssets.count;
    [self.view addSubview:bottomView];
    [self.view bringSubviewToFront:bottomView];
    self.bottom = bottomView;
}

- (void)setupViewController {
    [self.view setBackgroundColor:[UIColor blackColor]];
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
        [_headView setAlpha:alphaValue];
        [_bottom setAlpha:alphaValue];
        [_indexLabel setAlpha:!alphaValue];
    } completion:nil];
}

#pragma mark - CollectionDelegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QSBrowserCell *cell = [QSBrowserCell cellWithCollectionView:collectionView cellForItemAtIndexPath:indexPath];
    QSPhotoAsset *asset = self.assets[indexPath.item];
    [asset getOriginalWithCallback:^(UIImage *image) {
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
    NSLog(@"%ld",self.currentIndex);
}

#pragma mark - custom delegate

-(NSString *)QS_bottomViewOrginalBtnTouched {
    return [self.assets[self.currentIndex] getOrginalLengthWithUtil];
}

-(void)QS_bottomViewRightBtnTouched {
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"completeSelect" object:self.selectAssets];
}

-(BOOL)QS_headerViewRightBtnTouched:(BOOL)isSelected {
    QSPhotoAsset *asset = self.assets[self.currentIndex];
    if(self.selectAssets.count == self.maxCount && !isSelected){
        NSString *message = [NSString stringWithFormat:@"最多只能选择%ld张图片",self.selectAssets.count];
        [Utils showAlertViewWithController:self title:@"提示" message:message confirmButton:nil];
        return NO;
    } else if (isSelected)  {
        for (QSPhotoAsset *result in self.selectAssets) {
            if ([[result getAssetLocalIdentifier] isEqualToString:[asset getAssetLocalIdentifier]]) {
                [self.selectAssets removeObject:result];
                break;
            }
        }
    } else {
        [self.selectAssets addObject:asset];
    }
    self.bottom.selectCount = self.selectAssets.count;
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
        CGPoint point = CGPointMake(self.currentIndex * collectionView.width, 0);
        collectionView.contentOffset = point;
        
        [self.view addSubview:collectionView];
        _collection = collectionView;
    }
    return _collection;
}


-(void)setCurrentIndex:(NSUInteger)currentIndex {
    _currentIndex = currentIndex;
    [self setupHeaderViewRightBtnWithIndex:currentIndex];
    [self.indexLabel setText:[NSString stringWithFormat:@"%ld/%ld",currentIndex+1,self.assets.count]];
}

- (void)setupHeaderViewRightBtnWithIndex:(NSUInteger)index {
    self.headView.isSelected = NO;
    __weak __typeof(self)weakSelf = self;
    [self.selectAssets enumerateObjectsUsingBlock:^(QSPhotoAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([[strongSelf.assets[index] getAssetLocalIdentifier] isEqualToString:[obj getAssetLocalIdentifier]]) {
            strongSelf.headView.isSelected = YES;
            *stop = YES;
        }
    }];
}

@end
