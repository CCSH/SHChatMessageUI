//
//  UIView+SHExtension.h
//  SHExtension
//
//  Created by CSH on 2018/9/19.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kSHWidth ([UIScreen mainScreen].bounds.size.width)
#define kSHHeight ([UIScreen mainScreen].bounds.size.height)

IBInspectable

@interface UIView (SHExtension)

#pragma mark - frame
//X轴
@property (nonatomic, assign) CGFloat x;
//Y轴
@property (nonatomic, assign) CGFloat y;
//右边X轴
@property (nonatomic, assign, readonly) CGFloat maxX;
//右边Y轴
@property (nonatomic, assign, readonly) CGFloat maxY;
//中心点X轴
@property (nonatomic, assign) CGFloat centerX;
//中心点Y轴
@property (nonatomic, assign) CGFloat centerY;
//宽度
@property (nonatomic, assign) CGFloat width;
//高度
@property (nonatomic, assign) CGFloat height;
//位置(X、Y)
@property (nonatomic, assign) CGPoint origin;
//尺寸（width、height）
@property (nonatomic, assign) CGSize size;

//获取控制器
@property (nullable, nonatomic, readonly) UIViewController *sh_vc;

#pragma mark - 描边
- (void)borderRadius:(CGFloat)radius width:(CGFloat)width color:(UIColor *)color;

- (void)borderRadius:(CGFloat)radius corners:(UIRectCorner *)corners;

#pragma mark - xib 属性
// 注意: 加上IBInspectable就可以可视化显示相关的属性
//圆角弧度
@property (nonatomic, assign)IBInspectable CGFloat cornerRadius;
//边框宽度
@property (nonatomic, assign)IBInspectable CGFloat borderWidth;
//边框颜色
@property (nonatomic, strong)IBInspectable UIColor *borderColor;
//剪切
@property (nonatomic, assign)IBInspectable BOOL masksToBounds;
//阴影相关
//阴影颜色
@property (nonatomic, strong)IBInspectable UIColor *shadowColor;
//阴影偏移
@property (nonatomic, assign)IBInspectable CGSize shadowOffset;
//阴影透明度
@property (nonatomic, assign)IBInspectable CGFloat shadowOpacity;
//阴影半径
@property (nonatomic, assign)IBInspectable CGFloat shadowRadius;

@end

NS_ASSUME_NONNULL_END
