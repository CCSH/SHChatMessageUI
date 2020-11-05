//
//  SHMenuController.m
//  SHChatUI
//
//  Created by CSH on 2018/6/25.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import "SHMenuController.h"

@implementation SHMenuController

#pragma mark - 显示菜单
+ (void)showMenuControllerWithView:(UIView *)view menuArr:(NSArray *)menuArr showPiont:(CGPoint)showPiont{
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    
    if (menu.isMenuVisible) {
        [menu setMenuVisible:NO animated:NO];
    }
    //菜单箭头方向(默认会自动判定)
    menu.arrowDirection = UIMenuControllerArrowDefault;
    //设置位置
    [menu setTargetRect:CGRectMake(showPiont.x, showPiont.y, 0, 0) inView:view];
    
    //添加内容
    [menu setMenuItems:menuArr];
    
    //显示菜单并且带动画
    [menu setMenuVisible:YES animated:YES];
    //为了保证下一次出现重新配置
    [menu setMenuItems:nil];
}

@end
