//
//  QSOhotoSelectViewController.m
//  QSPhotoSelect
//
//  Created by ZJ-Jie on 2017/3/23.
//  Copyright © 2017年 ZJ-Jie. All rights reserved.
//

#import "QSPhotoSelectViewController.h"
#import "QSPhotoTableViewController.h"
#import "Utils.h"
typedef void (^CompletionDownload)(NSArray *images);

@interface QSPhotoSelectViewController ()
{
    SelectAssetsCallBack _assetsCallBack;
    SelectImagesCallBack _imagesCallBack;
}
@property(nonatomic, strong) QSPhotoTableViewController *tableViewVC;
@end

@implementation QSPhotoSelectViewController

- (instancetype)init {
    QSPhotoTableViewController *vc = [QSPhotoSelectViewController creatQSPhotoTableViewController];
    self = [super initWithRootViewController:vc];
    if (self) {
        self.tableViewVC = vc;
    }
    return self;
}

- (instancetype)initWithImagesCallBack:(SelectImagesCallBack)callBack {
    self = [self init];
    if (self) {
        _imagesCallBack = callBack;
    }
    return self;
}

- (instancetype)initWithAssetsCallBack:(SelectAssetsCallBack)callBack {
    self = [self init];
    if (self) {
        _assetsCallBack = callBack;
    }
    return self;
}

+ (QSPhotoTableViewController *)creatQSPhotoTableViewController {
    return (QSPhotoTableViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AlbumSelect"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNotification];
}


- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(completeSelect:) name:@"completeSelect" object:nil];
}

- (void)completeSelect:(NSNotification *)notif {
    NSDictionary *dic = notif.object;
    NSArray<QSPhotoAsset *> *qs_assets = dic[@"selectAssets"];
    BOOL isOrginal = [dic[@"isOrginal"] boolValue];
    if (_assetsCallBack) {
        NSMutableArray *assets = [NSMutableArray array];
        for (QSPhotoAsset *result in qs_assets) {
            [assets addObject:result.asset];
        }
        _assetsCallBack(assets,isOrginal);
    } else if (_imagesCallBack && isOrginal) {
        //TODO:返回包含所有选择图片的回调
        [self getOrginalImagesWithAssets:qs_assets completion:^(NSArray *images) {
            _imagesCallBack(images);
        }];
    } else if (_imagesCallBack) {
        [self getImagesWithAssets:qs_assets completion:^(NSArray *images) {
            _imagesCallBack(images);
        }];
    }
}

//TODO:同步所有下载完成的图片
- (void)getOrginalImagesWithAssets:(NSArray<QSPhotoAsset *> *)assets completion:(CompletionDownload)completion {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        //TODO:下载过程添加遮罩
    
    __block NSUInteger imageCount = 0;
    NSUInteger assetsCount = assets.count;
    
    [assets enumerateObjectsUsingBlock:^(QSPhotoAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [obj getOriginalWithCallback:^(UIImage *image,NSString *assetIdentifier) {
            
            [dic setObject:image forKey:[NSString stringWithFormat:@"%ld",idx]];
            imageCount++;
            if (imageCount == assetsCount) {
                NSMutableArray *images = [NSMutableArray array];
                for (NSUInteger index = 0; index < assets.count; index++) {
                    NSString *dicIndex = [NSString stringWithFormat:@"%ld",index];
                    [images addObject:[dic objectForKey:dicIndex]];
                }
                completion(images);
            }
        }];
    }];
}

- (void)getImagesWithAssets:(NSArray<QSPhotoAsset *> *)assets completion:(CompletionDownload)completion {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //TODO:下载过程添加遮罩
    
    __block NSUInteger imageCount = 0;
    NSUInteger assetsCount = assets.count;
    
    [assets enumerateObjectsUsingBlock:^(QSPhotoAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj getFitThumbnailWithSize:[Utils getLimitSize:CGSizeMake(obj.pixelWidth, obj.pixelHeight)] callback:^(UIImage *image, NSString *assetIdentifier) {
                [dic setObject:image forKey:[NSString stringWithFormat:@"%ld",idx]];
                imageCount++;
            if (imageCount == assetsCount) {
                NSMutableArray *images = [NSMutableArray array];
                for (NSUInteger index = 0; index < assets.count; index++) {
                    NSString *dicIndex = [NSString stringWithFormat:@"%ld",index];
                    [images addObject:[dic objectForKey:dicIndex]];
                }
                completion(images);
            }
        }];
    }];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"completeSelect" object:nil];
}

-(void)setMaxCount:(NSUInteger)maxCount {
    if (maxCount <= 0) return;
    _maxCount = maxCount;
    self.tableViewVC.maxCount = maxCount;
}

-(void)setNeedRightBtn:(BOOL)needRightBtn {
    _needRightBtn = needRightBtn;
    self.tableViewVC.needRightBtn = needRightBtn;
}

@end
