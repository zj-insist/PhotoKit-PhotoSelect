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

@interface QSBrowserViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,QSBottomViewDelegate>

@property(nonatomic, strong) UICollectionView *collection;
@property(nonatomic, strong) QSPhotosBottomView *bottom;
@property(nonatomic, strong) QSBrowserHeadView *head;
@end

@implementation QSBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViewController];
    [self setupBottomView];
    [self setupHeadView];
}

- (void)setupHeadView {
    QSBrowserHeadView *headView = [[QSBrowserHeadView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, HEADBAR_HEIGHT)];
    [self.view addSubview:headView];
    [self.view bringSubviewToFront:headView];
    self.head = headView;
}

- (void)setupViewController {
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self.navigationController setNavigationBarHidden:YES];
}


-(BOOL)prefersStatusBarHidden
{
    return YES;
}


-(void)setupBottomView {
    QSPhotosBottomView *bottomView = [[QSPhotosBottomView alloc]
                                      initWithFrame:CGRectMake(0, CGRectGetMaxY(self.collection.frame) - TOOLBAR_HEIGHT, self.view.frame.size.width, TOOLBAR_HEIGHT) bottomViewStyle:QSBottomViewStyleBrowser];
    bottomView.delegate = self;
    [self.view addSubview:bottomView];
    [self.view bringSubviewToFront:bottomView];
    self.bottom = bottomView;
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

@end
