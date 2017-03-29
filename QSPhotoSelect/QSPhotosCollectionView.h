//
//  QSPhotosCollectionView.h
//  QSPhotoSelect
//
//  Created by ZJ-Jie on 2017/3/22.
//  Copyright © 2017年 ZJ-Jie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSPhotoSelectImageView.h"
#import "QSPhotoAsset.h"

typedef BOOL (^SelectCallBack)(QSPhotoAsset *asset,BOOL isSelected);

typedef void (^TouchItemCallBack)(NSInteger index);

@interface QSPhotosCollectionView : UICollectionView

@property(nonatomic, strong) NSMutableArray<QSPhotoAsset *> *photoAssets;

@property(nonatomic, assign) NSUInteger maxCount;

@property(nonatomic, strong) NSMutableArray<QSPhotoAsset *> *selectImage;

@property(nonatomic, copy) SelectCallBack selectCallBack;

@property(nonatomic, copy) TouchItemCallBack touchitem;

@end
