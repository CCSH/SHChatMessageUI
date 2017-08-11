//
//  SHDrawingBoardView.h
//  iOSAPP
//
//  Created by CSH on 2016/11/3.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 画板视图
 */

//画板类型
typedef NS_ENUM(NSInteger, DrawingBoardType) {
    DrawingBoardType_None = 0,  //默认
    DrawingBoardType_Paint,     //绘画
    DrawingBoardType_Erase,     //清除
};

@interface SHDrawingBoardView : UIImageView

//画板类型
@property (nonatomic, readwrite) DrawingBoardType drawingType;
//画笔颜色
@property (nonatomic, strong) UIColor *lineColor;
//画笔粗细
@property (nonatomic, assign) float lineWidth;

@end
