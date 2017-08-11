//
//  SHShareMenuView.h
//  SHChatMessageUI
//
//  Created by CSH on 16/7/27.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHShareMenuItem.h"

@protocol SHShareMenuViewDelegate <NSObject>

@optional
/**
 *  点击第三方功能回调方法
 *
 *  @param shareMenuItem 被点击的第三方Model对象，可以在这里做一些特殊的定制
 *  @param index         被点击的位置
 */
- (void)didSelecteShareMenuItem:(SHShareMenuItem *)shareMenuItem atIndex:(NSInteger)index;

@end

@interface SHShareMenuView : UIView

/**
 *  第三方功能Models
 */
@property (nonatomic, strong) NSArray *shareMenuItems;

@property (nonatomic, weak) id <SHShareMenuViewDelegate> delegate;

/**
 *  根据数据源刷新第三方功能按钮的布局
 */
- (void)reloadData;

@end
