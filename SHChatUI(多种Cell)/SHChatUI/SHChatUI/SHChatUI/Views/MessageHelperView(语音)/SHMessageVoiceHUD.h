//
//  SHMessageVoiceHUD.h
//  SHChatMessageUI
//
//  Created by CSH on 16/8/4.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 *  语音录制界面
 */
typedef enum : NSUInteger {
    SHVoiceHudType_remove = 0,//移除
    SHVoiceHudType_recording,//录音中
    SHVoiceHudType_cancel,//将要取消
    SHVoiceHudType_warning,//警告，时间太短
} SHVoiceHudType;

@interface SHMessageVoiceHUD : UIView

//界面类型
@property (nonatomic, assign) SHVoiceHudType hudType;

//实例化
+ (instancetype)shareInstance;

//显示声音声波
- (void)showVoiceMeters:(int)meter;

//显示倒计时
- (void)showCountDownWithTime:(NSInteger)time;

@end
