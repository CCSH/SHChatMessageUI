//
//  SHDrawingBoardView.m
//  iOSAPP
//
//  Created by CSH on 2016/11/3.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import "SHDrawingBoardView.h"

@interface SHDrawingBoardView () {
    CGPoint previousPoint;
    CGPoint currentPoint;
}

@end

@implementation SHDrawingBoardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark - setter methods
- (void)setDrawingType:(DrawingBoardType)drawingType {
    _drawingType = drawingType;
}

#pragma mark - Private methods
- (void)setup {
    
    self.userInteractionEnabled = YES;
    
    currentPoint = CGPointMake(0, 0);
    previousPoint = currentPoint;
    
    _drawingType = DrawingBoardType_None;
    
    _lineColor = [UIColor blackColor];
}

#pragma mark 清除
- (void)eraseLine {
    
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.image drawInRect:self.bounds];
    
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
    
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), self.lineWidth);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), previousPoint.x, previousPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    previousPoint = currentPoint;
    
    [self setNeedsDisplay];
}

#pragma mark 绘制
- (void)drawLineNew {
    
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.image drawInRect:self.bounds];
    
    //设置圆角
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    //设置画笔颜色
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), self.lineColor.CGColor);
    //设置线宽
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), self.lineWidth);
    
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    //线的起始端
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), previousPoint.x, previousPoint.y);
    //线的终端
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    previousPoint = currentPoint;
    
    [self setNeedsDisplay];
}

- (void)handleTouches {
    if (self.drawingType == DrawingBoardType_Paint) {//绘画
        
        [self drawLineNew];
    }else if (self.drawingType == DrawingBoardType_Erase) {//清除
        
        [self eraseLine];
    }
}

#pragma mark - Touches methods
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint p = [[touches anyObject] locationInView:self];
    previousPoint = p;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    currentPoint = [[touches anyObject] locationInView:self];
    
    [self handleTouches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    currentPoint = [[touches anyObject] locationInView:self];
    
    [self handleTouches];
}


@end
