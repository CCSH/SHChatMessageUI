//
//  UIView+SHExtension.h
//  iOSAPP
//
//  Created by CSH on 16/7/5.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  View的坐标拓展
 */
@interface UIView (Extension)

//X轴
@property (nonatomic, assign) CGFloat x;
//Y轴
@property (nonatomic, assign) CGFloat y;
//右边X轴(只有GET)
@property (nonatomic, assign) CGFloat maxX;
//右边Y轴(只有GET)
@property (nonatomic, assign) CGFloat maxY;
//中心点X轴
@property (nonatomic, assign) CGFloat centerX;
//中心点Y轴
@property (nonatomic, assign) CGFloat centerY;
//宽度
@property (nonatomic, assign) CGFloat width;
//高度
@property (nonatomic, assign) CGFloat height;
//尺寸（width、height）
@property (nonatomic, assign) CGSize size;
//位置(X、Y)
@property (nonatomic, assign) CGPoint origin;

/*
 * 寻找1像素的线(可以用来隐藏导航栏下面的黑线）
 */
- (UIImageView *)findHairlineImageViewUnder;

@end
