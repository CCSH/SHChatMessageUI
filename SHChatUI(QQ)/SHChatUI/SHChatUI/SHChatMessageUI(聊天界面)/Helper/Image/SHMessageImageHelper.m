//
//  SHMessageImageHelper.m
//  SHChatUI
//
//  Created by CSH on 2017/8/11.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import "SHMessageImageHelper.h"

@implementation SHMessageImageHelper

#pragma mark 获取Size
+ (CGSize)getSizeWithMaxSize:(CGSize)maxSize Size:(CGSize)size{
    
    //规定的宽高都小于最大的 则使用规定的
    //    if (size.width <= maxSize.width && size.height <= maxSize.height) {
    //        return size;
    //    }
    if (MIN(size.width, size.height)) {
        
        if (size.width > size.height) {
            //宽大 按照宽给高
            CGFloat width = MIN(maxSize.width, size.height);
            return CGSizeMake(width, width*size.height/size.width);
        }else{
            //高大 按照高给宽
            CGFloat height = MIN(maxSize.height, size.height);
            return  CGSizeMake(height*size.width/size.height, height);
        }
    }
    
    return maxSize;
}

@end
