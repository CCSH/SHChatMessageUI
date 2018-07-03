//
//  SHMessageHeader.h
//  SHChatUI
//
//  Created by CSH on 2018/6/5.
//  Copyright © 2018年 CSH. All rights reserved.
//

#ifndef SHMessageHeader_h
#define SHMessageHeader_h


#endif /* SHMessageHeader_h */


//Caches目录
#define CachesPatch NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]

#pragma mark - 聊天资源路径
//语音WAV路径
#define kSHPath_voice_wav [SHFileHelper getCreateFilePath:[NSString stringWithFormat:@"%@/APPData/Chat/Voice/WAV",CachesPatch]]
//语音AMR路径
#define kSHPath_voice_amr [SHFileHelper getCreateFilePath:[NSString stringWithFormat:@"%@/APPData/Chat/Voice/AMR",CachesPatch]]
//图片路径
#define kSHPath_image [SHFileHelper getCreateFilePath:[NSString stringWithFormat:@"%@/APPData/Chat/Image",CachesPatch]]
//Gif路径
#define kSHPath_gif [SHFileHelper getCreateFilePath:[NSString stringWithFormat:@"%@/APPData/Chat/Gif",CachesPatch]]
//视频路径
#define kSHPath_video [SHFileHelper getCreateFilePath:[NSString stringWithFormat:@"%@/APPData/Chat/Video",CachesPatch]]
//视频第一帧图片路径
#define kSHPath_video_image [SHFileHelper getCreateFilePath:[NSString stringWithFormat:@"%@/APPData/Chat/VideoImage",CachesPatch]]

#pragma mark - 颜色定义
//三原色
#define kRGB(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
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
#define kSHInPutIcon_WH 35

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

#define kIsIphoneX (([[UIApplication sharedApplication] statusBarFrame].size.height > 20))

#define kSHBottomSafe (kIsIphoneX?39:0)
#define kSHTopSafe ([[UIApplication sharedApplication] statusBarFrame].size.height)

#define kSHWeak(VAR) \
try {} @finally {} \
__weak __typeof__(VAR) VAR##_myWeak_ = (VAR)

#define kSHStrong(VAR) \
try {} @finally {} \
__strong __typeof__(VAR) VAR = VAR##_myWeak_;\
if(VAR == nil) return

#pragma mark - 文件
//聊天界面
#import "SHChatMessageViewController.h"
//聊天界面帮助类
#import "SHMessageHelper.h"
//语音提示框
#import "SHMessageVoiceHUD.h"
//多媒体
#import <AVFoundation/AVFoundation.h>
//文件
#import "SHFileHelper.h"
//音频操作
#import "VoiceConverter.h"
//音频播放
#import "SHAudioPlayerHelper.h"
//音频录制
#import "SHVoiceRecordHelper.h"
//消息模型
#import "SHMessage.h"
//类型
#import "SHMessageType.h"
#import "SHMessageFrame.h"
#import <UIKit/UIKit.h>

#import "Singleton.h"

//表情键盘
#import "SHEmotionKeyboard.h"
#import "SHEmotionTool.h"
//菜单
#import "SHShareMenuView.h"
//聊天cell
#import "SHChatMessageTableViewCell.h"
//聊天内容
#import "SHMessageContentView.h"
//长按菜单
#import "SHMenuController.h"

#import "UIView+SHExtension.h"
