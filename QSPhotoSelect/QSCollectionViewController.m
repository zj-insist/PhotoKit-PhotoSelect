//
//  QSCollectionViewController.m
//  QSPhotoSelect
//
//  Created by ZJ-Jie on 2017/3/22.
//  Copyright © 2017年 ZJ-Jie. All rights reserved.
//

#import "QSCollectionViewController.h"
#import "QSPhotoSelectImageView.h"
#import "QSPhotosBottomView.h"
#import "QSPhotosCollectionView.h"
#import "QSPhotoAsset.h"
#import "Utils.h"
#import "MacroDefinition.h"
#import "QSBrowserViewController.h"
#import "Constants.h"



@interface QSCollectionViewController ()<QSCancelBarTouchEvent,QSBottomViewDelegate>
{
    QSPhotoGroup *_group;
}
@property(nonatomic, strong) QSPhotosBottomView *bottomView;
@property(nonatomic, strong) QSPhotosCollectionView *collection;
@property(nonatomic, strong) NSMutableArray<QSPhotoAsset *> *photos;
@end

@implementation QSCollectionViewController

#pragma mark - life cycle

- (instancetype)initWithQSPhotoGroup:(QSPhotoGroup *)group{
    self = [super init];
    if (self) {
        _group = group;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupSelectView];
    self.bottomView.selectCount = QSPhotoManage.selectAssets.count;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.collection reloadData];
}

#pragma mark - private methods

- (void)setBackButtonWithImage {
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"LeftButton_back_Icon"]
                                                  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(goToBack)];
    self.navigationItem.leftBarButtonItem = backButton;
}

-(void)setupSelectView {
    self.title = _group.albumName;
    self.photos = [_group.photoAssets copy];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setBackButtonWithImage];
    [Utils addNavBarCancelButtonWithController:self];
}

#pragma mark - touch even

- (void)addNavBarCancelButton{
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                            target:self
                                                                                            action:@selector(cancelBtnTouched)];
    temporaryBarButtonItem.tintColor = UIColorFromRGBA(0x53D107,1.0);
    self.navigationItem.rightBarButtonItem = temporaryBarButtonItem;
}

- (void)goToBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) cancelBtnTouched{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - custom delegate

-(void)QS_bottomViewLeftBtnTouched {
    
    __weak __typeof(self)weakSelf = self;
    QSBrowserViewController *vc = [[QSBrowserViewController alloc] initWithCurrentIndex:0 recordSelectCount:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.bottomView.selectCount = QSPhotoManage.selectAssets.count;
    }];
    
    vc.assets = [QSPhotoManage.selectAssets mutableCopy];
    vc.maxCount = self.maxCount;
    vc.needRightBtn = self.needRightBtn;
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)QS_bottomViewRightBtnTouched {
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"completeSelect"
                                                        object:@{@"selectAssets" : QSPhotoManage.selectAssets,
                                                                 @"isOrginal" : @(QSPhotoManage.isOrginal)}];
}

#pragma mark - setter and getter

-(QSPhotosCollectionView *)collection {
    if (!_collection) {
        CGFloat cellW = (self.view.frame.size.width - CELL_MARGIN * CELL_ROW + 1) / CELL_ROW;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(cellW, cellW);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = CELL_LINE_MARGIN;
        layout.footerReferenceSize = CGSizeMake(self.view.frame.size.width, TOOLBAR_HEIGHT * 2);
        CGRect frame = self.view.frame;
        frame.size.height = frame.size.height - TOOLBAR_HEIGHT;
        
        QSPhotosCollectionView *collection = [[QSPhotosCollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
        collection.photoAssets = self.photos;
        collection.needRightBtn = self.needRightBtn;
        [self.view addSubview:collection];
        _collection = collection;
        
        __weak __typeof(self)weakSelf = self;
        _collection.touchitem = ^(NSInteger index) {
            
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            QSBrowserViewController *vc = [[QSBrowserViewController alloc] initWithCurrentIndex:index recordSelectCount:^{
                strongSelf.bottomView.selectCount = QSPhotoManage.selectAssets.count;
            }];
            
            vc.assets = strongSelf.photos;
            vc.maxCount = strongSelf.maxCount;
            vc.needRightBtn = strongSelf.needRightBtn;
            
            [strongSelf.navigationController pushViewController:vc animated:YES];
        };
        
        _collection.selectCallBack = ^(QSPhotoAsset *asset,BOOL isSelected) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (QSPhotoManage.selectAssets.count == strongSelf.maxCount && isSelected) {
                NSString *message = [NSString stringWithFormat:@"最多只能选择%ld张图片",QSPhotoManage.selectAssets.count];
                [Utils showAlertViewWithController:strongSelf title:@"提示" message:message confirmButton:nil];
                return NO;
            } else if (!isSelected) {
                for (QSPhotoAsset *result in QSPhotoManage.selectAssets) {
                    if ([result.assetIdentifier isEqualToString:asset.assetIdentifier]) {
                        [QSPhotoManage.selectAssets removeObject:result];
                        break;
                    }
                }
            } else {
                [QSPhotoManage.selectAssets addObject:asset];
            }
            strongSelf.bottomView.selectCount = QSPhotoManage.selectAssets.count;
            return YES;
        };
    }
    return _collection;
}

-(QSPhotosBottomView *)bottomView {
    if (!_bottomView) {
        QSPhotosBottomView *bottomView = [[QSPhotosBottomView alloc] initSelectBottomViewWithFrame:CGRectMake(0, CGRectGetMaxY(self.collection.frame), self.view.frame.size.width, TOOLBAR_HEIGHT)];
        
        bottomView.delegate = self;
        [self.view addSubview:bottomView];
        _bottomView = bottomView;
    }
    return _bottomView;
}


@end
