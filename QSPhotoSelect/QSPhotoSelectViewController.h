//
//  QSOhotoSelectViewController.h
//  QSPhotoSelect
//
//  Created by ZJ-Jie on 2017/3/23.
//  Copyright © 2017年 ZJ-Jie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSPhotoAsset.h"

typedef void (^SelectImagesCallBack)(NSArray<UIImage *> *images);

typedef void (^SelectAssetsCallBack)(NSArray<PHAsset *> *asset, BOOL isOrginal);

@interface QSPhotoSelectViewController : UINavigationController


@property(nonatomic, assign) NSUInteger maxCount;       /** 设置选择最大数量，默认为1，最大为9 */

@property(nonatomic, assign) BOOL needRightBtn;         /** 设置是否需要右侧的点选按钮 */


/**
 创建一个返回UIImage数组的图片选择器

 @param callBack 选择图片的回调
 @return <#return value description#>
 */
- (instancetype)initWithImagesCallBack:(SelectImagesCallBack)callBack;

- (instancetype)initWithAssetsCallBack:(SelectAssetsCallBack)callBack;

@end
