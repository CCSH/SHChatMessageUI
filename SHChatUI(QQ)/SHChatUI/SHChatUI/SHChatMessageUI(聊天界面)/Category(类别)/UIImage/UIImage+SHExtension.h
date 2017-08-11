//
//  UIImage+SHExtension.h
//  iOSAPP
//
//  Created by CSH on 16/7/5.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

//返回一个可以自由拉伸的图片
+ (UIImage *)resizedImage:(NSString *)name;

//对图片尺寸进行压缩
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

@end
