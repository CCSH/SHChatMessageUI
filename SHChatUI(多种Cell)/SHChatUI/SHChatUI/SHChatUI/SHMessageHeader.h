//
//  SHMessageHeader.h
//  SHChatUI
//
//  Created by CSH on 2018/6/5.
//  Copyright © 2018年 CSH. All rights reserved.
//

#ifndef SHMessageHeader_h
#define SHMessageHeader_h


#define kSHWeak(VAR) \
    try {            \
    } @finally {     \
    }                \
    __weak __typeof__(VAR) VAR##_myWeak_ = (VAR)

#define kSHStrong(VAR)                            \
    try {                                         \
    } @finally {                                  \
    }                                             \
    __strong __typeof__(VAR) VAR = VAR##_myWeak_; \
    if (VAR == nil)                               \
    return

//Caches目录
#define CachesPatch NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]

#pragma mark - 聊天资源路径
//语音WAV路径
#define kSHPath_audio_wav [SHFileHelper getCreateFilePath:[NSString stringWithFormat:@"%@/APPData/Chat/Audio/WAV", CachesPatch]]
//语音AMR路径
#define kSHPath_audio_amr [SHFileHelper getCreateFilePath:[NSString stringWithFormat:@"%@/APPData/Chat/Audio/AMR", CachesPatch]]
//图片路径
#define kSHPath_image [SHFileHelper getCreateFilePath:[NSString stringWithFormat:@"%@/APPData/Chat/Image", CachesPatch]]
//Gif路径
#define kSHPath_gif [SHFileHelper getCreateFilePath:[NSString stringWithFormat:@"%@/APPData/Chat/Gif", CachesPatch]]
//视频路径
#define kSHPath_video [SHFileHelper getCreateFilePath:[NSString stringWithFormat:@"%@/APPData/Chat/Video", CachesPatch]]
//视频第一帧图片路径
#define kSHPath_video_image [SHFileHelper getCreateFilePath:[NSString stringWithFormat:@"%@/APPData/Chat/VideoImage", CachesPatch]]
//文件路径
#define kSHPath_file [SHFileHelper getCreateFilePath:[NSString stringWithFormat:@"%@/APPData/Chat/File", CachesPatch]]

#pragma mark - 颜色定义
//三原色
#define kRGB(R, G, B, A) [UIColor colorWithRed:R / 255.0 green:G / 255.0 blue:B / 255.0 alpha:A]
//输入框及菜单背景颜色
#define kInPutViewColor kRGB(243, 243, 247, 1)
//按钮背景颜色
#define kShareMenuViewItemColor kRGB(255, 255, 255, 1)

#pragma mark - 宏定义

//输入框高度
#define kSHInPutHeight 49
//输入框控件间隔
#define kSHInPutSpace 7
//输入框控件宽高
#define kSHInPutIcon_size CGSizeMake(35, 35)
//输入框最多几行
#define kSHInPutNum 5

//菜单一行几个
#define kSHShareMenuPerRowItemCount 4
//菜单几行
#define kSHShareMenuPerColum 2
//下方菜单选项宽高
#define kSHShareMenuItemWH 60
//下方菜单选项整体的高度(KXHShareMenuItemHeight - kXHShareMenuItemWH 为标题的高)
#define KSHShareMenuItemHeight 80
//下方菜单控件上下间隔
#define KSHShareMenuItemTop 15
//页码高度
#define kSHShareMenuPageControlHeight 30

//设备Size
#define kSHWidth ([[UIScreen mainScreen] bounds].size.width)
#define kSHHeight ([[UIScreen mainScreen] bounds].size.height)

//下方输入控件高度
#define kChatMessageInput_H 205

//录音最大时长与最小
#define kSHMaxRecordTime 60
#define kSHMinRecordTime 1

#define kIsFull (kSHTopSafe > 20)

#define kSHBottomSafe (kIsFull ? 39 : 0)
#define kSHTopSafe ([[UIApplication sharedApplication] statusBarFrame].size.height)

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

#pragma mark - 文件
//聊天界面
#import "SHChatMessageViewController.h"
//聊天界面帮助类
#import "SHMessageHelper.h"
//语音提示框
#import "SHMessageVoiceHUD.h"

//文件
#import "SHFileHelper.h"
//音频操作
#import "VoiceConverter.h"
//音频播放
#import "SHAudioPlayerHelper.h"
//音频录制
#import "SHAudioRecordHelper.h"
//消息模型
#import "SHMessage.h"
//类型
#import "SHMessageEnum.h"
//cell frame计算
#import "SHMessageFrame.h"

//表情键盘
#import "SHEmotionKeyboard.h"
#import "SHEmotionTool.h"
//菜单
#import "SHShareMenuView.h"
//聊天cell
#import "SHMessageTableViewCell.h"
//长按菜单
#import "SHMenuController.h"
//消息状态
#import "SHActivityIndicatorView.h"
//聊天气泡
#import "SHBubbleButton.h"
//文本框
#import "SHTextView.h"

//多媒体
#import <AVFoundation/AVFoundation.h>
#import <SHTool.h>
#import <UIImage+SHExtension.h>
#import <UIKit/UIKit.h>
#import <UIView+SHExtension.h>
#import <WebKit/WebKit.h>
#import <UIButton+WebCache.h>

#endif /* SHMessageHeader_h */


