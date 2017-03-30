//
//  QSPhotoAsset.h
//  QSPhotoSelect
//
//  Created by ZJ-Jie on 2017/3/24.
//  Copyright © 2017年 ZJ-Jie. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ResultImage)(UIImage *image);

typedef void (^ResultData)(NSData *data);

@class PHAsset;

@interface QSPhotoAsset : NSObject

@property(nonatomic, assign) BOOL isOrginal;

@property(nonatomic, assign, readonly) NSUInteger orginalLength;

- (instancetype)initWithAsset:(PHAsset *)asset;

- (NSString *)getAssetLocalIdentifier;

-(void)getFillThumbnailWithSize:(CGSize)size callback:(ResultImage)resultBlock;

-(void)getFitThumbnailWithSize:(CGSize)size callback:(ResultImage)resultBlock;

-(void)getOriginalWithCallback:(ResultImage)resultBlock;

- (void)getImageDataWithCallBack:(ResultData)resultBlock;

- (NSString *)getOrginalLengthWithUtil;

@end
