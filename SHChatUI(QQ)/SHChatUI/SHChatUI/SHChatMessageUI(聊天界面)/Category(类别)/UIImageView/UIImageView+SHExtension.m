//
//  UIImageView+SHExtension.m
//  iOSAPP
//
//  Created by CSH on 2016/11/4.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import "UIImageView+SHExtension.h"

@implementation UIImageView (SHExtension)

#pragma mark 根据视图获取图片位置
- (CGRect)imageFrameSize{
    
    UIImage *image = self.image;
    float hfactor = image.size.width / self.frame.size.width;
    float vfactor = image.size.height / self.frame.size.height;
    
    float factor = fmax(hfactor, vfactor);
    
    // Divide the size by the greater of the vertical or horizontal shrinkage factor
    float newWidth = image.size.width / factor;
    float newHeight = image.size.height / factor;
    
    // Then figure out if you need to offset it to center vertically or horizontally
    float leftOffset = (self.frame.size.width - newWidth) / 2;
    float topOffset = (self.frame.size.height - newHeight) / 2;
    
    return CGRectMake(floor(leftOffset), floor(topOffset), floor(newWidth), floor(newHeight));
}

- (void)setImageFrameSize:(CGRect)imageFrameSize{
    
}

@end
