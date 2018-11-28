//
//  SHMessageContentView.m
//  SHChatMessageUI
//
//  Created by CSH on 16/7/30.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import "SHMessageContentView.h"
#import "SHMessageHeader.h"
#import "SHMessageFrame.h"
#import "SHLocation.h"

@implementation SHMessageContentView

#pragma mark 剪切视图
- (void)makeMaskView:(UIView *)view image:(UIImage *)image{
    
    UIImageView *imageViewMask = [[UIImageView alloc] init];
    imageViewMask.frame = view.frame;
    imageViewMask.image = image;
    view.layer.mask = imageViewMask.layer;
}

@end
