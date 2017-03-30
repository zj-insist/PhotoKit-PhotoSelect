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
    RecordSelectCallBack _record;
    QSPhotoGroup *_group;
}
@property(nonatomic, strong) QSPhotosBottomView *bottom;
@property(nonatomic, strong) QSPhotosCollectionView *collection;
@property(nonatomic, strong) NSMutableArray<QSPhotoAsset *> *photos;
@end

@implementation QSCollectionViewController

#pragma mark - life cycle

- (instancetype)initWithQSPhotoGroup:(QSPhotoGroup *)group recordSeelecte:(RecordSelectCallBack)callBack{
    self = [super init];
    if (self) {
        _group = group;
        _record = callBack;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupSelectView];
    [self setupBottomView];
    [self setBackButtonWithImage];
    [Utils addNavBarCancelButtonWithController:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.collection reloadData];
}

- (void)setBackButtonWithImage {
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"LeftButton_back_Icon"]
                                                  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(goToBack)];
    self.navigationItem.leftBarButtonItem = backButton;
}

-(void)setupBottomView {
    QSPhotosBottomView *bottomView = [[QSPhotosBottomView alloc]
                                      initWithFrame:CGRectMake(0, CGRectGetMaxY(self.collection.frame), self.view.frame.size.width, TOOLBAR_HEIGHT) bottomViewStyle:QSBottomViewStyleSelect];
    bottomView.delegate = self;
    [self.view addSubview:bottomView];
    self.bottom = bottomView;
}


-(void)setupSelectView {
    self.title = _group.albumName;
    self.photos = [_group.photoAssets copy];
    [self.view setBackgroundColor:[UIColor whiteColor]];
}


-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_record) {
        _record(self.selectAssets);
    }
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
    NSLog(@"预览选中的%ld张图片",self.selectAssets.count);
}

-(void)QS_bottomViewRightBtnTouched {
    NSLog(@"完成选择，一共%ld张图片",self.selectAssets.count);
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
        [self.view addSubview:collection];
        _collection = collection;
        _collection.selectImage = self.selectAssets;
        _collection.needRightBtn = self.needRightBtn;
        
        __weak __typeof(self)weakSelf = self;
        __weak __typeof(_collection)weakCollect = _collection;
        
        _collection.touchitem = ^(NSInteger index) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            QSBrowserViewController *vc = [[QSBrowserViewController alloc] init];
            vc.assets = strongSelf.photos;
            vc.currentIndex = index;
            vc.selectAssets = strongSelf.selectAssets;
            vc.maxCount = strongSelf.maxCount;
            vc.needRightBtn = strongSelf.needRightBtn;
            vc.recordCallBack = ^(NSMutableArray *selectAsset) {
                strongSelf.selectAssets = selectAsset;
            };
            [strongSelf.navigationController pushViewController:vc animated:YES];
        };
        
        _collection.selectCallBack = ^(QSPhotoAsset *asset,BOOL isSelected) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (strongSelf.selectAssets.count == strongSelf.maxCount && isSelected) {
                NSString *message = [NSString stringWithFormat:@"最多只能选择%ld张图片",strongSelf.selectAssets.count];
                [Utils showAlertViewWithController:strongSelf title:@"提示" message:message confirmButton:nil];
                return NO;
            } else if (!isSelected) {
                for (QSPhotoAsset *result in strongSelf.selectAssets) {
                    if ([[result getAssetLocalIdentifier] isEqualToString:[asset getAssetLocalIdentifier]]) {
                        [strongSelf.selectAssets removeObject:result];
                        break;
                    }
                }
            } else {
                [strongSelf.selectAssets addObject:asset];
            }
            weakCollect.selectImage = strongSelf.selectAssets;
            strongSelf.bottom.selectCount = strongSelf.selectAssets.count;
            return YES;
        };
    }
    return _collection;
}


-(NSMutableArray<QSPhotoAsset *> *)selectAssets {
    if (!_selectAssets) {
        _selectAssets = [NSMutableArray array];
    }
    return _selectAssets;
}


#pragma mark - delete

//- (instancetype)initWithTitle:(NSString *)title assets:(NSArray<QSPhotoAsset *> *)assets {
//    self = [super init];
//    if (self) {
//        _photos = [assets mutableCopy];
//        [self.view setBackgroundColor:[UIColor whiteColor]];
//        self.title = title;
//    }
//    return self;
//}

@end
