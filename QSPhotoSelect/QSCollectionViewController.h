//
//  QSCollectionViewController.h
//  QSPhotoSelect
//
//  Created by ZJ-Jie on 2017/3/22.
//  Copyright © 2017年 ZJ-Jie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSPhotoGroup.h"

typedef void (^RecordSelectCallBack)(NSMutableArray <QSPhotoAsset *> *selectAsset);

@interface QSCollectionViewController : UIViewController

@property(nonatomic, assign) NSUInteger maxCount;

@property(nonatomic, assign) BOOL needRightBtn;

@property(nonatomic, strong) NSMutableArray<QSPhotoAsset *> *selectAssets;

- (instancetype)initWithQSPhotoGroup:(QSPhotoGroup *)group recordSeelecte:(RecordSelectCallBack)callBack;

//- (instancetype)initWithQSPhotoGroup:(QSPhotoGroup *)group selectAsset:(NSMutableArray<QSPhotoAsset *> *)assets recordSeelecte:(RecordSelectCallBack)callBack;

@end
