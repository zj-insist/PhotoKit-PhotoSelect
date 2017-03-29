//
//  QSPhotoAsset.h
//  PhototKitTest
//
//  Created by ZJ-Jie on 2017/3/24.
//  Copyright © 2017年 ZJ-Jie. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  void (^ResultImage)(UIImage *image);

@class PHAsset;

@interface QSPhotoAsset : NSObject

@property(nonatomic, assign) BOOL isOrginal;

- (instancetype)initWithAsset:(PHAsset *)asset;

- (NSString *)getAssetLocalIdentifier;

-(void)getFillThumbnailWithSize:(CGSize)size callback:(ResultImage)resultBlock;

-(void)getFitThumbnailWithSize:(CGSize)size callback:(ResultImage)resultBlock;

-(void)getOriginalWithCallback:(ResultImage)resultBlock;

@end
