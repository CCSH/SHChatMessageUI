//
//  SHDataConversion.h
//  iOSAPP
//
//  Created by CSH on 16/9/6.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SHDataConversion : NSObject

/**
 image --> data

 @param image 图片
 @param num   倍数

 @return 数据
 */
+ (NSData *)imageToData:(UIImage *)image CompressionNum:(int)num;

@end
