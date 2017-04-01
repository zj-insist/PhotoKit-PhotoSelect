//
//  MacroDefinition.h
//  QSPhotoSelect
//
//  Created by ZJ-Jie on 2017/3/28.
//  Copyright © 2017年 ZJ-Jie. All rights reserved.
//

#import "QSPhotoManage.h"

#ifndef MacroDefinition_h
#define MacroDefinition_h

#define UIColorFromRGBA(RGBValue, alphaValue) [UIColor colorWithRed:((float)((RGBValue & 0xFF0000) >> 16))/255.0 green:((float)((RGBValue & 0x00FF00) >> 8))/255.0 blue:((float)(RGBValue & 0x0000FF))/255.0 alpha:alphaValue]

#define QSPhotoManage [QSPhotoManage shareQSPhotoManage]

#define QSPhotoThumbnailSize CGSizeMake(200, 200)

#endif /* MacroDefinition_h */
