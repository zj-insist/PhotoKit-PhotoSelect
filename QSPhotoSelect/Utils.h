//
//  Utils.h
//  QSPhotoSelect
//
//  Created by ZJ-Jie on 2017/3/28.
//  Copyright © 2017年 ZJ-Jie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QSCancelBarTouchEvent <NSObject>

@required

- (void) cancelBtnTouched;

@end

@interface Utils : NSObject

+ (void)addNavBarCancelButtonWithController:(UIViewController *)controller;

@end
