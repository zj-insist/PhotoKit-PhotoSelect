
//
//  QSPhotosFooterView.m
//  QSPhotoSelect
//
//  Created by ZJ-Jie on 2017/3/23.
//  Copyright © 2017年 ZJ-Jie. All rights reserved.
//

#import "QSPhotosFooterView.h"

@interface QSPhotosFooterView()

@property(nonatomic, strong) UILabel *footerLabel;

@end

@implementation QSPhotosFooterView

-(UILabel *)footerLabel {
    if (!_footerLabel) {
        _footerLabel = [[UILabel alloc] init];
        _footerLabel.frame = self.bounds;
        _footerLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_footerLabel];
    }
    return _footerLabel;
}

-(void)setPhotoCount:(NSUInteger)photoCount {
    _photoCount = photoCount;
    if (_photoCount > 0) {
        [self.footerLabel setText:[NSString stringWithFormat:@"共 %ld 张照片",_photoCount]];
    }
}

@end
