//
//  UIView+SHExtensionAnimation.h
//  LazyWeather
//
//  Created by KevinSH on 15/12/6.
//  Copyright © 2015年 SHXiaoMing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Animation)

/**
 *  从底部升起出现
 */
- (void)showFromBottom;

/**
 *  消失降到底部
 */
- (void)dismissToBottomWithCompleteBlock:(void(^)())completeBlock;

/**
 *  从透明到不透明
 */
- (void)emerge;

/**
 *  从不透明到透明
 */
- (void)fake;

/**
 *  按钮震动动画
 */
- (void)startSelectedAnimation;

@end
