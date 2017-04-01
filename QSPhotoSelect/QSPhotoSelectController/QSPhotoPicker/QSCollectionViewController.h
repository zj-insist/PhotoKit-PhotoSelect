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


- (instancetype)initWithQSPhotoGroup:(QSPhotoGroup *)group;


@end
