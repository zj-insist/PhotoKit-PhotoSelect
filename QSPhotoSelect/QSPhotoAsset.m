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

@property(nonatomic, strong) PHImageManager *imageManager;

@property(nonatomic, strong) PHImageRequestOptions *requestOptions;
@end

@implementation QSPhotoAsset

- (instancetype)initWithAsset:(PHAsset *)asset
{
    self = [super init];
    if (self) {
        _asset = asset;
        _assetIdentifier = _asset.localIdentifier;
        _pixelWidth = asset.pixelWidth;
        _pixelHeight = asset.pixelHeight;
        [self getImageDataWithCallBack:^(NSData *data,NSString *assetIdentifier) {
            _orginalLength = data.length;
        }];
    }
    return self;
}

-(PHImageManager *)imageManager {
    if (!_imageManager) {
        _imageManager = [PHImageManager defaultManager];
    }
    return _imageManager;
}

-(PHImageRequestOptions *)requestOptions {
    if (!_requestOptions) {
        _requestOptions = [[PHImageRequestOptions alloc] init];
        _requestOptions.resizeMode = PHImageRequestOptionsResizeModeFast;
        _requestOptions.synchronous = YES;
    }
    return _requestOptions;
}

-(void)getFillThumbnailWithSize:(CGSize)size callback:(ResultImage)resultBlock {
    
    [self.imageManager requestImageForAsset:_asset targetSize:size contentMode:PHImageContentModeAspectFill options:self.requestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        resultBlock(result,self.assetIdentifier);
    }];
}

-(void)getFitThumbnailWithSize:(CGSize)size callback:(ResultImage)resultBlock {
    
    [self.imageManager requestImageForAsset:_asset targetSize:size contentMode:PHImageContentModeAspectFit options:self.requestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        resultBlock(result,self.assetIdentifier);
    }];
}

-(void)getOriginalWithCallback:(ResultImage)resultBlock {
    [self.imageManager requestImageForAsset:_asset targetSize:CGSizeMake(_asset.pixelWidth, _asset.pixelHeight) contentMode:PHImageContentModeAspectFit options:self.requestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        resultBlock(result,self.assetIdentifier);
    }];
}

- (void)getImageDataWithCallBack:(ResultData)resultBlock {
    [self.imageManager requestImageDataForAsset:_asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        resultBlock(imageData,self.assetIdentifier);
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
