//
//  QSPhotoSelectAlbumCell.h
//  QSPhotoSelect
//
//  Created by ZJ-Jie on 2017/4/1.
//  Copyright © 2017年 ZJ-Jie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSPhotoGroup.h"

static NSString *QSPhotoSelectAlbumCellIdentifier = @"QSPhotoAlbumCell";

@interface QSPhotoSelectAlbumCell : UITableViewCell

@property(nonatomic, strong) QSPhotoGroup *group;

@end
