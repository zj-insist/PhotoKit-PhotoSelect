//
//  QSPhotoSelectImageView.m
//  QSPhotoSelect
//
//  Created by ZJ-Jie on 2017/3/22.
//  Copyright © 2017年 ZJ-Jie. All rights reserved.
//

#import "QSPhotoSelectImageView.h"

@interface QSPhotoSelectImageView()

@property(nonatomic, strong) UIButton *checkBtn;

@property(nonatomic, strong) UIImageView *photoImage;

@end

@implementation QSPhotoSelectImageView

#pragma mark - setter and getter

-(UIImageView *)photoImage {
    if (_photoImage == nil) {
        UIImageView *image = [[UIImageView alloc] initWithFrame:self.bounds];
        image.contentMode = UIViewContentModeScaleAspectFill;
        image.clipsToBounds = YES;
        _photoImage = image;
        [self addSubview:_photoImage];
        [self sendSubviewToBack:_photoImage];
    }
    return _photoImage;
}

-(void)setAsset:(QSPhotoAsset *)asset {
    _asset = asset;
    [_asset getFitThumbnailWithSize:CGSizeMake(200, 200) callback:^(UIImage *image,NSString *assetIdentifier) {
        [self.photoImage setImage:image];
    }];
}

-(void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    if (isSelected) {
        [self.checkBtn setImage:[UIImage imageNamed:@"checkbox_pic"] forState:UIControlStateNormal];
    } else {
        [self.checkBtn setImage:[UIImage imageNamed:@"checkbox_pic_non"] forState:UIControlStateNormal];
    }
}

-(void)setNeedCheckedBtn:(BOOL)needCheckedBtn {
    _needCheckedBtn = needCheckedBtn;
    [self.checkBtn setHidden:!needCheckedBtn];
}

-(UIButton *)checkBtn {
    if (_checkBtn == nil) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width - 25, 5, 20, 20)];
        [btn setBackgroundColor:[UIColor clearColor]];
        [self addSubview:btn];
        _checkBtn = btn;
        [btn addTarget:self action:@selector(touchCheckBtn) forControlEvents:UIControlEventTouchUpInside];

    }
    return _checkBtn;
}

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.isSelected = NO;
        self.needCheckedBtn = YES;
    }
    return self;
}

#pragma mark - private

-(void)touchCheckBtn {
    if ([self.itemDelegate respondsToSelector:@selector(QS_selectedImageWithIndex:isSelect:)]) {
        if ([self.itemDelegate QS_selectedImageWithIndex:self.asset isSelect:!self.isSelected]) {
            self.isSelected = !self.isSelected;
        }
    }
}

@end
