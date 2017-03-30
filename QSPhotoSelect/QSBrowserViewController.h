//
//  QSBrowserViewController.h
//  QSPhotoSelect
//
//  Created by ZJ-Jie on 2017/3/28.
//  Copyright © 2017年 ZJ-Jie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSPhotoAsset.h"

typedef void (^RecordSelect)(NSMutableArray *selectAssets);

@interface QSBrowserViewController : UIViewController

@property(nonatomic, strong) NSArray<QSPhotoAsset *> *assets;

@property(nonatomic, assign) NSUInteger currentIndex;

@property(nonatomic, strong) NSMutableArray<QSPhotoAsset *> *selectAssets;

@property(nonatomic, copy) RecordSelect recordCallBack;

@property(nonatomic, assign) NSUInteger maxCount;

@property(nonatomic, assign) BOOL needRightBtn;

@end
