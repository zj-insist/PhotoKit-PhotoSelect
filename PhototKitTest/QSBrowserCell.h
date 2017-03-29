//
//  QSBrowserCell.h
//  PhototKitTest
//
//  Created by ZJ-Jie on 2017/3/28.
//  Copyright © 2017年 ZJ-Jie. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *QSBrowserCellIdentifier = @"QSBrowserCell";

@interface QSBrowserCell : UICollectionViewCell

@property(nonatomic, strong) UIImage *image;

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@end
