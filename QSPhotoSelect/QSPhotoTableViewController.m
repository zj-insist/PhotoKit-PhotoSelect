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

@interface QSPhotoTableViewController ()<QSCancelBarTouchEvent,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) PHFetchResult *allPhotos;
@property(nonatomic, strong) QSPhotoGroup *allPhotosAlbum;
@property(nonatomic, strong) NSMutableArray<QSPhotoGroup *> *smartAlbums;
@property(nonatomic, strong) NSMutableArray<QSPhotoAsset *> *selectPhotos;

@end

@implementation QSPhotoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"相册选择";
    [Utils addNavBarCancelButtonWithController:self];
}

- (void)addNavBarCancelButton{
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                            target:self
                                                                                            action:@selector(cancelBtnTouched)];
    temporaryBarButtonItem.tintColor = UIColorFromRGBA(0x53D107,1.0);
    self.navigationItem.rightBarButtonItem = temporaryBarButtonItem;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        [cell.textLabel setText:self.allPhotosAlbum.albumName];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"(%ld)",self.allPhotosAlbum.photoAssets.count]];
    } else {
        QSPhotoGroup *album = self.smartAlbums[indexPath.row - 1];
        [cell.textLabel setText:album.albumName];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"(%ld)",album.count]];
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
