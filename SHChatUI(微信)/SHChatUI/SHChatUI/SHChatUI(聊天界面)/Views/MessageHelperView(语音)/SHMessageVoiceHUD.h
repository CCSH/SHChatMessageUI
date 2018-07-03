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

@interface SHMessageVoiceHUD : UIView

//(0:移除 1:文字 2:取消发送 3:警告 4:倒计时)
@property (nonatomic, assign) NSInteger hudType;

//实例化
+ (instancetype)shareInstance;

//显示声音声波
- (void)showVoiceMeters:(int)meter;

//显示倒计时
- (void)showCountDownWithTime:(NSInteger)time;

@end
