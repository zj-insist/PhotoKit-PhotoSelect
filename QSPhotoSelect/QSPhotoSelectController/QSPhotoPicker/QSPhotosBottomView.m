//
//  QSPhotosBottomView.m
//  QSPhotoSelect
//
//  Created by ZJ-Jie on 2017/3/23.
//  Copyright © 2017年 ZJ-Jie. All rights reserved.
//

#import "QSPhotosBottomView.h"
#import "MacroDefinition.h"

typedef NS_ENUM(NSUInteger, QSPhotoButtonStyle) {
    QSPHOTOBUTTONSTYLEBROWSER,
    QSPHOTOBUTTONSTYLEDONE,
    QSPHOTOBUTTONSTYLEORIGINAL
};

@interface QSPhotosBottomView()
{
    QSPhotoButtonStyle _style;
}
@property(nonatomic, strong) UIButton *leftBtn;
@property(nonatomic, strong) UIButton *rightBtn;
@property(nonatomic, assign) BOOL isSelectOrginal;

@end

@implementation QSPhotosBottomView

- (instancetype)initSelectBottomViewWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupBottomViewWithStyle:QSPHOTOBUTTONSTYLEBROWSER];
    }
    return self;
}

- (instancetype)initBrowserBottomViewWithFrame:(CGRect)frame selectState:(BOOL)isSelected {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupBottomViewWithStyle:QSPHOTOBUTTONSTYLEORIGINAL];
        self.isSelectOrginal = isSelected;
    }
    return self;
}


- (void)setupBottomViewWithStyle:(QSPhotoButtonStyle)style {
    
    [self setupLeftBtnWithStyle:style];
    _style = style;
    [self setupRightBtn];
    [self setBackgroundColor:UIColorFromRGBA(0x141414,0.7)];

}

-(void)setupLeftBtnWithStyle:(QSPhotoButtonStyle)style {
    
    UIButton *btn = [self createButtonWithFrame:CGRectMake(15, 0, 100, self.bounds.size.height) type:style];
    [btn addTarget:self action:@selector(leftBtnTouched) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:btn];
    self.leftBtn = btn;
}

-(void)setupRightBtn {
    
    UIButton *btn =  [self createButtonWithFrame:CGRectMake(self.bounds.size.width - 115, 0, 100, self.bounds.size.height) type:QSPHOTOBUTTONSTYLEDONE];
    [btn addTarget:self action:@selector(rightBtnTouched) forControlEvents:UIControlEventTouchUpInside];
    btn.enabled = NO;
    [self addSubview:btn];
    self.rightBtn = btn;
}

-(UIButton *)createButtonWithFrame:(CGRect)frame type:(QSPhotoButtonStyle)style {
    
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    
    if (style == QSPHOTOBUTTONSTYLEBROWSER) {
        [btn setTitle:@"预览" forState:UIControlStateNormal];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    } else if (style == QSPHOTOBUTTONSTYLEORIGINAL) {
        [btn setTitle:@"原图" forState:UIControlStateNormal];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    } else {
        [btn setTitle:@"完成" forState:UIControlStateNormal];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }

    [btn setTitleColor:UIColorFromRGBA(0x53D107,1.0) forState:UIControlStateNormal];
    [btn setTitleColor:UIColorFromRGBA(0x53D107,0.3) forState:UIControlStateDisabled];

    btn.titleLabel.font = [UIFont systemFontOfSize: 15.0];
    
    return btn;
}

#pragma mark - touch event

-(void)leftBtnTouched {
    if (_style == QSPHOTOBUTTONSTYLEBROWSER) {
        if ([self.delegate respondsToSelector:@selector(QS_bottomViewLeftBtnTouched)]) {
            [self.delegate QS_bottomViewLeftBtnTouched];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(QS_bottomViewOrginalBtnTouched:)]) {
            self.isSelectOrginal = !self.isSelectOrginal;
            [self.delegate QS_bottomViewOrginalBtnTouched:self.isSelectOrginal];
        }
    }
}

- (void)rightBtnTouched {
    if ([self.delegate respondsToSelector:@selector(QS_bottomViewRightBtnTouched)]) {
        [self.delegate QS_bottomViewRightBtnTouched];
    }
}

#pragma mark - setter and getter

-(void)setSelectCount:(NSUInteger)selectCount {
    _selectCount = selectCount;
    if (_selectCount > 0) {
        [self.rightBtn setTitle:[NSString stringWithFormat:@"(%ld) 完成",(unsigned long)_selectCount] forState:UIControlStateNormal];
        self.rightBtn.enabled = YES;
    } else {
        [self.rightBtn setTitle:@"完成" forState:UIControlStateNormal];
        self.rightBtn.enabled = NO;
    }
}

-(void)setIsSelectOrginal:(BOOL)isSelectOrginal {
    _isSelectOrginal = isSelectOrginal;
    
    //TODO:设置按钮的选择状态
    
    if (self.orginalLength && isSelectOrginal) {
        [self.leftBtn setTitle:[NSString stringWithFormat:@"原图(%@)",self.orginalLength] forState:UIControlStateNormal];
    } else {
        [self.leftBtn setTitle:@"原图" forState:UIControlStateNormal];
    }
}

-(void)setOrginalLength:(NSString *)orginalLength {
    _orginalLength = orginalLength;
    if (_orginalLength && self.isSelectOrginal) {
        [self.leftBtn setTitle:[NSString stringWithFormat:@"原图(%@)",self.orginalLength] forState:UIControlStateNormal];
    } else {
        [self.leftBtn setTitle:@"原图" forState:UIControlStateNormal];
    }
}

@end
