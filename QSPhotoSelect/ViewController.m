//
//  ViewController.m
//  QSPhotoSelect
//
//  Created by ZJ-Jie on 2017/3/21.
//  Copyright © 2017年 ZJ-Jie. All rights reserved.
//

#import "ViewController.h"
#import "QSPhotoSelectViewController.h"
#import "QSPhotoGroup.h"
#import "Utils.h"

@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    QSPhotoGroup *group = [[QSPhotoGroup alloc] initWithFetchResult:nil withGroupType:QSPhotoGroupAllPhoto];
    QSPhotoAsset *asset = [group.photoAssets firstObject];
    [asset getFillThumbnailWithSize:CGSizeMake(200, 200) callback:^(UIImage *image) {
        [self.photo setImage:image];
    }];
    
    [self addNotification];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%s",__func__);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"%s",__func__);
}

- (IBAction)selectPhotos:(UIButton *)sender {
    
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    pickerImage.allowsEditing = YES;
    pickerImage.delegate = self;
    
    [self presentViewController:pickerImage animated:YES completion:nil];
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self.photo setImage:image];
}

- (IBAction)presentToPhotoSelectVC:(id)sender {
    QSPhotoSelectViewController *vc = [[QSPhotoSelectViewController alloc] init];
    
    //设置VC属性
    vc.maxCount = 3;
    vc.needRightBtn = YES;
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(completeSelect:) name:@"completeSelect" object:nil];
}

- (void)completeSelect:(NSNotification *)notif {
    NSLog(@"%@",notif.object);
    NSArray *arr = notif.object;
    NSString *message = [NSString stringWithFormat:@"选择了%ld张照片",arr.count];
        [Utils showAlertViewWithController:self title:@"选择完成" message:message confirmButton:nil];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"completeSelect" object:nil];
}

@end
