//
//  QSBrowserHeadView.h
//  QSPhotoSelect
//
//  Created by ZJ-Jie on 2017/3/29.
//  Copyright © 2017年 ZJ-Jie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QSBrowserHeadViewDelegate <NSObject>

-(void)QS_headerViewLeftBtnTouched;
-(BOOL)QS_headerViewRightBtnTouched:(BOOL)isSelected;

@end

@interface QSBrowserHeadView : UIView

@property(nonatomic, weak) id<QSBrowserHeadViewDelegate> delegate;

@property(nonatomic, assign) BOOL isSelected;

@property(nonatomic, assign) BOOL needCheckedBtn;

@end
