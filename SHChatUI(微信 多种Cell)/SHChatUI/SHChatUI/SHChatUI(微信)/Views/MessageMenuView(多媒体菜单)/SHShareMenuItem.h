//
//  SHShareMenuItem.h
//  SHChatMessageUI
//
//  Created by CSH on 16/7/27.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 多媒体菜单按钮
 */
@interface SHShareMenuItem : NSObject

/**
 *  正常显示图片
 */
@property (nonatomic, strong) UIImage *icon;

/**
 *  第三方按钮的标题
 */
@property (nonatomic, copy) NSString *title;
/**
 *  第三方按钮的标题颜色
 */
@property (nonatomic, strong) UIColor *titleColor;

/**
 *  第三方按钮的标题字体大小
 */
@property (nonatomic, strong) UIFont *titleFont;

@end
