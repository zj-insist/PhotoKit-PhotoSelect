//
//  QSBrowserCell.m
//  QSPhotoSelect
//
//  Created by ZJ-Jie on 2017/3/28.
//  Copyright © 2017年 ZJ-Jie. All rights reserved.
//

#import "QSBrowserCell.h"

@interface QSBrowserCell()

@property(nonatomic, strong) UIImageView *imageView;

@end

@implementation QSBrowserCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    QSBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:QSBrowserCellIdentifier forIndexPath:indexPath];

    return cell;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

-(void)setImage:(UIImage *)image {
    _image = image;
    [self.imageView setImage:image];
}



@end
