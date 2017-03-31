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

-(NSMutableArray<QSPhotoAsset *> *)selectAssets {
    if (!_selectAssets) {
        _selectAssets = [NSMutableArray array];
    }
    return _selectAssets;
}

- (void)resetPhotoManage {
    self.selectAssets = nil;
    self.isOrginal = NO;
}

@end
