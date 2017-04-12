//
//  QSPhotoTableViewController.m
//  QSPhotoSelect
//
//  Created by ZJ-Jie on 2017/3/22.
//  Copyright © 2017年 ZJ-Jie. All rights reserved.
//

#import "QSPhotoTableViewController.h"
#import <Photos/Photos.h>
#import "QSCollectionViewController.h"
#import "QSPhotoGroup.h"
#import "Utils.h"
#import "MacroDefinition.h"
#import "QSPhotoSelectAlbumCell.h"
#import "Constants.h"

@interface QSPhotoTableViewController ()<QSCancelBarTouchEvent,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) PHFetchResult *allPhotos;
@property(nonatomic, strong) QSPhotoGroup *allPhotosAlbum;
@property(nonatomic, strong) NSMutableArray<QSPhotoGroup *> *smartAlbums;
@property(nonatomic, strong) NSMutableArray<QSPhotoAsset *> *selectPhotos;
@property(nonatomic, strong) UITableView *tableView;

@end

@implementation QSPhotoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = @"相册选择";
    [Utils addNavBarCancelButtonWithController:self];
    
    [self setUpAlbumViewController];
}

- (void)setUpAlbumViewController {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusDenied) {
        //用户拒绝访问,提示用户去开启权限
        UILabel *lockLbl = [[UILabel alloc] init];
        lockLbl.text = PICKER_PowerBrowserPhotoLibirayText;
        lockLbl.numberOfLines = 0;
        lockLbl.textAlignment = NSTextAlignmentCenter;
        lockLbl.frame = CGRectMake(20, 0, self.view.frame.size.width - 40, self.view.frame.size.height);
        [self.view addSubview:lockLbl];
    }  else {
        //允许访问相册
        [self tableView];
        QSCollectionViewController *vc = [[QSCollectionViewController alloc] initWithQSPhotoGroup:self.allPhotosAlbum];
        vc.maxCount = self.maxCount;
        vc.needRightBtn = self.needRightBtn;
        [self.navigationController pushViewController:vc animated:NO];
    }
}

- (void) cancelBtnTouched {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.smartAlbums.count + 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ALBUMCELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QSPhotoSelectAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:QSPhotoSelectAlbumCellIdentifier forIndexPath:indexPath];

    if (indexPath.row == 0) {
        cell.group = self.allPhotosAlbum;
    } else {
        QSPhotoGroup *album = self.smartAlbums[indexPath.row - 1];
        cell.group = album;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    QSCollectionViewController *vc = nil;
    if (indexPath.row == 0) {
        vc = [[QSCollectionViewController alloc] initWithQSPhotoGroup:self.allPhotosAlbum];
    } else {
        QSPhotoGroup *album = self.smartAlbums[indexPath.row - 1];
        vc = [[QSCollectionViewController alloc] initWithQSPhotoGroup:album];
    }
    
    vc.maxCount = self.maxCount;
    vc.needRightBtn = self.needRightBtn;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - setter and getter

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerClass:[QSPhotoSelectAlbumCell class] forCellReuseIdentifier:QSPhotoSelectAlbumCellIdentifier];
        [self.view addSubview:tableView];
        _tableView = tableView;
        _tableView.frame = self.view.bounds;
    }
    return _tableView;
}

-(QSPhotoGroup *)allPhotosAlbum {
    if (!_allPhotosAlbum) {
        _allPhotosAlbum = [[QSPhotoGroup alloc] initWithFetchResult:nil withGroupType:QSPhotoGroupAllPhoto];
    }
    return _allPhotosAlbum;
}

-(NSMutableArray<QSPhotoGroup *> *)smartAlbums {
    if (!_smartAlbums) {
        _smartAlbums = [NSMutableArray array];
        PHFetchResult *albums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                         subtype:PHAssetCollectionSubtypeAlbumRegular
                                                                         options:nil];
        for (PHAssetCollection *result in albums) {
            QSPhotoGroup *group = [[QSPhotoGroup alloc] initWithFetchResult:result withGroupType:QSPhotoGroupSmartAlbum];
            if (group) [_smartAlbums addObject:group];
        }
    }
    return _smartAlbums;
}

- (void)dealloc {
    [QSPhotoManage resetPhotoManage];
}

@end
