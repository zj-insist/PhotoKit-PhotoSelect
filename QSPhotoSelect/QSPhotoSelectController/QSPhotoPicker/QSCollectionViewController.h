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


/**
 根据传入的相册组创建相应的展示视图

 @param group 相册组
 @return <#return value description#>
 */
- (instancetype)initWithQSPhotoGroup:(QSPhotoGroup *)group;


@end
