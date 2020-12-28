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

//内容最大宽度（截取到气泡）
#define kChat_content_maxW (kSHWidth - 4*kChat_margin - 2*kChat_icon - kChat_angle_w - 40)

//消息中控件与内容间隔
static NSInteger const kChat_margin = 10;

//time
//时间间隙
static NSInteger const kChat_margin_time = 7;

//icon
//头像宽高
static NSInteger const kChat_icon = 45;

//name
//名字高度
static NSInteger const kChat_name_h = 15;

//聊天气泡角的宽度
static NSInteger const kChat_angle_w = 6;

//单行气泡高度
static NSInteger const kChat_min_h = kChat_icon;

//内容设置
//图片
//图片最大宽高
#define kChat_pic_size CGSizeMake(160, 160)
//语音
//语音最大size
#define kChat_voice_size CGSizeMake(160, kChat_min_h)
//位置
//位置size
#define kChat_location_size CGSizeMake(200, 120)
//名片
//名片的size
#define kChat_card_size CGSizeMake(200, 80.5)
//视频
//视频最大zise
#define kChat_video_size CGSizeMake(160, 160)
//动图
//Gif最大size
#define kChat_gif_size CGSizeMake(100, 100)
//红包
//红包size
#define kChat_red_size CGSizeMake(200, 80)
//文件
//文字size
#define kChat_file_size CGSizeMake(200, 76)

//字体
//时间字体
#define kChatFont_time [UIFont systemFontOfSize:11]
//ID字体
#define kChatFont_name [UIFont systemFontOfSize:11]
//内容字体
#define kChatFont_content [UIFont systemFontOfSize:16]
//提示内容字体
#define kChatFont_note [UIFont systemFontOfSize:12]

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
