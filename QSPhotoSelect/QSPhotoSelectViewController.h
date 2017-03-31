//
//  QSOhotoSelectViewController.h
//  QSPhotoSelect
//
//  Created by ZJ-Jie on 2017/3/23.
//  Copyright © 2017年 ZJ-Jie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSPhotoAsset.h"

typedef void (^SelectImagesCallBack)(NSArray<UIImage *> *images);

typedef void (^SelectAssetsCallBack)(NSArray<PHAsset *> *asset, BOOL isOrginal);

@interface QSPhotoSelectViewController : UINavigationController

@property(nonatomic, assign) NSUInteger maxCount;

@property(nonatomic, assign) BOOL needRightBtn;

- (instancetype)initWithImagesCallBack:(SelectImagesCallBack)callBack;

- (instancetype)initWithAssetsCallBack:(SelectAssetsCallBack)callBack;

@end
