//
//  UIView+SHExtension.m
//  SHExtension
//
//  Created by CSH on 2018/9/19.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import "UIView+SHExtension.h"

@implementation UIView (SHExtension)

#pragma mark - frame
- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setMaxX:(CGFloat)maxX {
    
}

- (CGFloat)maxX {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setMaxY:(CGFloat)maxY {
    
}

- (CGFloat)maxY {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY {
    return self.center.y;
}


- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin.x = origin.x;
    frame.origin.y = origin.y;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (UIViewController *)sh_vc {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

#pragma mark - 描边
- (void)borderRadius:(CGFloat)radius width:(CGFloat)width color:(UIColor *)color{
    
    [self.layer setBorderWidth:(width)];
    [self.layer setCornerRadius:(radius)];
    [self.layer setBorderColor:[color CGColor]];
    [self.layer setMasksToBounds:YES];
}

- (void)borderRadius:(CGFloat)radius corners:(UIRectCorner *)corners
{
    CGRect rect = self.bounds;
    //byRoundingCorners:UIRectCornerBottomLeft 左边边角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];

    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

#pragma mark - 获取一个渐变色的视图
+ (UIView *)getGradientViewWithSize:(CGSize)size startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint colorArr:(NSArray *)colorArr{
    
    UIView *view = [[UIView alloc]init];
    view.size = size;
    //  CAGradientLayer类对其绘制渐变背景颜色、填充层的形状(包括圆角)
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    //  创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = colorArr;
    
    //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
    gradientLayer.startPoint = startPoint;
    gradientLayer.endPoint = endPoint;
    
    // 设置渐变位置
    CGFloat loc = 1.0/(colorArr.count - 1);
    NSMutableArray *location = [[NSMutableArray alloc]init];
    [location addObject:@0];
    NSInteger index = 1;
    
    while (index != colorArr.count) {
        [location addObject:[NSNumber numberWithFloat:index*loc]];
        index++;
    }
    
    //设置颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = location;
    
    [view.layer addSublayer:gradientLayer];
    
    return view;
}

#pragma mark - xib 属性
#pragma mark 设置边框宽度
- (void)setBorderWidth:(CGFloat)borderWidth {
    
    if (borderWidth < 0) return;
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)borderWidth{
    return self.layer.borderWidth;
}

#pragma mark 设置边框颜色
- (void)setBorderColor:(UIColor *)borderColor {
    
    self.layer.borderColor = borderColor.CGColor;
}

- (UIColor *)borderColor{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

#pragma mark 设置圆角
- (void)setCornerRadius:(CGFloat)cornerRadius {
    
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = cornerRadius > 0;
}

- (CGFloat)cornerRadius{
    return self.layer.cornerRadius;
}

#pragma mark剪切
- (void)setMasksToBounds:(BOOL)masksToBounds{
    self.layer.masksToBounds = masksToBounds;
}

- (BOOL)masksToBounds{
    return self.layer.masksToBounds;
}

#pragma mark 阴影颜色
- (void)setShadowColor:(UIColor *)shadowColor{
    self.layer.shadowColor = shadowColor.CGColor;
}

- (UIColor *)shadowColor{
    return [UIColor colorWithCGColor:self.layer.shadowColor];
}

#pragma mark 阴影偏移
- (void)setShadowOffset:(CGSize)shadowOffset{
    
    self.layer.shadowOffset = shadowOffset;
}

- (CGSize)shadowOffset{
    return self.layer.shadowOffset;
}

#pragma mark 阴影透明度
- (void)setShadowOpacity:(CGFloat)shadowOpacity{
    self.layer.shadowOpacity = shadowOpacity;
}

- (CGFloat)shadowOpacity{
    return self.layer.shadowOpacity;
}

#pragma mark 阴影半径
- (void)setShadowRadius:(CGFloat)shadowRadius{
    self.layer.shadowRadius = shadowRadius;
}

- (CGFloat)shadowRadius{
    return self.layer.shadowRadius;
}

@end
