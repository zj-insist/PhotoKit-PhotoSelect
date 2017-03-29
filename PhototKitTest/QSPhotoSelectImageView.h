//
//  QSPhotoSelectImageView.h
//  PhototKitTest
//
//  Created by ZJ-Jie on 2017/3/22.
//  Copyright © 2017年 ZJ-Jie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSPhotoAsset.h"


@protocol QSPhotoSelectImageViewDelegate <NSObject>

-(BOOL)QS_selectedImageWithIndex:(QSPhotoAsset *)asset isSelect:(BOOL)select;

@end

@interface QSPhotoSelectImageView : UIView

@property(nonatomic, assign) BOOL isSelected;

@property(nonatomic, assign) BOOL needCheckedBtn;

@property(nonatomic, assign) QSPhotoAsset *asset;

@property(nonatomic, weak) id<QSPhotoSelectImageViewDelegate> itemDelegate;

@end
