//
//  UIView+GetViewLayout.h
//  PhototKitTest
//
//  Created by ZJ-Jie on 2017/3/28.
//  Copyright © 2017年 ZJ-Jie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GetViewLayout)

@property (nonatomic,assign) CGFloat x;
@property (nonatomic,assign) CGFloat y;

- (CGFloat)width;
- (void)setWidth:(CGFloat)width;

- (CGFloat)height;
- (void)setHeight:(CGFloat)height;

- (CGFloat)bottomPosition;

- (CGSize)size;
- (void)setSize:(CGSize)size;

- (CGPoint)origin;
- (void)setOrigin:(CGPoint)point;

- (CGFloat)xPosition;
- (CGFloat)yPosition;
- (CGFloat)baselinePosition;

- (void)positionAtX:(CGFloat)xValue;
- (void)positionAtY:(CGFloat)yValue;
- (void)positionAtX:(CGFloat)xValue andY:(CGFloat)yValue;

- (void)positionAtX:(CGFloat)xValue andY:(CGFloat)yValue withWidth:(CGFloat)width;
- (void)positionAtX:(CGFloat)xValue andY:(CGFloat)yValue withHeight:(CGFloat)height;

- (void)positionAtX:(CGFloat)xValue withHeight:(CGFloat)height;

- (void)removeSubviews;

- (void)centerInSuperView;
- (void)aestheticCenterInSuperView;

- (void)bringToFront;
- (void)sendToBack;

- (void)centerAtX;

- (void)centerAtXQuarter;

- (void)centerAtX3Quarter;


@end
