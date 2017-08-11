//
//  SHPhotoBrowserCell.m
//  LazyWeather
//
//  Created by KevinSH on 15/12/6.
//  Copyright © 2015年 SHXiaoMing. All rights reserved.
//

#import "SHPhotoBrowserCell.h"

@implementation SHPhotoBrowserCell

- (IBAction)selectBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.selectedBlock) self.selectedBlock(sender.selected);
}

- (IBAction)imageTapAction:(UIButton *)sender {
    if (self.imgTapBlock) self.imgTapBlock();
}

@end
