//
//  QSPhotoGroup.m
//  QSPhotoSelect
//
//  Created by ZJ-Jie on 2017/3/24.
//  Copyright © 2017年 ZJ-Jie. All rights reserved.
//

#import "QSPhotoGroup.h"

@interface QSPhotoGroup()
{
    PHAssetCollection *_fetchResult;
    QSPhotoGroupType _groupType;
}
@end

@implementation QSPhotoGroup

- (instancetype)initWithFetchResult:(PHAssetCollection *)result withGroupType:(QSPhotoGroupType)type
{
    self = [super init];
    if (self) {
        _fetchResult = result;
        _groupType = type;
        if(![self setupAssetArray]) return nil;
    }
    return self;
}

-(BOOL)setupAssetArray {
    if (_groupType == QSPhotoGroupAllPhoto) {
        PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
        allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        _photoAssets = [self getAssetToArrayWithFetchResult:[PHAsset fetchAssetsWithOptions:allPhotosOptions]];
        _albumName = @"全部图片";
    } else {
        PHFetchResult *photoAssets = [PHAsset fetchAssetsInAssetCollection:_fetchResult options:nil];
        _photoAssets = [self getAssetToArrayWithFetchResult:photoAssets];
        _albumName = _fetchResult.localizedTitle;
    }
    _count = _photoAssets.count;
    return (_photoAssets == nil ? NO : YES);
}

-(NSMutableArray *)getAssetToArrayWithFetchResult:(PHFetchResult *)fetchResult {
    if (fetchResult.count == 0) return nil;
    NSMutableArray *assets = [NSMutableArray array];
    for (PHAsset *result in fetchResult) {
        QSPhotoAsset *asset = [[QSPhotoAsset alloc] initWithAsset:result];
        [assets addObject:asset];
    }
    return assets;
}

@end
