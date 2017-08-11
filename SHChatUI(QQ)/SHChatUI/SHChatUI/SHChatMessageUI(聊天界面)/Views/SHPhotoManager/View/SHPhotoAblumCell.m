//
//  SHPhotoAblumCell.m
//  LazyWeather
//
//  Created by KevinSH on 15/12/6.
//  Copyright © 2015年 SHXiaoMing. All rights reserved.
//

#import "SHPhotoAblumCell.h"
#import "SHPhotoHeader.h"


@implementation SHPhotoAblumCell

+ (instancetype)cellForTableView:(UITableView *)tableView info:(SHAblumInfo *)info {
    //表格列表不多，不选择重用机制
    SHPhotoAblumCell * cell = [[NSBundle mainBundle]loadNibNamed:@"SHPhotoAblumCell" owner:tableView options:nil][0];
    [[SHPhotoManager manager]fetchImageInAsset:info.coverAsset size:CGSizeMake(120, 120) isResize:YES completeBlock:^(NSData *data, NSString *fileType) {
        cell.ablumCover.image = [UIImage imageWithData:data];
    }];
    cell.ablumName.text = info.ablumName;
    cell.ablumCount.text = [NSString stringWithFormat:@"(%ld)",(long)info.count];
    
    //line
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(100, 61 - SINGLE_LINE_ADJUST_OFFSET, SCREEN_W - 100, SINGLE_LINE_WIDTH)];
    line.backgroundColor = AblumsListLineColor;
    [cell.contentView addSubview:line];
    
    //indicator
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

@end
