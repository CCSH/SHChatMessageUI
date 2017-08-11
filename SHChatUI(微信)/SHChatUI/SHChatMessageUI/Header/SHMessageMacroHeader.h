//
//  SHMessageMacroHeader.h
//  SHChatMessageUI
//
//  Created by CSH on 16/7/25.
//  Copyright © 2016年 CSH. All rights reserved.
//

#ifndef SHMessageMacroHeader_h
#define SHMessageMacroHeader_h


//语音WAV路径
#define kSHAudioWAVPath [SHFileHelper getCreateFilePath:[NSString stringWithFormat:@"%@/APPData/Audio/WAV",[SHFileHelper getCachesDirectory]]]
//语音AMR路径
#define kSHAudioAMRPath [SHFileHelper getCreateFilePath:[NSString stringWithFormat:@"%@/APPData/Audio/AMR",[SHFileHelper getCachesDirectory]]]

//录音最大时长与最小
#define kSHMaxRecordTime 60
#define kSHMinRecordTime 1

//下方菜单选项宽高
#define kXHShareMenuItemWH 60
//下方菜单选项整体的高度(KXHShareMenuItemHeight - kXHShareMenuItemWH 为标题的高)
#define KXHShareMenuItemHeight 80
//下方菜单控件上下间隔
#define KXHShareMenuItemTop 15
//下方菜单一行几个
#define kSHShareMenuPerRowItemCount 4
//几行
#define kSHShareMenuPerColum 2
//页码高度
#define kSHShareMenuPageControlHeight 30

//三原色
#define RGB(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

//界面颜色
#define ControllerColor RGB(243, 243, 247, 1)

//输入框内控件距离上方高度
#define kSHInPutTop 5
//输入框高度
#define kSHInPutHeight 49
//输入框控件间隔
#define kSHInPutSpace 5

//系统Size
#define kSHWIDTH  [[UIScreen mainScreen] bounds].size.width
#define kSHHEIGHT [[UIScreen mainScreen] bounds].size.height

#define WEAKSELF typeof(self) __weak weakSelf = self;


#endif /* SHMessageMacroHeader_h */

