//
//  QSOhotoSelectViewController.m
//  PhototKitTest
//
//  Created by ZJ-Jie on 2017/3/23.
//  Copyright © 2017年 ZJ-Jie. All rights reserved.
//

#import "QSPhotoSelectViewController.h"
#import "QSPhotoTableViewController.h"

@interface QSPhotoSelectViewController ()
@property(nonatomic, strong) QSPhotoTableViewController *tableViewVC;
@end

@implementation QSPhotoSelectViewController

- (instancetype)init {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    QSPhotoTableViewController *vc = (QSPhotoTableViewController *)[storyboard instantiateViewControllerWithIdentifier:@"AlbumSelect"];

    self = [super initWithRootViewController:vc];
    if (self) {
        self.tableViewVC = vc;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//- (void)createNavigationController{
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    self.tableViewVC = (QSPhotoTableViewController *)[storyboard instantiateViewControllerWithIdentifier:@"AlbumSelect"];
//    self.tableViewVC.maxCount = self.maxCount;
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.tableViewVC];
//    
//    nav.view.frame = self.view.bounds;
//    [self addChildViewController:nav];
//    [self.view addSubview:nav.view];
//}


-(void)setMaxCount:(NSUInteger)maxCount {
    if (maxCount <= 0) return;
    _maxCount = maxCount;
    self.tableViewVC.maxCount = maxCount;
}

-(void)setNeedRightBtn:(BOOL)needRightBtn {
    _needRightBtn = needRightBtn;
    self.tableViewVC.needRightBtn = needRightBtn;
}




@end
