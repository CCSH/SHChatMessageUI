//
//  UIImageView+SHExtension.m
//  SHExtensionExample
//
//  Created by CSH on 2018/9/20.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import "UIImageView+SHExtension.h"

@implementation UIImageView (SHExtension)

//获取图片在视图的frame
- (CGRect)getImageFrame{
    
    UIImage *image = self.image;
    
    float hfactor = image.size.width / self.frame.size.width;
    float vfactor = image.size.height / self.frame.size.height;
    
    float factor = fmax(hfactor, vfactor);
    
    // Divide the size by the greater of the vertical or horizontal shrinkage factor
    int image_width = image.size.width / factor;
    int image_height = image.size.height / factor;
    
    // Then figure out if you need to offset it to center vertically or horizontally
    int image_x = (self.frame.size.width - image_width) / 2;
    int image_y = (self.frame.size.height - image_height) / 2;
    
    return CGRectMake(image_x, image_y, image_width, image_height);
}

@end
