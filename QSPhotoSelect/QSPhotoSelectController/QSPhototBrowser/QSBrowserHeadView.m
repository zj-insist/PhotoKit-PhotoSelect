//
//  QSBrowserHeadView.m
//  QSPhotoSelect
//
//  Created by ZJ-Jie on 2017/3/29.
//  Copyright © 2017年 ZJ-Jie. All rights reserved.
//

#import "QSBrowserHeadView.h"
#import "MacroDefinition.h"

@interface QSBrowserHeadView()
@property(nonatomic, strong) UIButton *backButton;
@property(nonatomic, strong) UIButton *rightButton;
@end

@implementation QSBrowserHeadView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backButton];
        [self addSubview:self.rightButton];
        [self setBackgroundColor:UIColorFromRGBA(0x141414,0.7)];
    }
    return self;
}

-(UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(20, self.frame.size.height/2 - 10, 20, 20)];
        [_backButton setImage:[UIImage imageNamed:@"Back-Button-Icon"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

-(UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 40, self.frame.size.height/2 - 10, 20, 20)];
        [_rightButton setImage:[UIImage imageNamed:@"checkbox_pic_non"] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(rightButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

-(void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    NSString *imageName = isSelected ? @"checkbox_pic" : @"checkbox_pic_non";
    [self.rightButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

-(void)backButtonTouched {
    if ([self.delegate respondsToSelector:@selector(QS_headerViewLeftBtnTouched)]) {
        [self.delegate QS_headerViewLeftBtnTouched];
    }
}

-(void)rightButtonTouch {
    if ([self.delegate respondsToSelector:@selector(QS_headerViewRightBtnTouched:)]) {
        if ([self.delegate QS_headerViewRightBtnTouched:self.isSelected]) {
            self.isSelected = !self.isSelected;
        }
    }
}

-(void)setNeedCheckedBtn:(BOOL)needCheckedBtn {
    _needCheckedBtn = needCheckedBtn;
    [self.rightButton setHidden:!needCheckedBtn];
}

@end
