//
//  Utils.m
//  PhototKitTest
//
//  Created by ZJ-Jie on 2017/3/28.
//  Copyright © 2017年 ZJ-Jie. All rights reserved.
//

#import "Utils.h"
#import "MacroDefinition.h"


@implementation Utils

+ (void)addNavBarCancelButtonWithController:(UIViewController *)controller{
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                               target:controller
                                               action:@selector(cancelBtnTouched)];
    
    temporaryBarButtonItem.tintColor = UIColorFromRGBA(0x53D107,1.0);
    controller.navigationItem.rightBarButtonItem = temporaryBarButtonItem;
    
}


@end
