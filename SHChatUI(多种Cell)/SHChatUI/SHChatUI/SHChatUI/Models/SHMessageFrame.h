//
//  SHMessageFrame.h
//  SHChatUI
//
//  Created by CSH on 2018/6/5.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHMessageHeader.h"
@class SHMessage;

/**
 聊天内容计算model
 */
@interface SHMessageFrame : NSObject

//聊天模型
@property (nonatomic, strong) SHMessage *message;
//是否显示时间
@property (nonatomic, assign) BOOL showTime;
//是否显示姓名
@property (nonatomic, assign) BOOL showName;
//是否显示头像
@property (nonatomic, assign) BOOL showAvatar;


//内部计算
//时间CGRect
@property (nonatomic, assign, readonly) CGRect timeF;
//名字CGRect
@property (nonatomic, assign, readonly) CGRect nameF;
//头像CGRect
@property (nonatomic, assign, readonly) CGRect iconF;
//内容CGRect
@property (nonatomic, assign, readonly) CGRect contentF;
//整体cell高度
@property (nonatomic, assign, readonly) CGFloat cell_h;

//X初始位置
@property (nonatomic, assign, readonly) CGFloat startX;

@end
