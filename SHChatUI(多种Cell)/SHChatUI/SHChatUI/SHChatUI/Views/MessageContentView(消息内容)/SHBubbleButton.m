//
//  SHBubbleButton.m
//  SHChatUI
//
//  Created by CCSH on 2020/12/24.
//  Copyright © 2020 CSH. All rights reserved.
//

#import "SHBubbleButton.h"
#import "SHMessageHeader.h"

@implementation SHBubbleButton

#pragma mark 剪切视图
- (void)makeMaskView{
    
    dispatch_async(dispatch_get_main_queue(), ^{

        CALayer *maskLayer = [CALayer layer];
        maskLayer.frame = self.bounds;

        //把视图设置成图片的样子
        UIImage *image = self.currentBackgroundImage;
        [maskLayer setContents:(id)image.CGImage];
        [maskLayer setContentsScale:image.scale];
        [maskLayer setContentsCenter:CGRectMake(((image.size.width/2) - 1)/image.size.width, ((image.size.height/1.5) - 1)/image.size.height, 1 / image.size.width, 1 / image.size.height)];

        self.layer.mask = maskLayer;
    });
}

#pragma mark 设置气泡背景图片
- (void)setBubbleImage:(UIImage *)image{
    
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(35, 25, 10, 25)];
    [self setBackgroundImage:image forState:UIControlStateNormal];
    [self setBackgroundImage:image forState:UIControlStateHighlighted];
}

#pragma mark 设置气泡背景图片颜色
- (void)setBubbleColor:(UIColor *)color{
    
    UIImage *image = [self.currentBackgroundImage imageWithColor:color];
    [self setBubbleImage:image];
}


@end
