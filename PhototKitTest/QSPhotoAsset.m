//
//  QSPhotoAsset.m
//  PhototKitTest
//
//  Created by ZJ-Jie on 2017/3/24.
//  Copyright © 2017年 ZJ-Jie. All rights reserved.
//

#import "QSPhotoAsset.h"
#import <Photos/Photos.h>

@interface QSPhotoAsset()
{
    PHAsset *_asset;
    PHImageManager *_imageManager;
}
@end

@implementation QSPhotoAsset

- (instancetype)initWithAsset:(PHAsset *)asset
{
    self = [super init];
    if (self) {
        _asset = asset;
        _imageManager = [PHImageManager defaultManager];
    }
    return self;
}

- (NSString *)getAssetLocalIdentifier {
    return _asset.localIdentifier;
}

-(void)getFillThumbnailWithSize:(CGSize)size callback:(ResultImage)resultBlock {
    [_imageManager requestImageForAsset:_asset targetSize:size contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        resultBlock(result);
    }];
}

-(void)getFitThumbnailWithSize:(CGSize)size callback:(ResultImage)resultBlock {
    [_imageManager requestImageForAsset:_asset targetSize:size contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        resultBlock(result);
    }];
}

-(void)getOriginalWithCallback:(ResultImage)resultBlock {
    [_imageManager requestImageForAsset:_asset targetSize:CGSizeMake(_asset.pixelWidth, _asset.pixelHeight) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        resultBlock(result);
    }];
}

@end
