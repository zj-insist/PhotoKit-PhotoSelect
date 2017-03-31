//
//  QSPhotoManage.h
//  QSPhotoSelect
//
//  Created by ZJ-Jie on 2017/3/31.
//  Copyright © 2017年 ZJ-Jie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QSPhotoAsset.h"

@interface QSPhotoManage : NSObject

@property(nonatomic, strong) NSMutableArray<QSPhotoAsset *> *selectAsset;

@property(nonatomic, assign) BOOL isOrginal;

+(instancetype)shareQSPhotoManage;

@end
