//
//  SHMessageMacroHeader.h
//  SHChatMessageUI
//
//  Created by CSH on 16/7/25.
//  Copyright © 2016年 CSH. All rights reserved.
//

#ifndef SHMessageMacroHeader_h
#define SHMessageMacroHeader_h

#pragma mark - 文件路径
//Document目录
#define DocumentPatch [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

//Caches目录
#define CachesPatch NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]

//Temp目录
#define TempPatch NSTemporaryDirectory()

//语音WAV路径
#define kSHAudioWAVPath [SHFileHelper getCreateFilePath:[NSString stringWithFormat:@"%@/APPData/Chat/Audio/WAV",CachesPatch]]
//语音AMR路径
#define kSHAudioAMRPath [SHFileHelper getCreateFilePath:[NSString stringWithFormat:@"%@/APPData/Chat/Audio/AMR",CachesPatch]]
//图片路径
#define kSHImagePath [SHFileHelper getCreateFilePath:[NSString stringWithFormat:@"%@/APPData/Chat/Image",CachesPatch]]
//Gif路径
#define kSHGifPath [SHFileHelper getCreateFilePath:[NSString stringWithFormat:@"%@/APPData/Chat/Gif",CachesPatch]]
//视频路径
#define kSHVideoPath [SHFileHelper getCreateFilePath:[NSString stringWithFormat:@"%@/APPData/Chat/Video",CachesPatch]]
//视频第一帧图片路径
#define kSHVideoImagePath [SHFileHelper getCreateFilePath:[NSString stringWithFormat:@"%@/APPData/Chat/VideoImage",CachesPatch]]

//录音最大时长与最小
#define kSHMaxRecordTime 60
#define kSHMinRecordTime 1

//设备物理宽高
#define SHHeight ([UIScreen mainScreen].bounds.size.height)
#define SHWidth ([UIScreen mainScreen].bounds.size.width)

//自定义导航栏
#define kCustomNav 0

//下方菜单选项宽高
#define kSHShareMenuItemWH 60
//下方菜单选项整体的高度(KXHShareMenuItemHeight - kXHShareMenuItemWH 为标题的高)
#define KSHShareMenuItemHeight 80
//下方菜单控件上下间隔
#define KSHShareMenuItemTop 15
//菜单一行几个
#define kSHShareMenuPerRowItemCount 4
//菜单几行
#define kSHShareMenuPerColum 2
//页码高度
#define kSHShareMenuPageControlHeight 30

//三原色
#define RGB(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
//输入框及菜单背景颜色
#define InPutViewColor RGB(243, 243, 247, 1)
//按钮背景颜色
#define ShareMenuViewItemColor RGB(255, 255, 255, 1)

//下方控件整体高度
#define kSHInPutHeight 90

//下方输入框高度
#define kSHInPutTextHeight 40
//下方按钮整体高度
#define kSHInPutToolH 40

//下方按钮宽高
#define kSHInPutItemWH 28
//输入框控件上下
#define kSHInPutSpace 5
//输入框左右间隔
#define kSHInPut_X 10

//文本输入框最多显示几行
#define kSHTextMaxLine 5


//设备Size
#define kSHWIDTH  [[UIScreen mainScreen] bounds].size.width
#define kSHHEIGHT [[UIScreen mainScreen] bounds].size.height

//视图Size
#define kSHVIEWWIDTH  self.view.size.width
#define kSHVIEWHEIGHT self.view.size.height

//#define WEAKSELF typeof(self) weakSelf = self;

#import "SHChatMessageViewController.h"
#import "SHMessage.h"
#import "SHMessageFrame.h"
#import "SHMessageType.h"
#import "SHFileHelper.h"
#import "SHMessageTimeHelper.h"
#import "SHMessageHelper.h"
#import "SHMessageVideoHelper.h"
#import "UIImageView+SHExtension.h"
#import "SHDataConversion.h"
#import "VoiceConverter.h"

#import "SHMessageImageHelper.h"
#import "VideoPlayViewController.h"

#import "NSString+SHExtension.h"
#import "UIView+SHExtension.h"
#import "UIView+Animation.h"

#import "SHShareMenuView.h"
#import "SHEmotionKeyboard.h"
#import "SHPhotoPicker.h"

#import <AVFoundation/AVFoundation.h>


#endif /* SHMessageMacroHeader_h */

