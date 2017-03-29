//
//  QSPhotosCollectionView.m
//  PhototKitTest
//
//  Created by ZJ-Jie on 2017/3/22.
//  Copyright © 2017年 ZJ-Jie. All rights reserved.
//

#import "QSPhotosCollectionView.h"
#import "QSPhotoSelectImageView.h"
#import <Photos/Photos.h>
#import "QSPhotosFooterView.h"
#import "QSPhotosBottomView.h"


static NSString *CellIdentifier = @"Cell";
static NSString *FooterIdentifier = @"Footer";


@interface QSPhotosCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,QSPhotoSelectImageViewDelegate>

//@property(nonatomic, strong) PHCachingImageManager *imageManager;

@end

@implementation QSPhotosCollectionView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.dataSource = self;
        self.delegate = self;
        [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
        [self registerClass:[QSPhotosFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FooterIdentifier];
    }
    return self;
}

#pragma mark - UICollection Delegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photoAssets.count;
}

-(NSInteger)numberOfSections {
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    QSPhotoSelectImageView *im = nil;
    
    if (![cell.contentView.subviews firstObject]) {
        im = [[QSPhotoSelectImageView alloc] initWithFrame:cell.contentView.bounds];
        [cell.contentView addSubview:im];
    } else {
        im = [cell.contentView.subviews firstObject];
    }
    
    im.itemDelegate = self;
    im.asset = self.photoAssets[indexPath.row];
    im.isSelected = NO;
    
    [self.selectImage enumerateObjectsUsingBlock:^(QSPhotoAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[obj getAssetLocalIdentifier] isEqualToString:[im.asset getAssetLocalIdentifier]]) {
            im.isSelected = YES;
            *stop = YES;
        }
    }];
//    im.isSelected = [self.selectImage indexOfObject:im.asset] == NSNotFound ? NO : YES;
    
//    [self.imageManager requestImageForAsset:self.photoAssets[indexPath.row] targetSize:CGSizeMake(100, 100) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//        im.photo = result;
//    }];
    return cell;
}


-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    QSPhotosFooterView *reusableView = nil;
    if (kind == UICollectionElementKindSectionFooter) {
        QSPhotosFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FooterIdentifier forIndexPath:indexPath];
        footerView.photoCount = self.photoAssets.count;
        reusableView = footerView;
    }
    return reusableView;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.touchitem) {
        self.touchitem(indexPath.item);
    }
}

#pragma mark - cusotm Delegate

-(BOOL)QS_selectedImageWithIndex:(QSPhotoAsset *)asset isSelect:(BOOL)select {
    
//    if (self.selectImage.count == self.maxCount && select) {
//        return NO;
//    } else if (!select) {
//        [self.selectImage removeObject:asset];
//    } else {
//        [self.selectImage addObject:asset];
//    }
//    NSLog(@"%@",self.selectImage);
//    return YES;
    if (self.selectCallBack) {
        return self.selectCallBack(asset,select);
    } else {
        return NO;
    }
    
}

#pragma mark - setter and getter



-(NSMutableArray<QSPhotoAsset *> *)selectImage {
    if (_selectImage == nil) {
        _selectImage = [NSMutableArray array];
    }
    return _selectImage;
}

#pragma mark - delete

//-(PHCachingImageManager *)imageManager {
//    if (_imageManager == nil) {
//        _imageManager = [[PHCachingImageManager alloc] init];
//    }
//    return _imageManager;
//}

@end
