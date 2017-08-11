//
//  SHPhotoAblumCell.h
//  LazyWeather
//
//  Created by KevinSH on 15/12/6.
//  Copyright © 2015年 SHXiaoMing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SHAblumInfo;
@interface SHPhotoAblumCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *ablumCover;
@property (weak, nonatomic) IBOutlet UILabel *ablumName;
@property (weak, nonatomic) IBOutlet UILabel *ablumCount;

+ (instancetype)cellForTableView:(UITableView *)tableView info:(SHAblumInfo *)info;

@end
