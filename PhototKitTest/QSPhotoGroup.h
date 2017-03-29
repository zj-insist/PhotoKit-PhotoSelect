//
//  QSPhotoGroup.h
//  PhototKitTest
//
//  Created by ZJ-Jie on 2017/3/24.
//  Copyright © 2017年 ZJ-Jie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "QSPhotoAsset.h"

typedef NS_ENUM(NSUInteger, QSPhotoGroupType) {
    QSPhotoGroupAllPhoto,
    QSPhotoGroupSmartAlbum,
};

@interface QSPhotoGroup : NSObject

@property(nonatomic, strong, readonly) NSArray<QSPhotoAsset *> *photoAssets;

@property(nonatomic, strong, readonly) NSString *albumName;

@property(nonatomic, assign, readonly) NSUInteger count;

- (instancetype)initWithFetchResult:(PHAssetCollection *)result withGroupType:(QSPhotoGroupType)type;

@end
