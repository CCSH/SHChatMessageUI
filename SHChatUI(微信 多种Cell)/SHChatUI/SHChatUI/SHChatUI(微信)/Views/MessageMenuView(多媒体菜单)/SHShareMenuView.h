//
//  SHShareMenuView.h
//  SHChatMessageUI
//
//  Created by CSH on 16/7/27.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHShareMenuItem.h"

/**
 多媒体菜单视图
 */
@protocol SHShareMenuViewDelegate <NSObject>

@optional
//点击菜单
- (void)didSelecteShareMenuItem:(SHShareMenuItem *)menuItem index:(NSInteger)index;

@end

@interface SHShareMenuView : UIView

//功能数据
@property (nonatomic, strong) NSArray *shareMenuItems;
//代理
@property (nonatomic, weak) id <SHShareMenuViewDelegate> delegate;

/**
 *  根据数据源刷新自定义按钮的布局
 */
- (void)reloadData;

@end
