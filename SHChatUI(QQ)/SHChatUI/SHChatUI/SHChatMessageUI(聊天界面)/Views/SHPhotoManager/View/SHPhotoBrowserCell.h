//
//  SHPhotoBrowserCell.h
//  LazyWeather
//
//  Created by KevinSH on 15/12/6.
//  Copyright © 2015年 SHXiaoMing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface SHPhotoBrowserCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *selBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imageIV;
@property (weak, nonatomic) PHAsset *asset;

@property (nonatomic, copy) void(^selectedBlock)(BOOL isSelected);
@property (nonatomic, copy) void(^imgTapBlock)();

@end
