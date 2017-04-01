//
//  Utils.m
//  QSPhotoSelect
//
//  Created by ZJ-Jie on 2017/3/28.
//  Copyright © 2017年 ZJ-Jie. All rights reserved.
//

#import "Utils.h"
#import "MacroDefinition.h"
#import "Constants.h"


@implementation Utils

+ (void)addNavBarCancelButtonWithController:(UIViewController *)controller{
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                               target:controller
                                               action:@selector(cancelBtnTouched)];
    
    temporaryBarButtonItem.tintColor = UIColorFromRGBA(0x53D107,1.0);
    controller.navigationItem.rightBarButtonItem = temporaryBarButtonItem;
    
}


+ (void)showAlertViewWithController:(UIViewController *)controller title:(NSString *)title message:(NSString *)message confirmButton:(ConfirmHandle)handle {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if (!handle) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"了解" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
    } else {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:handle];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
    }
    [controller presentViewController:alertController animated:YES completion:nil];
}

+ (CGSize)getLimitSize:(CGSize)size {
    return [Utils getLimitSize:size maxSize:QSPhotoMaxSize];
}

+ (CGSize)getOrginalLimitSize:(CGSize)size {
    return [Utils getLimitSize:size maxSize:QSPhotoOrginalMaxSize];
}

+ (CGSize)getLimitSize:(CGSize)size maxSize:(CGFloat)maxSize {
    CGSize limitSize = CGSizeZero;
    if (size.width < maxSize && size.height < maxSize) {
        limitSize = size;
    } else if (size.width >= maxSize && size.height < size.width) {
        limitSize.width = maxSize;
        limitSize.height = maxSize / size.width * size.height;
    } else if (size.width < size.height && size.height >= maxSize) {
        limitSize.height = maxSize;
        limitSize.width = maxSize / size.height * size.width;
    }
    return limitSize;
}


@end
