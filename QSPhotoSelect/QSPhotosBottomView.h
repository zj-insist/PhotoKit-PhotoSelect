//
//  QSPhotosBottomView.h
//  QSPhotoSelect
//
//  Created by ZJ-Jie on 2017/3/23.
//  Copyright © 2017年 ZJ-Jie. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, QSBottomViewStyle) {
    QSBottomViewStyleSelect,
    QSBottomViewStyleBrowser
};

@protocol QSBottomViewDelegate <NSObject>

@optional
-(void)QS_bottomViewLeftBtnTouched;
-(void)QS_bottomViewRightBtnTouched;
-(NSString *)QS_bottomViewOrginalBtnTouched;

@end

typedef void (^TouchBottomViewButton)();

@interface QSPhotosBottomView : UIView

@property(nonatomic, assign) NSUInteger selectCount;

@property(nonatomic, weak) id<QSBottomViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame bottomViewStyle:(QSBottomViewStyle)style;

@end
