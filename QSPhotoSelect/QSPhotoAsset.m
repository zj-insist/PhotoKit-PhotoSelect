//
//  QSPhotoAsset.m
//  QSPhotoSelect
//
//  Created by ZJ-Jie on 2017/3/24.
//  Copyright © 2017年 ZJ-Jie. All rights reserved.
//

#import "QSPhotoAsset.h"
#import <Photos/Photos.h>

@interface QSPhotoAsset()
{
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
        [self getImageDataWithCallBack:^(NSData *data) {
            _orginalLength = data.length;
        }];
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

- (void)getImageDataWithCallBack:(ResultData)resultBlock {
    [_imageManager requestImageDataForAsset:_asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        resultBlock(imageData);
    }];
}

- (NSString *)getOrginalLengthWithUtil {
    CGFloat lenth = (CGFloat)self.orginalLength;
    if (lenth >= 1024*1024*1024) {
        return [NSString stringWithFormat:@"%.2fG",lenth/(1024*1024*1024)];
    }else if (lenth >= 1024*1024) {
        return [NSString stringWithFormat:@"%.2fM",lenth/(1024*1024)];
    }else{
        return [NSString stringWithFormat:@"%.2fK",lenth/1024];
    }
}


@end
