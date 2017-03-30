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
    QSBottomViewStyle _style;
}

@property(nonatomic, strong) UIButton *leftBtn;
@property(nonatomic, strong) UIButton *rightBtn;
@property(nonatomic, assign) BOOL isSelectOrginal;
@property(nonatomic, strong) NSString *dataLength;

@end

@implementation QSPhotosBottomView

- (instancetype)initWithFrame:(CGRect)frame bottomViewStyle:(QSBottomViewStyle)style {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupRightBtn];
        _style = style;
        if (style == QSBottomViewStyleSelect) {
            [self setupLeftBtnWithStyle:QSPHOTOBUTTONSTYLEBROWSER];
        } else {
            [self setupLeftBtnWithStyle:QSPHOTOBUTTONSTYLEORIGINAL];
        }
        [self setBackgroundColor:UIColorFromRGBA(0x141414,0.7)];
    }
    return self;
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


-(void)setSelectCount:(NSUInteger)selectCount {
    _selectCount = selectCount;
    if (_selectCount > 0) {
        [self.rightBtn setTitle:[NSString stringWithFormat:@"(%ld) 完成",_selectCount] forState:UIControlStateNormal];
        self.rightBtn.enabled = YES;
    } else {
        [self.rightBtn setTitle:@"完成" forState:UIControlStateNormal];
        self.rightBtn.enabled = NO;
    }
}

-(void)setIsSelectOrginal:(BOOL)isSelectOrginal {
    _isSelectOrginal = isSelectOrginal;
    if (!self.dataLength) {
        [self.leftBtn setTitle:@"原图" forState:UIControlStateNormal];
    } else {
        [self.leftBtn setTitle:[NSString stringWithFormat:@"原图(%@)",self.dataLength] forState:UIControlStateNormal];
    }
}

-(void)leftBtnTouched {
    if (_style == QSBottomViewStyleSelect) {
        if ([self.delegate respondsToSelector:@selector(QS_bottomViewLeftBtnTouched)]) {
            [self.delegate QS_bottomViewLeftBtnTouched];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(QS_bottomViewOrginalBtnTouched)]) {
            self.isSelectOrginal = !self.isSelectOrginal;
            self.dataLength = self.isSelectOrginal ? [self.delegate QS_bottomViewOrginalBtnTouched] : nil;
        }
    }
}

- (void)rightBtnTouched {
    if ([self.delegate respondsToSelector:@selector(QS_bottomViewRightBtnTouched)]) {
        [self.delegate QS_bottomViewRightBtnTouched];
    }
}

@end
