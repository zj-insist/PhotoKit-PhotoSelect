//
//  QSPhotoSelectAlbumCell.m
//  QSPhotoSelect
//
//  Created by ZJ-Jie on 2017/4/1.
//  Copyright © 2017年 ZJ-Jie. All rights reserved.
//

#import "QSPhotoSelectAlbumCell.h"
#import "Constants.h"
#import "MacroDefinition.h"
#import "Utils.h"

@interface QSPhotoSelectAlbumCell()

@property(nonatomic, strong) UILabel *albumNameLabel;
@property(nonatomic, strong) UILabel *albumCountLabel;
@property(nonatomic, strong) UIImageView *browserImageView;
@property(nonatomic, strong) UIImageView *rightImageView;

@end

@implementation QSPhotoSelectAlbumCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}


- (UIImageView *)browserImageView {
    if (!_browserImageView) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ALBUMCELL_HEIGHT, ALBUMCELL_HEIGHT)];
        [self.contentView addSubview:imageView];
        _browserImageView = imageView;
    }
    return _browserImageView;
}

-(UILabel *)albumNameLabel {
    if (!_albumNameLabel) {
        UILabel *label = [[UILabel alloc] init];
        [label setFont:[UIFont systemFontOfSize:17]];
        [self.contentView addSubview:label];
        _albumNameLabel = label;
    }
    return _albumNameLabel;
}


-(UILabel *)albumCountLabel {
    if (!_albumCountLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentRight;
        [label setFont:[UIFont systemFontOfSize:17]];
        [label setTextColor:UIColorFromRGBA(0xBDBDBD, 1.0)];
        [self.contentView addSubview:label];
        _albumCountLabel = label;
    }
    return _albumCountLabel;
}

-(void)setGroup:(QSPhotoGroup *)group {
    
    CGFloat height = self.bounds.size.height;
    CGFloat nameWidth = [Utils getWidthWithText:group.albumName height:height font:17];
    self.albumNameLabel.frame = CGRectMake(CGRectGetMaxX(self.browserImageView.frame) + ALBUMCELL_SPACE, 0, nameWidth, height);
    [self.albumNameLabel setText:group.albumName];
    
    NSString *countStr = [NSString stringWithFormat:@"(%ld)",(unsigned long)group.count];
    CGFloat countWidth = [Utils getWidthWithText:countStr height:height font:17];
    self.albumCountLabel.frame = CGRectMake(CGRectGetMaxX(self.albumNameLabel.frame) + ALBUMCELL_SPACE, 0, countWidth, height);
    [self.albumCountLabel setText:countStr];
    
    
    __weak __typeof(self)weakSelf = self;
    QSPhotoAsset *asset = [group.photoAssets firstObject];
    [asset getFitThumbnailWithSize:CGSizeMake(120, 120) callback:^(UIImage *image, NSString *assetIdentifier) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.browserImageView setImage:image];
    }];
}

@end
