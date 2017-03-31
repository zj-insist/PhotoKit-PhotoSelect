//
//  QSPhotoManage.m
//  QSPhotoSelect
//
//  Created by ZJ-Jie on 2017/3/31.
//  Copyright © 2017年 ZJ-Jie. All rights reserved.
//

#import "QSPhotoManage.h"

static QSPhotoManage *_instance;

@implementation QSPhotoManage

+(instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
        }
    });
    return _instance;
}

+(instancetype)shareQSPhotoManage {
    return [[self alloc]init];
}

-(id)copyWithZone:(NSZone *)zone {
    return _instance;
}

-(id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}

-(NSMutableArray<QSPhotoAsset *> *)selectAsset {
    if (!_selectAsset) {
        _selectAsset = [NSMutableArray array];
    }
    return _selectAsset;
}

@end
