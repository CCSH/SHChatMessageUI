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

/**
 *  实例化
 */
+ (id)shareInstance;

/**
 *  界面显示
 */
- (void)showVoiceWithMessage:(NSString *)message;

/**
 *  界面消失
 */
- (void)dissmissVoiceHUD;
/**
 *  显示声音声波
 *
 *  @param meter 声波(1-20)
 */
- (void)showVoiceMeters:(int)meter;

@end
