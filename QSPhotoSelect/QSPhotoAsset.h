//
//  QSPhotoAsset.h
//  QSPhotoSelect
//
//  Created by ZJ-Jie on 2017/3/24.
//  Copyright © 2017年 ZJ-Jie. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ResultImage)(UIImage *image,NSString *assetIdentifier);

typedef void (^ResultData)(NSData *data,NSString *assetIdentifier);

@class PHAsset;

@interface QSPhotoAsset : NSObject

@property(nonatomic, strong, readonly) PHAsset *asset;

@property (nonatomic, assign, readonly) NSUInteger pixelWidth;

@property (nonatomic, assign, readonly) NSUInteger pixelHeight;

@property(nonatomic, assign, readonly) NSUInteger orginalLength;

@property(nonatomic, strong, readonly) NSString *assetIdentifier;

- (instancetype)initWithAsset:(PHAsset *)asset;

-(void)getFitThumbnailWithSize:(CGSize)size callback:(ResultImage)resultBlock;

-(void)getImageWithCallback:(ResultImage)resultBlock;

-(void)getOriginalWithCallback:(ResultImage)resultBlock;

- (void)getImageDataWithCallBack:(ResultData)resultBlock;

- (NSString *)getOrginalLengthWithUtil;

@end
